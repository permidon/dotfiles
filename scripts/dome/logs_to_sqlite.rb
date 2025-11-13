#!/usr/bin/env ruby
require 'aws-sdk-s3'
require 'date'
require 'optparse'
require 'json'
require 'sqlite3'
require 'zlib'
require 'stringio'
require 'open-uri'
require 'concurrent-ruby'

# Parse command line options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: s3_log_loader_to_sqlite.rb --profile PROFILE --region REGION --bucket BUCKET --start-date YYYYMMDD --end-date YYYYMMDD --db sqlite_database.db [--threads N] [--batch-size N] [--path-includes SUBSTRING] [--only-user-ids ID1,ID2] [--only-ips IP1,IP2]"

  opts.on("--profile PROFILE", "AWS profile to use") { |v| options[:profile] = v }
  opts.on("--region REGION", "AWS region to use") { |v| options[:region] = v }
  opts.on("--bucket BUCKET", "S3 bucket name") { |v| options[:bucket] = v }
  opts.on("--start-date DATE", "Start date (YYYYMMDD)") { |v| options[:start_date] = v }
  opts.on("--end-date DATE", "End date (YYYYMMDD)") { |v| options[:end_date] = v }
  opts.on("--db DATABASE", "SQLite database file") { |v| options[:db] = v }
  opts.on("--threads N", Integer, "Number of threads in the pool (default: 4)") { |v| options[:threads] = v || 4 }
  opts.on("--batch-size N", Integer, "Batch size for bulk insertion (default: 400)") { |v| options[:batch_size] = v || 400 }
  opts.on("--path-includes SUBSTRING", "Only include logs where the path contains this substring") { |v| options[:path_includes] = v }
  opts.on("--only-user-ids IDS", "Only include logs with these user_ids (comma-separated)") do |v|
    options[:only_user_ids] = v.split(',').map(&:strip).map(&:to_i)
  end
  opts.on("--only-ips IPS", "Only include logs with these IPs (comma-separated)") do |v|
    options[:only_ips] = v.split(',').map(&:strip)
  end
end.parse!

# Validate arguments
unless options[:profile] && options[:region] && options[:bucket] && options[:start_date] && options[:end_date] && options[:db]
  puts "Missing required arguments."
  puts "Usage: s3_log_loader_to_sqlite.rb --profile PROFILE --region REGION --bucket BUCKET --start-date YYYYMMDD --end-date YYYYMMDD --db sqlite_database.db [--threads N] [--batch-size N] [--path-includes SUBSTRING] [--only-user-ids ID1,ID2] [--only-ips IP1,IP2]"
  exit 1
end

# Initialize S3 client
s3 = Aws::S3::Client.new(
  region: options[:region],
  profile: options[:profile]
)

bucket_name = options[:bucket]
start_date = Date.strptime(options[:start_date], "%Y%m%d")
end_date = Date.strptime(options[:end_date], "%Y%m%d")
db_file = options[:db]
thread_count = options[:threads] || 4
batch_size = options[:batch_size] || 400
path_includes = options[:path_includes]
only_user_ids = options[:only_user_ids]
only_ips = options[:only_ips]

# Initialize SQLite DB
main_db = SQLite3::Database.new(db_file)
main_db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY,
    datetime TEXT,
    path TEXT,
    remote_ip TEXT,
    controller TEXT,
    action TEXT,
    user_id INTEGER,
    package_id INTEGER,
    admin_id INTEGER,
    building_id INTEGER
  );
SQL
main_db.close

# Thread pool
pool = Concurrent::FixedThreadPool.new(thread_count)

# Method for processing S3 log
def process_s3_log_file(s3, bucket_name, object_key, db_file, batch_size, path_includes, only_user_ids, only_ips)
  puts "Processing #{object_key}..."

  db = SQLite3::Database.new(db_file)
  db.execute("PRAGMA synchronous = OFF;")
  db.execute("PRAGMA journal_mode = WAL;")

  file = s3.get_object(bucket: bucket_name, key: object_key)
  content = Zlib::GzipReader.new(StringIO.new(file.body.read)).read

  batch = []

  content.each_line do |line|
    begin
      json = JSON.parse(line)
      attributes = json.dig('attributes', 'rails') || {}

      datetime = json['date']
      path = attributes['path']
      user_id = attributes['user_id']
      controller = attributes['controller']
      action = attributes['action']
      package_id = attributes['package_id']
      admin_id = attributes['admin_id']
      building_id = attributes['building_id']
      remote_ip = attributes['remote_ip']

      # puts user_id
      next if path.nil? || path == '/health' || path == '/active'
      next if path_includes && !path.include?(path_includes) 
      next if only_user_ids && !only_user_ids.include?(user_id)
      next if only_ips && !only_ips.include?(remote_ip)

      #puts "IN!"
      #puts attributes.inspect
      batch << [datetime, path, controller, action, user_id, package_id, admin_id, building_id, remote_ip]

      if batch.size >= batch_size
        db.execute("BEGIN TRANSACTION")
        db.execute("INSERT INTO logs (datetime, path, controller, action, user_id, package_id, admin_id, building_id, remote_ip)
                    VALUES #{(['(?, ?, ?, ?, ?, ?, ?, ?, ?)'] * batch.size).join(', ')}", batch.flatten)
        db.execute("COMMIT")
        batch.clear
      end
    rescue JSON::ParserError => e
      puts "Failed to parse JSON in #{object_key}: #{e.message}"
      return
    end
  end

  unless batch.empty?
    db.execute("BEGIN TRANSACTION")
    db.execute("INSERT INTO logs (datetime, path, controller, action, user_id, package_id, admin_id, building_id, remote_ip)
                VALUES #{(['(?, ?, ?, ?, ?, ?, ?, ?, ?)'] * batch.size).join(', ')}", batch.flatten)
    db.execute("COMMIT")
  end

  db.close
end

# Iterate through S3 logs
(start_date..end_date).each do |date|
  prefix = "dt=#{date.strftime('%Y%m%d')}/"
  # puts "Listing logs for #{date.strftime('%Y-%m-%d')}..."

  s3.list_objects_v2(bucket: bucket_name, prefix: prefix).each do |response|
    response.contents.each do |object|
      if object.key.end_with?('.json.gz')
        pool.post do
          process_s3_log_file(
            s3, bucket_name, object.key, db_file, batch_size,
            path_includes, only_user_ids, only_ips
          )
        end
      end
    end
  end
end

pool.shutdown
pool.wait_for_termination

puts "Log processing complete. Data stored in #{db_file}."

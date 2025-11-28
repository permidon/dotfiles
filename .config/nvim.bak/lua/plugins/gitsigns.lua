return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = true, -- uses default config
  opts = {
    current_line_blame = true,
    linehl = true,
  },
}

set nocompatible " be iMproved

let mapleader=","

" ================ General Config ====================

set number relativenumber       "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set hidden                      "Buffers can exist in the background
set timeout timeoutlen=1500

" ================ Turn Off Swap Files ===============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ===================

" Keep undo history across sessions, by storing in file.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile
endif

" ==================== Folds =========================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================== Scrolling =======================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" =================== Search =========================

set incsearch                     " Find the next match as we type the search
set hlsearch                      " Highlight searches by default
set ignorecase                    " Ignore case when searching...
set smartcase                     " ...unless we type a capital

"Remove highlights with leader + enter
nmap <Leader><CR> :nohlsearch<cr>

" =================== For Vundle  ====================

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" Dependencies of snipmate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"

" Git tools
Bundle 'tpope/vim-fugitive'
" Dependency managment
Bundle 'gmarik/vundle'
" Rails :/
Bundle 'tpope/vim-rails.git'
" Snippets for our use :)
Bundle 'garbas/vim-snipmate'
" Commenting and uncommenting stuff
Bundle 'tomtom/tcomment_vim'
" Molokai theme
Bundle 'tomasr/molokai'
" Vim Ruby
Bundle 'vim-ruby/vim-ruby'
" Surround your code :)
Bundle 'tpope/vim-surround'
" Every one should have a pair (Autogenerate pairs for "{[( )
Bundle 'jiangmiao/auto-pairs'
" Tab completions
Bundle 'ervandew/supertab'
" Fuzzy finder for vim (CTRL+P)
Bundle 'kien/ctrlp.vim'
" For tests
Bundle 'janko-m/vim-test'
" Navigation tree
Bundle 'scrooloose/nerdtree'
" Dispatching the test runner to tmux pane
Bundle 'tpope/vim-dispatch'

Bundle 'plasticboy/vim-markdown'

" =================== Ruby stuff =====================

syntax on                 " Enable syntax highlighting
syntax enable
filetype plugin indent on " Enable filetype-specific indenting and plugins

augroup myfiletypes
	" Clear old autocmds in group
	autocmd!
	" autoindent with two spaces, always expand tabs
	autocmd FileType ruby,eruby,yaml,markdown set ai sw=2 sts=2 et
augroup END

set tags=./tags; " Set tags directory

" ================= Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" =================== Molokai ======================
set background=dark
let g:molokai_original=1
let g:rehash256=1
set t_Co=256
colorscheme molokai

" ================ Custom Settings =================

" Window pane resizing
nnoremap <silent> <Leader>[ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>] :exe "resize " . (winheight(0) * 2/3)<CR>

" Buffer switching
map <leader>p :bp<CR> " \p previous buffer
map <leader>n :bn<CR> " \n next buffer
map <leader>d :bd<CR> " \d delete buffer

map <Leader>c :call <CR>
nmap <silent> <leader>c :TestFile<CR>
nmap <silent> <leader>s :TestNearest<CR>
map <leader>t :A<CR> " \t to jump to test file
map <leader>r :r<cr> " \t to jump to related file

set laststatus=2

" Don't be a noob, join the no arrows key movement
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Removing escape
ino jj <esc>
cno jj <c-c>
vno v <esc>

" highlight the current line
set cursorline
" Highlight active column
set cuc cul"

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

" Ruby hash syntax conversion
nnoremap <F12> :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<return>

nmap <Leader><CR> :nohlsearch<cr>

map <leader>q :NERDTreeToggle<CR>

set clipboard=unnamed

if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "dispatch"
endif

set statusline=
set statusline+=%7*\[%n]                                  "buffernr
set statusline+=%1*\ %<%F\                                "File+path
set statusline+=%2*\ %y\                                  "FileType
set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..)
set statusline+=%5*\ %{&spelllang}\%{HighlightSearch()}\  "Spellanguage & Highlight on?
set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
set statusline+=%9*\ col:%03c\                            "Colnr
set statusline+=%0*\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.

function! HighlightSearch()
  if &hls
    return 'H'
  else
    return ''
  endif
endfunction

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" ===== Seeing Is Believing =====
" " Assumes you have a Ruby with SiB available in the PATH
" " If it doesn't work, you may need to `gem install seeing_is_believing -v
" 3.0.0.beta.6`
" " ...yeah, current release is a beta, which won't auto-install
"
" " Annotate every line
"
nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>;
"
"  " Annotate marked lines
"
nmap <leader>n :%.!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>;
"
"  " Remove annotations
"
nmap <leader>c :%.!seeing_is_believing --clean<CR>;
"
"  " Mark the current line for annotation
"
nmap <leader>m A # => <Esc>
"
"  " Mark the highlighted lines for annotation
"
vmap <leader>m :norm A # => <Esc>

""""""""""""""""""""""""""""""""""""
"""    Yaragos's vim config      """
""""""""""""""""""""""""""""""""""""
" To use fzf in Vim
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
"
" set t_u7=
" set ambw=double
""" base options ============================
nnoremap <SPACE> <Nop>
let mapleader=" "
set encoding=utf-8
set nocompatible           " 与vi不兼容
set noerrorbells novisualbell
set number relativenumber
" set virtualedit=onemore
set history=200
filetype plugin indent on
syntax on
set scrolloff=5
set sidescrolloff=5
if &term =~ "xterm"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[2 q"
endif
""" 状态栏
" set showmode showcmd laststatus=2
""" 显示当前行列
set ruler
""" Auto reload changed files
set autoread
""" Only highlight the first 200 columns.
set synmaxcol=200
""" Faster redrawing.
set ttyfast
""" Only redraw when necessary.
set lazyredraw
""" Find the current line quickly.
set cursorline
highlight CursorLine cterm=NONE ctermbg=darkgrey guibg=lightgrey
""" Don't wrap long lines
set nowrap
""" Show as much as possible of the last line.
set display=lastline  
""" Show non-printable characters.
set list
set listchars=tab:»\ ,trail:·,nbsp:␣
""" Indentation width, Indent by multiple, etc
set tabstop=4 softtabstop=2 shiftwidth=2 shiftround 
set autoindent
""" Make backspace work as you would expect.
set backspace=indent,eol,start

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.
set ignorecase smartcase   " Better search action
set wrapscan               " Searches wrap around end-of-file.
" new split window
set splitbelow
set splitright
" Switch between buffers without having to save first.
set hidden
" paste / copy action
" set clipboard+=unnamed
set clipboard=unnamedplus
set mouse=a
noremap <leader>p "0p
noremap <leader>P "0P
vnoremap p pgvy
""" base keymapings =========================
" Don't use Ex mode, use Q for formatting
map Q gq
inoremap jk <Esc>
noremap H ^
noremap L $
nnoremap zj o<Esc>
nnoremap zk O<Esc>
" save
nnoremap ;w <cmd>w<CR>
noremap <C-s> <cmd>w!<CR>
" clean highlight
nnoremap <silent> <Esc> <cmd>nohl<CR>
" actions in insert mode
inoremap <C-b> <ESC>^i
inoremap <C-e> <End>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
" move window
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
" split window
noremap <leader>\| <cmd>vsp<CR>
noremap <leader>- <cmd>sp<CR>

noremap <leader>wd <cmd>close<CR>
" inc/dec window height
nnoremap <C-Up> :resize +1<CR>
nnoremap <C-Down> :resize -1<CR>
" inc/dec window width
nnoremap <C-Left> :vertical resize -1<CR>
nnoremap <C-Right> :vertical resize +1<CR>
" buffer
noremap <Tab> <cmd>bn<CR>
noremap <S-Tab> <cmd>bp<CR>
noremap ]b <cmd>bn<CR>
noremap [b <cmd>bp<CR>

" vnoremap * "ry/<C-R>r<CR>
"noremap J :m '>+1<CR>gv=gv
"noremap K :m '<-2<CR>gv=gv

""" [[ vim-Plug ]] ====================================
" PlugInstall PlugUpdate PlugUpgrade PlugStatus PlugClean[!]
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
  Plug 'tpope/vim-surround'
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'bling/vim-bufferline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-sensible'
  Plug 'jiangmiao/auto-pairs' " Provide some default settings
  Plug 'tpope/vim-commentary'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'machakann/vim-highlightedyank'
  Plug 'easymotion/vim-easymotion'
  Plug 'justinmk/vim-sneak'
call plug#end()

""" UI =================================================
" vim-airline, vim-airline-theme, bufferline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='angr'
" colorscheme purify

""" [[ Edit conveniently ]] ============================
let g:highlightedyank_highlight_duration = 200
" highlight HighlightedyankRegion ctermbg=yellow guibg=yellow
map <Leader> <Plug>(easymotion-prefix)
let g:sneak#label = 1
" let g:sneak#s_next = 1

""" [[ NERDTree ]] =====================================
let g:NERDTreeFileLines = 1
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <C-e> :NERDTreeFind<CR>
"  :NERDTreeFocus
"  :NERDTree
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

""" [[ Fuzzy Finder : CtrlP ]] ===================
" commands: CtrlP, CtrlPBuffer, CtrlPMixed
" Open `CtrlP` via '<ctrl>p' for fuzzy search of files and buffers etc,
" then press <c-f> 和 <c-b> to cycle between modes.

""" [[ autocmd ]] ================================

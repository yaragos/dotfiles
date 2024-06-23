""""""""""""""""""""""""""""""""""""
""    Yazid Lynn's vim configs    ""
""""""""""""""""""""""""""""""""""""
nnoremap <SPACE> <Nop>
let mapleader=" "
nnoremap <leader>r :source ~/.vimrc<CR>
"""base setting""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't use Ex mode, use Q for formatting
map Q gq

inoremap jk <Esc>
"noremap <C-[> <Esc>
noremap <  10zh
noremap >  10zl
noremap H ^
noremap L $

"noremap J :m '>+1<CR>gv=gv
"noremap K :m '<-2<CR>gv=gv
nnoremap K a<CR>

set nocompatible           " 与vi不兼容
set noerrorbells novisualbell
set number relativenumber  " 显示行号和相对行号
set virtualedit=onemore
set history=200
syntax on                  " Enable syntax highlighting.
set scrolloff   =5        " 垂直滚动时保留5行
set sidescrolloff=5       " 水平滚动时保留5字符
if &term =~ "xterm"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[2 q"
endif
"""window show""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmode showcmd laststatus=2 " 状态栏
set ruler                  " 显示当前行列
set autoread               " Auto reload changed files
set synmaxcol   =200       " Only highlight the first 200 columns.
set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.
set cursorline             " Find the current line quickly.
set nowrap                 " Don't wrap long lines
set display     =lastline  " Show as much as possible of the last line.
set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif
"""edit quickly""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent             " 自动缩进
set softtabstop=2 shiftwidth=2 shiftround " 设置tab缩进，缩进宽度，成倍缩进
set backspace=indent,eol,start  " Make backspace work as you would expect.
noremap <C-s> :w!<CR>
nnoremap zj o<Esc>
nnoremap zk O<Esc>
"""search operation""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.
set ignorecase smartcase   " 搜索时忽略大小写,智能匹配
set wrapscan               " Searches wrap around end-of-file.
" 清除高亮
noremap ; :nohl<CR>

"""copy and paste""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap * "ry/<C-R>r<CR>
set clipboard+=unnamed
set mouse=a
noremap <leader>p "0p
noremap <leader>P "0P
vnoremap p pgvy
"""window operation"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.
set hidden                 " Switch between buffers without having to save first.
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap \ <C-w>s
noremap \| <C-w>v
noremap \- <C-w>v
noremap <leader>x :close<CR>
"""tag/buffer operation""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap ]b :bn<CR>
noremap [b :bp<CR>
noremap [t gT
noremap ]t gt
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>

""" development settings """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nnoremap gX :set opfunc=Redact<CR>g@
" nnoremap gx :set opfunc=function('Redact')<CR>g@
" nnoremap gy :set opfunc={arg -> execute "normal `[v`]rx"}<CR>g@
" function! Redact(type)
"     execute "normal `[v`]rx"
" endfunction
"""about file"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"filetype plugin indent on  " Load plugins according to detected filetype.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
"if &shell =~# 'fish$'
"  set shell=/bin/bash
"endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

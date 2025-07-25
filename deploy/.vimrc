" VIM setup

set nocompatible        " Use Vim defaults
filetype off
set undofile
set undodir=~/.vim/undo
set modeline            " modeline detection
set modelines=5

" Vundle setup
if has('win32') || has('win64')
  set rtp+=~/vimfiles/bundle/Vundle.vim
else
  set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#begin()

if has('win32') || has('win64')
  call vundle#rc('$HOME/vimfiles/bundle/')
endif

call vundle#end()

Plugin 'VundleVim/Vundle.vim'
Plugin 'dracula/vim'
Plugin 'kien/ctrlp.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'tomasiser/vim-code-dark'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sheerun/vim-polyglot'
Plugin 'Chiel92/vim-autoformat'
Plugin 'joshdick/onedark.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'fatih/vim-go'
Plugin 'arcticicestudio/nord-vim'
" This is curremtly broken on Catalina
"Plugin 'zxqfl/tabnine-vim'

let g:airline_powerline_fonts = 1


if !exists("g:os")
  if has("win64") || has("win32") || has("win16")
    let g:os = "Windows"
  else
    let g:os = substitute(system('uname'), '\n', '', '')
  endif
endif


" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" If you're using tmux version 2.2 or later, you can remove the outermost $TMUX
" check and use tmux's 24-bit color support. see
" http://sunaku.github.io/tmux-24bit-color.html#usage for more information.
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


syntax on

if filereadable($HOME . "/.theme-monokai")
  colorscheme hybrid
elseif filereadable($HOME . "/.theme-dracula")
  colorscheme dracula

  if !has('win32') && !has('win64')
    let g:airline_theme = 'dracula'
  endif
elseif filereadable($HOME . "/.theme-zenburn")
  colorscheme zenburn
  let g:airline_theme = 'zenburn'
elseif filereadable($HOME . "/.theme-nord")
  colorscheme nord
elseif filereadable($HOME . "/.theme-codedark")
  colorscheme codedark
  let g:airline_theme = 'codedark'
elseif filereadable($HOME . "/.theme-onedark")
  if g:os != "Darwin"
    let g:onedark_terminal_italics = 1
  endif

  let g:airline_theme = 'onedark'
  colorscheme onedark
else                                " default to solarized
  "let g:solarized_termcolors=256
  "set t_Co=256
  set background=dark
  colorscheme solarized
  let g:airline_theme = 'solarized'
endif


if has("gui_running")
  set lines=50
  set columns=80

  if has("gui_win32")
    "set guifont=Hack:h10
    set guifont=Berkeley\ Mono:h11
  else
    "set guifont=Hack\ 10
    set guifont=Berkeley\ Mono\ 11
  endif

  set guioptions-=T     " remove toolbar
  set guioptions-=m     " remove menu
endif

"let g:mapleader = ";"
set bs=2                " allow backspacing over everything in insert mode
set ic                  " case-insensitive search
set hlsearch            " highlite search results
set scs                 " revert to case-sensitive search on mixed case
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
" than 50 lines of registers
set history=100         " 100 lines of command line history
set ruler               " show the cursor position all the time
set textwidth=80

" disable bleeping
set noerrorbells visualbell t_vb=

if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" indentation setup
set expandtab
set softtabstop=4
set shiftwidth=4
set smartindent
set relativenumber
set cursorline
map Q gq

scriptencoding utf-8
set encoding=utf-8
set showbreak=↪\
set list listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:»,precedes:«

" mark columns beyond 80
"let &colorcolumn=join(range(80,999),",")
"highlight ColorColumn ctermbg=235 guibg=#6272a4

" allow switching of paste mode
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O><F2>
set pastetoggle=<F2>


" show Tab characters
syntax match Tab /\t/
hi Tab guibg=blue ctermbg=blue


if has("autocmd")

  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  autocmd BufRead *.go set nolist

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif

  " ..but not for VC commit message files
  autocmd BufReadPost COMMIT_EDITMSG
        \ exe "normal! gg"

  autocmd BufWrite * if index(['yaml', 'anotherformat'], &filetype) < 0 | Autoformat | endif
endif


set foldmethod=indent
set foldlevel=99

" Autoformat

let g:autoformat_autoindent = 0
let g:autoformat_retab = 1
let g:autoformat_remove_trailing_spaces = 1

" CtrlP

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Vim-GO

filetype plugin on
set number
let g:go_disable_autoinstall = 0
autocmd Filetype go setlocal noet tabstop=8

" status line

set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set laststatus=2

" source local tweaks

let s:local_script = $HOME . "/.vimrc.local"
if filereadable(s:local_script)
  execute 'source' s:local_script
endif

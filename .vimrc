" VIM setup

set nocompatible        " Use Vim defaults
filetype off

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
let g:airline_powerline_fonts = 1


" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
  syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
  hi def link cppFuncDef Special
endfunction

autocmd Syntax cpp call EnhanceCppSyntax()
autocmd Syntax cc call EnhanceCppSyntax()
autocmd Syntax cxx call EnhanceCppSyntax()
autocmd Syntax c call EnhanceCppSyntax()
autocmd Syntax java call EnhanceCppSyntax()


syntax on
"let g:solarized_termcolors=256
"set t_Co=256
"set background=dark

if filereadable($HOME . "/.theme-monokai")
    colorscheme hybrid
elseif filereadable($HOME . "/.theme-dracula")
    colorscheme dracula
    let g:airline_theme = 'dracula'
elseif filereadable($HOME . "/.theme-codedark")
    colorscheme codedark
    let g:airline_theme = 'codedark'
elseif filereadable($HOME . "/.theme-onedark")
    colorscheme onedark
    let g:airline_theme = 'onedark'
else
    colorscheme solarized
endif

if has("gui_running")
    set lines=50
    set columns=80

    if has("gui_win32")
        set guifont=Hack:h10
    else
        set guifont=Hack\ 10
    endif

    "if has("gui_gtk2")
    "    set guifont=Inconsolata\ 10
    "elseif has("gui_macvim")
    "    set guifont=Menlo\ Regular:h14
    "elseif has("gui_win32")
        "set lines=50
        "set guifont=Consolas:h10
    "endif
    "set guifont=Dejavu\ Sans\ Mono\ 10

    set guioptions-=T  "remove toolbar
    set guioptions-=m  "remove menu
endif

" other setup
set bs=2                " allow backspacing over everything in insert mode
set ic                  " case-insensitive search
set hlsearch            " highlite search results
set scs                 " revert to case-sensitive search on mixed case
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set history=100         " keep 50 lines of command line history
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
set autoindent
set number
map Q gq

scriptencoding utf-8
set encoding=utf-8
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\


" allow switching of paste mode
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O><F2>
set pastetoggle=<F2>


" show Tabs
syntax match Tab /\t/
hi Tab guibg=blue ctermbg=blue


" Only do this part when compiled with support for autocommands

if has("autocmd")

    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g'\"" |
                \ endif

    " ..but not for VC commit message files
    autocmd BufReadPost COMMIT_EDITMSG
                \ exe "normal! gg"

    autocmd BufWritePre *
                \ :%s/\s\+$//e

endif


set foldmethod=indent
set foldlevel=99


" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


" Vim-GO
filetype plugin on
set number
let g:go_disable_autoinstall = 0

set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set laststatus=2

" source local tweaks
let s:local_script = $HOME . "/.vimrc.local"
if filereadable(s:local_script)
    execute 'source' s:local_script
endif


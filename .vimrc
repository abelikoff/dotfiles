" VIM setup

" Pathogen
execute pathogen#infect()
filetype plugin indent on

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


syntax enable
set background=dark

if filereadable($HOME . "/.theme-monokai")
    colorscheme molokai
else
    colorscheme solarized
    hi statusLine cterm=NONE ctermfg=12 ctermbg=0

    " change status line color in insert mode
    if version >= 700
        au InsertLeave * highlight StatusLine cterm=NONE ctermfg=12 ctermbg=0
        au InsertEnter * highlight StatusLine cterm=NONE ctermfg=black ctermbg=3
    endif
endif

if has("gui_running")
    set lines=50
    set columns=80
    "set guifont=Consolas:11

    if has("gui_gtk2")
        set guifont=Inconsolata\ 10
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h11
    endif

    set guioptions-=T  "remove toolbar
    set guioptions-=m  "remove menu
endif

" other setup
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " allow backspacing over everything in insert mode
set ic                  " case-insensitive search
set hlsearch            " highlite search results
set scs                 " revert to case-sensitive search on mixed case
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set history=100         " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set textwidth=80

" indentation setup
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent
set number
map Q gq

set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅


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


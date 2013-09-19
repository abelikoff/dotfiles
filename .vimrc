" $Id$


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
"colorscheme sasha
"colorscheme darkgraymild
"colorscheme bluegreen
"colorscheme sasha4
"colorscheme milkyway
colorscheme zenburn

if has("gui_running")
   set lines=50
   set columns=80
   set guifont=Lucida_Console:h10

   set guioptions-=T  "remove toolbar
   set guioptions-=m  "remove menu
endif

" other setup
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " allow backspacing over everything in insert mode
set ai                  " always set autoindenting on
set ic                  " case-insensitive search
set hlsearch            " highlite search results
set scs                 " revert to case-sensitive search on mixed case
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
                        " than 50 lines of registers
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set textwidth=80

" indentation setup
set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
map Q gq


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
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif

endif

"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)

set foldmethod=indent
set foldlevel=99

"filetype off
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

map <silent><f3> :NEXTCOLOR<cr>
map <silent><f2> :PREVCOLOR<cr>


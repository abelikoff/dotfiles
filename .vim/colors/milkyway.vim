" Colorscheme: milkyway
" Author: Alexander L. Belikoff <abelikoff@gmail.com>
"
" Based on numerous other color schemes
"

set background=dark


hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = "milkyway"

" Default Colors
hi Normal       ctermbg=16 ctermfg=250 guifg=Gray guibg=Black
hi NonText      guifg=#555753 guibg=#000000 gui=none
hi NonText      ctermfg=darkgray
hi Cursor       ctermfg=Red guibg=Red
hi lCursor      ctermfg=Red guibg=Red
hi LineNR       ctermfg=DarkCyan

" Search
hi Search       cterm=none ctermfg=White ctermbg=Blue guifg=#eeeeec guibg=#c4a000
hi IncSearch    guibg=#eeeeec guifg=#729fcf
hi IncSearch    cterm=none ctermfg=yellow ctermbg=green

" Window Elements
hi StatusLine   ctermfg=Black ctermbg=Cyan cterm=bold guifg=Black guibg=Cyan gui=bold
hi StatusLineNC ctermfg=Black ctermbg=Gray cterm=bold guifg=Black guibg=Gray gui=bold
hi VertSplit    guifg=#eeeeec guibg=#eeeeec
hi Folded       ctermfg=white ctermbg=magenta guifg=#eeeeec guibg=#75507b
hi Visual       guifg=#d3d7cf guibg=#4e9a06
hi Visual       ctermbg=white ctermfg=lightgreen cterm=reverse

" Specials
hi Todo         guifg=#8ae234 guibg=#4e9a06 gui=bold
hi Todo         ctermfg=white ctermbg=green
hi Title        guifg=#eeeeec gui=bold
hi Title        ctermfg=white cterm=bold

" Syntax
hi Constant     ctermfg=LightGreen guifg=LightGreen
hi Number       ctermfg=LightGreen guifg=LightGreen
hi String       ctermfg=172 guifg=DarkOrange
hi Special      ctermfg=LightGreen guifg=LightGreen
hi Statement    ctermfg=29 cterm=bold guifg=SeaGreen gui=bold
hi Identifier   ctermfg=darkgreen guifg=#8ae234
hi PreProc      ctermfg=Yellow cterm=bold guifg=Yellow gui=bold
hi Comment      ctermfg=26 cterm=none guifg=#3A5FCD gui=italic
hi Type         ctermfg=29 cterm=bold guifg=SeaGreen gui=bold
hi Error        ctermfg=white ctermbg=red guifg=#eeeeec guibg=#ef2929
hi cppFuncDef   ctermfg=Magenta cterm=bold guifg=Magenta gui=bold

" Diff
hi DiffAdd      guifg=fg guibg=#3465a4 gui=none
hi DiffAdd      ctermfg=gray ctermbg=blue cterm=none
hi DiffChange   guifg=fg guibg=#555753 gui=none
hi DiffChange   ctermfg=gray ctermbg=darkgray cterm=none
hi DiffDelete   guibg=bg
hi DiffDelete   ctermfg=gray ctermbg=none cterm=none
hi DiffText     guifg=fg guibg=#c4a000 gui=none
hi DiffText     ctermfg=gray ctermbg=yellow cterm=none

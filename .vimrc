" ============
" =   Core   =
" ============
if !exists("g:syntax_on")
    syntax enable
endif
filetype plugin indent on
set magic
"set bg=light
" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee > /dev/null %
set wildmenu
set hidden
set nohlsearch
set autoindent
set smartindent
set number
set relativenumber
set showmatch
set showcmd
set incsearch
set ttyfast
set showmode
set encoding=utf-8
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
set laststatus=2
set tags=.git/tags;$HOME
set updatetime=250
set signcolumn=yes

" ====================
" = FileType Options =
" ====================
au FileType sh setl et ts=2 sts=2 sw=2 tw=80
au BufRead,BufNewFile Vagrantfile set filetype=Vagrant
au FileType Vagrant setl syntax=ruby
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" ===========
" = Plugins =
" ===========
packadd matchit

" =============
" = Behaviour =
" =============
map <C-J> :bprev!<CR>
map <C-K> :bnext!<CR>
set pastetoggle=<INS>
" We have to set this, otherwise the highlight is missing
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ ,
nnoremap <leader>l :set list!<CR>
command ClearWhitespaces :%s/\s\+$//e
if &diff
    map <silent> <leader><Left> :diffget LOCAL<CR>
    map <silent> <leader><Right> :diffget REMOTE<CR>
    map <silent> <leader><Up> :diffget BASE<CR>
endif

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "seti"

hi Cursor                       ctermfg=16    ctermbg=222   cterm=NONE          guifg=#151718   guibg=#ffe792   gui=NONE
hi Visual                       ctermfg=NONE  ctermbg=74    cterm=NONE          guifg=NONE      guibg=#4fa5c7   gui=NONE
hi CursorLine                   ctermfg=NONE  ctermbg=235   cterm=NONE          guifg=NONE      guibg=#282a2b   gui=NONE
hi CursorColumn                 ctermfg=NONE  ctermbg=235   cterm=NONE          guifg=NONE      guibg=#282a2b   gui=NONE
hi ColorColumn                  ctermfg=NONE  ctermbg=235   cterm=NONE          guifg=NONE      guibg=#282a2b   gui=NONE
hi LineNr                       ctermfg=243   ctermbg=235   cterm=NONE          guifg=#757777   guibg=#282a2b   gui=NONE
hi VertSplit                    ctermfg=239   ctermbg=239   cterm=NONE          guifg=#4c4f4f   guibg=#4c4f4f   gui=NONE
hi MatchParen                   ctermfg=149   ctermbg=NONE  cterm=underline     guifg=#9fca56   guibg=NONE      gui=underline
hi StatusLine                   ctermfg=188   ctermbg=239   cterm=bold          guifg=#d4d7d6   guibg=#4c4f4f   gui=bold
hi StatusLineNC                 ctermfg=188   ctermbg=239   cterm=NONE          guifg=#d4d7d6   guibg=#4c4f4f   gui=NONE
hi Pmenu                        ctermfg=NONE  ctermbg=NONE  cterm=NONE          guifg=NONE      guibg=NONE      gui=NONE
hi PmenuSel                     ctermfg=NONE  ctermbg=74    cterm=NONE          guifg=NONE      guibg=#4fa5c7   gui=NONE
hi IncSearch                    ctermfg=16    ctermbg=74    cterm=NONE          guifg=#151718   guibg=#55b5db   gui=NONE
hi Search                       ctermfg=NONE  ctermbg=NONE  cterm=underline     guifg=NONE      guibg=NONE      gui=underline
hi Directory                    ctermfg=167   ctermbg=NONE  cterm=NONE          guifg=#cd3f45   guibg=NONE      gui=NONE
hi Folded                       ctermfg=59    ctermbg=16    cterm=NONE          guifg=#41535b   guibg=#151718   gui=NONE

hi Normal                       ctermfg=188   ctermbg=16    cterm=NONE          guifg=#d4d7d6   guibg=#151718   gui=NONE
hi Boolean                      ctermfg=167   ctermbg=NONE  cterm=NONE          guifg=#cd3f45   guibg=NONE      gui=NONE
hi Character                    ctermfg=167   ctermbg=NONE  cterm=NONE          guifg=#cd3f45   guibg=NONE      gui=NONE
hi Comment                      ctermfg=59    ctermbg=NONE  cterm=NONE          guifg=#41535b   guibg=NONE      gui=NONE
hi Conditional                  ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi Constant                     ctermfg=167   ctermbg=NONE  cterm=NONE          guifg=#cd3f45   guibg=NONE      gui=NONE
hi Define                       ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi DiffAdd                      ctermfg=188   ctermbg=64    cterm=bold          guifg=#d4d7d6   guibg=#43800a   gui=bold
hi DiffDelete                   ctermfg=88    ctermbg=NONE  cterm=NONE          guifg=#870505   guibg=NONE      gui=NONE
hi DiffChange                   ctermfg=188   ctermbg=23    cterm=NONE          guifg=#d4d7d6   guibg=#1a3150   gui=NONE
hi DiffText                     ctermfg=188   ctermbg=24    cterm=bold          guifg=#d4d7d6   guibg=#204a87   gui=bold
hi ErrorMsg                     ctermfg=231   ctermbg=NONE  cterm=NONE          guifg=#f8f8f8   guibg=NONE      gui=NONE
hi WarningMsg                   ctermfg=231   ctermbg=NONE  cterm=NONE          guifg=#f8f8f8   guibg=NONE      gui=NONE
hi Float                        ctermfg=167   ctermbg=NONE  cterm=NONE          guifg=#cd3f45   guibg=NONE      gui=NONE
hi Function                     ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE
hi Identifier                   ctermfg=185   ctermbg=NONE  cterm=NONE          guifg=#e6cd69   guibg=NONE      gui=NONE
hi Keyword                      ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi Label                        ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE
hi NonText                      ctermfg=73    ctermbg=0     cterm=NONE          guifg=#abaee8   guibg=#151718   gui=NONE
hi Number                       ctermfg=167   ctermbg=NONE  cterm=NONE          guifg=#cd3f45   guibg=NONE      gui=NONE
hi Operator                     ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi PreProc                      ctermfg=197   ctermbg=NONE  cterm=NONE          guifg=#ff026a   guibg=NONE      gui=NONE
hi Special                      ctermfg=188   ctermbg=NONE  cterm=NONE          guifg=#d4d7d6   guibg=NONE      gui=NONE
hi SpecialKey                   ctermfg=73    ctermbg=235   cterm=NONE          guifg=#abaee8   guibg=#282a2b   gui=NONE
hi Statement                    ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi StorageClass                 ctermfg=185   ctermbg=NONE  cterm=NONE          guifg=#e6cd69   guibg=NONE      gui=NONE
hi String                       ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE
hi Tag                          ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE
hi Title                        ctermfg=188   ctermbg=NONE  cterm=bold          guifg=#d4d7d6   guibg=NONE      gui=bold
hi Todo                         ctermfg=59    ctermbg=NONE  cterm=inverse,bold  guifg=#41535b   guibg=NONE      gui=inverse,bold
hi Type                         ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE
hi Underlined                   ctermfg=NONE  ctermbg=NONE  cterm=underline     guifg=NONE      guibg=NONE      gui=underline

hi yamlKey                      ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE
hi yamlAnchor                   ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi yamlAlias                    ctermfg=149   ctermbg=NONE  cterm=NONE          guifg=#9fca56   guibg=NONE      gui=NONE
hi yamlDocumentHeader           ctermfg=74    ctermbg=NONE  cterm=NONE          guifg=#55b5db   guibg=NONE      gui=NONE

" ========
" = Look =
" ========
highlight SignColumn ctermbg=NONE
highlight Pmenu ctermbg=black ctermfg=grey
highlight PmenuSel ctermbg=black ctermfg=green
highlight WildMenu ctermbg=black ctermfg=green
highlight StatusLine ctermbg=NONE ctermfg=grey
highlight VertSplit ctermbg=black ctermfg=green
highlight Visual ctermbg=green ctermfg=black
highlight LineNr ctermbg=NONE ctermfg=darkgrey
highlight CursorLineNr ctermbg=black ctermfg=darkgrey
highlight Search ctermbg=green ctermfg=black
highlight IncSearch ctermbg=green ctermfg=black
highlight DiffAdd ctermbg=black ctermfg=green
highlight DiffDelete ctermbg=black ctermfg=red
highlight DiffChange ctermbg=black ctermfg=grey
highlight DiffText ctermbg=black ctermfg=yellow
highlight FoldColumn ctermbg=black ctermfg=grey
highlight SpellBad ctermbg=black ctermfg=red
highlight SpellCap ctermbg=black ctermfg=yellow
highlight QuickFixLine ctermbg=black ctermfg=green
highlight CursorLine ctermbg=black ctermfg=green
highlight NonText ctermbg=NONE
highlight EndOfBuffer ctermbg=NONE
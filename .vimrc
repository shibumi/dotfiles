" ==================
" = Plugin-Manager =
" ==================
if &compatible
  set nocompatible
endif
if !exists($HOME)
    let $HOME=expand('~')
endif
let s:dein_base = $HOME . '/.vim/bundles'
let s:dein_repo_url = 'https://github.com/Shougo/dein.vim'
let s:dein_repo_path = s:dein_base . '/repos/github.com/Shougo/dein.vim'
let &runtimepath.=','.s:dein_repo_path

try
    if dein#load_state(s:dein_base)
      call dein#begin(s:dein_base)

      call dein#add(s:dein_repo_path)
      call dein#add('Shougo/deoplete.nvim')
      call dein#add('Shougo/denite.nvim')
      call dein#add('tpope/vim-fugitive', { 'rev': 'cde670ee81e4fd0945e97111d08a901788c3922b' })
      call dein#add('Raimondi/delimitMate')
      call dein#add('w0rp/ale')
      call dein#add('fatih/vim-go')
      call dein#add('Shougo/neosnippet.vim')
      call dein#add('Shougo/neosnippet-snippets')
      call dein#add('airblade/vim-gitgutter')
      call dein#add('vim-airline/vim-airline')
      call dein#add('vim-airline/vim-airline-themes')
      call dein#add('tpope/vim-surround')
      call dein#add('tpope/vim-commentary')
      call dein#add('junegunn/vim-easy-align')
      call dein#add('pearofducks/ansible-vim')
      call dein#add('chriskempson/base16-vim')
      if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
      endif
      call dein#end()
      call dein#save_state()
    endif
catch /E117:/
    execute "silent !git clone" s:dein_repo_url s:dein_repo_path
    quit
endtry

" ============
" =   Core   =
" ============
if !exists("g:syntax_on")
    syntax enable
endif
filetype plugin indent on
set magic
set bg=light
" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee > /dev/null %
set wildmenu
set hidden
set nohlsearch
set autoindent
set smartindent
set number
set showmatch
set showcmd
set incsearch
set ttyfast
" We are using a powerline.. so we don't need this
set showmode!
set encoding=utf-8
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
set laststatus=2
set guifont=PowerlineSymbols
set tags=.git/tags;$HOME
set updatetime=250
set signcolumn=yes

" ====================
" = FileType Options =
" ====================
au BufRead,BufNewFile PKGBUILD set filetype=PKGBUILD
au BufRead,BufNewFile *.install set filetype=INSTALL
au BufRead,BufNewFile Vagrantfile set filetype=Vagrant
au FileType Vagrant setl syntax=ruby
au FileType PKGBUILD setl syntax=sh
au FileType INSTALL setl syntax=sh

" ===========
" = Plugins =
" ===========
packadd matchit
if dein#tap('vim-airline')
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts = 0
    let g:airline#extensions#ale#enabled = 1
    if dein#tap('vim-airline-themes')
        let g:airline_theme='base16color'
    endif
endif
if dein#tap('vim-gitgutter')
    let g:gitgutter_override_sign_column_highlight = 0
endif
let g:python_recommended_style = 1

" ========
" = Look =
" ========
if dein#tap('base16-vim')
    colorscheme base16-seti-ui
endif
highlight ExtraWhitespace ctermbg=red guibg=red
highlight SignColumn ctermbg=black
highlight GitGutterAdd ctermbg=black ctermfg=green
highlight GitGutterChange ctermbg=black ctermfg=yellow
highlight GitGutterDelete ctermbg=black ctermfg=red
highlight GitGutterChangeDelete ctermbg=black ctermfg=red
highlight Pmenu ctermbg=black ctermfg=grey
highlight PmenuSel ctermbg=black ctermfg=green
highlight WildMenu ctermbg=black ctermfg=green
highlight StatusLine ctermbg=black ctermfg=grey
highlight VertSplit ctermbg=black ctermfg=green
highlight Visual ctermbg=green ctermfg=black
highlight LineNr ctermbg=black ctermfg=darkgrey
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
highlight ALEErrorSign ctermbg=black ctermfg=darkred
highlight AleWarningSign ctermbg=black ctermfg=darkyellow

" =============
" = Behaviour =
" =============
map <C-J> :bprev!<CR>
map <C-K> :bnext!<CR>
set pastetoggle=<INS>
match ExtraWhitespace /\s\+$\| \+\ze\t/
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ ,
nnoremap <leader>l :set list!<CR>
command ClearWhitespaces :%s/\s\+$//e
if &diff
    map <silent> <leader><Left> :diffget LOCAL<CR>
    map <silent> <leader><Right> :diffget REMOTE<CR>
    map <silent> <leader><Up> :diffget BASE<CR>
endif
" Upload to filebin
com! -range=% Fb :exec "<line1>,<line2>w !fb -e " . &filetype . " -n " . expand("%:t")
" Format Python Code
com! -range=% Yapf :exec "0,$!yapf"
" fugitive git bindings
if dein#tap('vim-fugitive')
    nnoremap <leader>ga :Git add %:p<CR><CR>
    nnoremap <leader>gap :Git add -p %:p<CR><CR>
    nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gc :Gcommit -v<CR>
    nnoremap <leader>gt :Gcommit -v %:p<CR>
    nnoremap <leader>gd :Gdiff<CR>
    nnoremap <leader>ge :Gedit<CR>
    nnoremap <leader>gr :Gread<CR>
    nnoremap <leader>gw :Gwrite<CR><CR>
    nnoremap <leader>gl :Glog<CR>:bot copen<CR>
    nnoremap <leader>gp :Ggrep<Space>
    nnoremap <leader>gm :Gmove<Space>
    nnoremap <leader>gb :Git branch<Space>
    nnoremap <leader>go :Git checkout<Space>
    nnoremap <leader>gph :Gpush<CR>
    nnoremap <leader>gpht :Gpush --tags<CR>
    nnoremap <leader>gpl :Gpull<CR>
endif

if dein#tap('deoplete.nvim')
    let g:deoplete#enable_at_startup = 1
endif

if dein#tap('denite.nvim')
    nnoremap <leader>s :Denite file_rec<CR>
endif

if dein#tap('delimitMate')
    let delimitMate_expand_cr = 1
    let delimitMate_expand_space = 1
endif

if dein#tap('vim-easy-align')
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endif

if dein#tap('neosnippet.vim')
    map <Nul> <C-Space>
    map! <Nul> <C-Space>
    imap <C-Space>     <Plug>(neosnippet_expand_or_jump)
    smap <C-Space>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-Space>     <Plug>(neosnippet_expand_target)
endif

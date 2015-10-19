set nocompatible " Use vim settings, rather than vi

" Use vundle to load plugins
if filereadable(expand('~/.vimrc.bundles'))
  source ~/.vimrc.bundles
endif

filetype indent plugin on             " Enable filetype detection and specific indenting

syntax on                             " Syntax highlighting

set encoding=utf-8 fileencoding=utf-8

set ruler                             " Show the line number on the bar
set more                              " Use more prompt
set autoread                          " Watch for file changes
set number                            " Line numbers
set numberwidth=1                     " Min width of number column to the left
set hidden                            " Hide buffers instead of closing them
set noautowrite                       " Don't automagically write on :next
set lazyredraw                        " Don't redraw when we don't have to
set showmode
set showcmd

" *** Indents and Tabs

set autoindent                        " Set the cursor at same indentation level as line above
set smartindent                       " Try to be smart about indenting (C-style)
set expandtab                         " Expand <Tab>s to spaces
set shiftwidth=2                      " Spaces for each step of (auto)indent
set softtabstop=2                     " Set virtual tab stop (compat for 8-wide tabs)
set tabstop=2                         " For proper display of files with tabs
set shiftround                        " Always round indents to multiples of shiftwidth
set copyindent                        " Use existing indents for new indents
set preserveindent                    " Save as much indent structure as possible
set virtualedit=onemore

set scrolloff=5                       " Keep at least 5 lines above / below
set sidescrolloff=5                   " Keep at least 5 lines left / right
set history=200
set backspace=indent,eol,start        " Allow backspacing over everything
set linebreak
set cmdheight=1                       " Command line one line high
set undolevels=1000                   " 1000 undos
set updatecount=100                   " Switch every 100 characters
set complete=.,w,b,u,U,t,i,d          " Do lots of scanning on tab completion
set ttyfast                           " We have a fast terminal
set shell=bash
set fileformats=unix
set ff=unix

" *** Searching

set incsearch                         " Incremental search
set ignorecase                        " Search ignoring case
set showmatch                         " Show matching bracket
set smartcase                         " Search ignore case unless one character is uppercase
set hlsearch                          " Highlight the search
set diffopt=filler,iwhite             " Ignore all whitespace and sync
set gdefault                          " Substitute globally on lines

" Fix default regexp handling by inserting \v before any search string
nnoremap / /\v
vnoremap / /\v

" Disable swp files
set noswapfile
set nobackup
set nowritebackup
set backup

" Directories for swp files
set backupdir=$HOME/.vim/backup/
set directory=$HOME/.vim/backup/

set title                             " Change the terminal's title
set visualbell                        " Don't beep
set noerrorbells                      " No error bells, please

" Enable mouse in all modes
set mouse=a

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Always show status line
set laststatus=2

" Selection exclusive
set selection=exclusive

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Resize splits when the window is resized
au VimResized * :wincmd =

" Show invisible characters
set list listchars=tab:»·,trail:·,nbsp:·

" Autocomplete settings
set completeopt=longest,menuone

set wildmenu                                     " Turn on wild menu
set wildmode=list:longest,full                   " Wildmenu completion
set wildignore+=.hg,.git,.svn                    " Source control
set wildignore+=*.dll,*.exe,*.manifest,*.o,*.obj " Compiled object files
set wildignore+=*.sw?                            " Vim swap files

" *** Look and Feel

" Cursor look and feel
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

set background=dark

" Default color scheme
color seti

set fillchars=vert:│ " Solid line for vsplit separator
set cursorline       " Highlight current line

" *** Spellcheck

" Spelling highlights. Use underline in term to prevent cursorline highlights
" from interfering.
if !has('gui_running')
  hi clear SpellBad
  hi SpellBad cterm=underline ctermfg=red
  hi clear SpellCap
  hi SpellCap cterm=underline ctermfg=blue
  hi clear SpellLocal
  hi SpellLocal cterm=underline ctermfg=blue
  hi clear SpellRare
  hi SpellRare cterm=underline ctermfg=blue
endif

" *** Filetype

" Set syntax highlighting for specific file types
autocmd BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,config.ru,*_spec\.rb} set ft=ruby
autocmd BufRead,BufNewFile *.md set ft=markdown
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

" Enable spellcheck for Markdown
autocmd Filetype markdown setlocal spell

" Automatically wrap at 80 characters for Markdown
autocmd BufRead,BufNewFile *.md setlocal textwidth=80

" Automatically wrap at 72 characters and spellcheck git commit messages
autocmd Filetype gitcommit setlocal textwidth=72
autocmd Filetype gitcommit setlocal spell

" *** Mappings

" Set <Leader> to ,
let mapleader=','
let maplocalleader='\\'

" Escape edit mode with jj
inoremap jj <esc>
inoremap jk <esc>

" Quickly edit / reload this file
nmap <silent> <leader>ev :e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>

" Line wrapping is enabled, cursor down will jump over the current line
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" Open new vertical split and switch over to it
nnoremap <leader>w <C-w>v<C-w>l

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<cr>
nnoremap <cr> :nohlsearch<cr>

" Execute dot in the selection
vnoremap . :norm.<cr>

" Visual shifting (does not exit visual mode)
vnoremap < <gv
vnoremap > >gv

" *** Plugins

" vim-ruby
let g:rubycomplete_buffer_loading=1
let g:rubycomplete_classes_in_global=1
let g:rubycomplete_rails=1

" Use The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command='ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching=0
endif

" NERDTree
map <leader>n :NERDTreeFind<cr>
map <c-n> :NERDTreeTabsToggle<cr>

" CtrlP
map <leader>p :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>r :CtrlPBufTag<cr>
let g:ctrlp_working_path_mode=2 " Smart path mode
let g:ctrlp_mru_files=1 " Enable most-recently-used files feature
let g:ctrlp_jump_to_buffer=2 " Jump to tab and buffer if already open
let g:ctrlp_custom_ignore=&wildignore . '*/.git/*,*/.hg/*,*/.svn/*,*/bower_components/*,*/node_modules/*'

" Syntastic
map <leader>e :Errors<cr>
let g:syntastic_check_on_open=1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_javascript_checkers = ['eslint']

" *** Custom Functions

" Clear whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

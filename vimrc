set nocompatible " Use vim settings, rather than vi

" Use vundle to load plugins
if filereadable(expand('~/.vimrc.bundles'))
  source ~/.vimrc.bundles
endif

filetype indent plugin on             " Enable filetype detection and specific indenting

syntax on                             " Syntax highlighting

set encoding=utf-8 fileencoding=utf-8

set noruler                           " Don't show line / column number in status line (for speed)
set more                              " Use more prompt
set autoread                          " Watch for file changes
set number                            " Line numbers
set numberwidth=1                     " Min width of number column to the left
set hidden                            " Hide buffers instead of closing them
set noautowrite                       " Don't automagically write on :next
set lazyredraw                        " Don't redraw when we don't have to
set showmode
set noshowcmd                         " Don't show command keys in status line (for speed)

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
set virtualedit=all                   " Allow the cursor to go to 'invalid' places

set scrolloff=5                       " Keep at least 5 lines above / below
set sidescrolloff=5                   " Keep at least 5 lines left / right
set scrolljump=5                      " Scroll 5 lines at a time at bottom/top
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
set noshowmatch                       " Don't show matching bracket
set smartcase                         " Search ignore case unless one character is uppercase
set hlsearch                          " Highlight the search
set diffopt=filler,iwhite             " Ignore all whitespace and sync
set gdefault                          " Substitute globally on lines

" Fix default regexp handling by inserting \v before any search string
nnoremap / /\v
vnoremap / /\v

" *** Vim Bookkeeping

" Disable swp files
set noswapfile
set nobackup
set nowritebackup

set backupdir=$HOME/.vim/backup/      " In case backup is ever turned back on
set directory=$HOME/.vim/backup/      " In case swapfile is ever turned back on

" Keep a persistent undo file
if exists('&undofile')
  set undofile
  set undodir=$HOME/.vim/undo/
endif

set title                             " Change the terminal's title
set visualbell                        " Don't beep
set noerrorbells                      " No error bells, please

" Enable mouse in all modes
set mouse=a

" Make it obvious where 80 characters is
if exists("+colorcolumn")
  set colorcolumn=81
endif

" Status line
set statusline=
set statusline+=%-4.3n\               " Buffer number
set statusline+=%f\                   " Filename

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

if (&t_Co == 256 || &t_Co == 88) && filereadable(expand("~/.vimrc_background"))
  " Base16 updates a ~/.vimrc_background file that will have the current color
  " scheme, so we just need to source this file and let base16 know to enable
  " 256-color mode
  let base16colorspace=256
  source ~/.vimrc_background
else
  " Otherwise, fall back to the default Vim theme
  colorscheme default
endif

set fillchars=vert:│ " Solid line for vsplit separator

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

augroup tab_settings
  autocmd!

  " Soft tabs, 2 spaces
  autocmd FileType html setlocal ts=2 sts=2 sw=2
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby setlocal ts=2 sts=2 sw=2
augroup END

augroup filetype_gitcommit
  autocmd!

  " Wrap lines at 72 characters
  autocmd FileType gitcommit setlocal textwidth=72
  " Enable spell checking
  autocmd FileType gitcommit setlocal spell
augroup END

augroup filetype_handlebars
  autocmd!

  autocmd BufRead,BufNewFile *.hbs,*.handlebars set ft=handlebars.html
augroup END

augroup filetype_javascript
  " Ctrl-l to insert a fat arrow
  autocmd FileType javascript imap <c-l> <space>=><space>
augroup END

augroup filetype_markdown
  autocmd!

  autocmd BufRead,BufNewFile *.md set ft=markdown
  " Wrap lines at 80 characters
  autocmd FileType markdown setlocal textwidth=80
  " Enable spell checking
  autocmd FileType markdown setlocal spell
augroup END

augroup filetype_ruby
  autocmd!

  " These files are also Ruby
  autocmd BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,Vagrantfile,config.ru} set ft=ruby
  " Ctrl-l to insert a hashrocket
  autocmd FileType ruby imap <c-l> <space>=><space>
augroup END

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
nnoremap <leader>w <c-w>v<c-w>l

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<cr>

" Execute dot in the selection
vnoremap . :norm.<cr>

" Visual shifting (does not exit visual mode)
vnoremap < <gv
vnoremap > >gv

" Make explorer mode behave like NERDTree
let g:netrw_liststyle=3

" *** Plugins

" Ack.vim
if executable('ag')
  " If ag is installed, use that instead of ack
  let g:ackprg='ag --nogroup --nocolor --column'
endif

" vim-ruby
let g:rubycomplete_buffer_loading=1
let g:rubycomplete_classes_in_global=1
let g:rubycomplete_rails=1

" CtrlP
let g:ctrlp_working_path_mode=2 " Smart path mode
let g:ctrlp_mru_files=1 " Enable most-recently-used files feature
let g:ctrlp_jump_to_buffer=2 " Jump to tab and buffer if already open
let g:ctrlp_custom_ignore=&wildignore . '*/.git/*,*/.hg/*,*/.svn/*,*/bower_components/*,*/node_modules/*'
let g:ctrlp_lazy_update=100 " Wait 100ms before starting a new search
let g:ctrlp_max_files=0 " No file limit

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command='ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching=0
endif

" The Silver Searcher (ag)

if executable('ag')
  " For Vim's :grep command, use ag instead
  set grepprg=ag\ --nocolor\ --nogroup
endif

" Syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=0
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_mode_map = {'passive_filetypes': ['html', 'sass', 'scss']}

" Matchit (included with Vim 7.3+)
runtime! macros/matchit.vim

" Run Ack on word under cursor
nnoremap <leader>A :Ack "\b<cword>\b"<cr>

" *** Custom Functions

" Clear whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" Pull word under cursor into find / replace
nmap <leader>z :%s#\<<c-r>=expand("<cword>")<cr>\>#

" Shortcut for referencing directory of current file
cnoremap %% <c-r>=expand('%:h').'/'<cr>

" Visually select the text that was last edited / pasted
nnoremap gV `[V`]

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

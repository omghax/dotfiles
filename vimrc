" Most of this is from 'Coming Home to Vim'
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"
" Also Ryan Tomayko's .vimrc:
" https://github.com/rtomayko/dotfiles/blob/rtomayko/.vimrc

" Bootstrap pathogen (must happen first)
filetype off
call pathogen#runtime_append_all_bundles()

" --------------------------------------------------
" General
" --------------------------------------------------

set nocompatible                " essential
set history=1000                " lots of command line history
set ffs=unix,dos,mac            " support these files
filetype plugin indent on       " load filetype plugin

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set cursorline
set ttyfast
set undofile                    " make undo history persist across file reloads
set modelines=0                 " disable modelines for security reasons

" --------------------------------------------------
" Colors / Theme
" --------------------------------------------------

if &t_Co > 2 || has("gui_running")
  if has("terminfo")
    set t_Co=16
    set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
    set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
  else
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif
  syntax on
  set hlsearch
  colorscheme railscasts
endif

" --------------------------------------------------
" UI
" --------------------------------------------------

set ruler                       " show the cursor position all the time
set showcmd                     " display incomplete commands
set nolazyredraw                " turn off lazy redraw
set relativenumber              " relative (rather than absolute) line numbers
set wildmenu                    " turn on wild menu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc
set ch=2                        " command line height
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set nostartofline               " don't jump to the start of line when scrolling

" --------------------------------------------------
" Visual Cues
" --------------------------------------------------

set showmatch                   " brackets / braces that is
set mat=5                       " duration to show matching brace (1/10 sec)
set incsearch                   " do incremental searching
set laststatus=2                " always show the status line
set ignorecase                  " ignore case when searching
set smartcase                   " ...unless you search with uppercase chars
set hlsearch                    " highlight searches
set visualbell                  " shut the fuck up
set gdefault                    " make substitutions global by default
set list
set listchars=tab:▸\ ,eol:¬     " use the same chars as TextMate for tabstops / EOLs

" --------------------------------------------------
" Text Formatting
" --------------------------------------------------

set autoindent                  " automatic indent new lines
set smartindent                 " be smart about it
set wrap                        " wrap lines
set softtabstop=2               " yep, two
set shiftwidth=2                " ..
set tabstop=2
set expandtab                   " expand tabs to spaces
set nosmarttab                  " fuck tabs
set formatoptions+=n            " support for numbered / bullet lists
set colorcolumn=85              " colored column line at 85 characters
set virtualedit=block           " allow virtual edit in visual block

" --------------------------------------------------
" Mappings
" --------------------------------------------------

" remap <Leader> to ',' (instead of '\')
let mapleader=","
let g:mapleader=","

" clear search highlights
map <Leader><Space> :noh<CR>

" tab to navigate between pairs (parentheses, brackets, etc.)
nmap <Tab> %
omap <Tab> %
vmap <Tab> %

" Use the damn hjkl keys
nnoremap <Up>     <nop>
nnoremap <Down>   <nop>
nnoremap <Left>   <nop>
nnoremap <Right>  <nop>

" And make them fucking work, too.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" F1 to toggle fullscreen
inoremap <F1> <Esc>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" F2 to toggle NERDTree drawer
map <F2> :NERDTreeToggle<CR>

" F3 to toggle YankRing
nnoremap <silent> <F3> :YRShow<CR>

" F4 to toggle BufExplorer
nnoremap <F4> :BufExplorer<CR>

" F5 to toggle TagList
nnoremap <F5> :TlistToggle<CR>

" F6 to toggle Gundo
nnoremap <F6> :GundoToggle<CR>

" Faster ESC
inoremap jj <Esc>

" Easy buffer navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Easy window resizing
nmap <C-<> <C-w>20>
nmap <C->> <C-w>20<

" Open a new split buffer and jump into it
map <Leader>v :vsplit <CR> <C-w>l
map <Leader>h :split  <CR> <C-w>j

" Clean whitespace
map <Leader>ws :%s/\s\+$//<CR>:let @/=''<CR>

" Command-T
map <Leader>t :CommandT<CR>
map <Leader>T :CommandTFlush<CR> :CommandT<CR>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
map <C-\> :tnext<CR>

" Edit .vimrc
nmap <Leader>ev  <C-w><C-v><C-l>:e $MYVIMRC<CR>
nmap <Leader>egv <C-w><C-v><C-l>:e $MYGVIMRC<CR>

" Unimpaired
" Bubble single line
nmap <D-k> [e
nmap <D-j> ]e
" Bubble multiple lines
vmap <D-k> [egv
vmap <D-j> ]egv

" Visually select the text that was last edited / pasted
nmap gV `[v`]

" Make Y consistent with C and D
nnoremap Y y$

" Rainbows!
nmap <Leader>R :RainbowParenthesesToggle<CR>

" Opens an edit command with the path of the currently edited file
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file
" Normal mode: <Leader>te
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+F
cmap <C-F> <C-R>=expand("%:p:h") . "/" <CR>

" Tabular
if exists(":Tabularize")
  map <Leader>a :Tabularize /
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  omap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
  omap <Leader>a: :Tabularize /:\zs<CR>
  nmap <Leader>a> :Tabularize /=><CR>
  vmap <Leader>a> :Tabularize /=><CR>
  omap <Leader>a> :Tabularize /=><CR>
endif

" --------------------------------------------------
" Auto Commands
" --------------------------------------------------

if has("autocmd")
  " Jump to last position of buffer when opening
  autocmd! BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

  " Source the vimrc file after saving it
  autocmd! BufWritePost .vimrc  source $MYVIMRC
  autocmd! BufWritePost .gvimrc source $MYGVIMRC

  autocmd! BufNewFile,BufRead *.html map <Leader>ft Vatzf

  " Bind Ctrl+l to hashrocket in ruby
  autocmd! FileType ruby imap <C-l> <Space>=><Space>

  " Gemfile, Rakefile, Thorfile, and config.ru are Ruby
  autocmd! BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

  " Make uses real tabs
  autocmd! FileType make setlocal noexpandtab

  " Make Python follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
  autocmd! FileType python set tabstop=4 textwidth=79

  " Automatically turn off syntax highlighting for large files (>1MB)
  autocmd! BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

  function! s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=72
  endfunction

  function! s:setupMarkup()
    call s:setupWrapping()
    map <buffer> <Leader>p :Mm <CR>
  endfunction

  " md, markdown, and mk are markdown and define buffer-local preview
  autocmd! BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

  autocmd! BufRead,BufNewFile *.txt call s:setupWrapping()
endif

" --------------------------------------------------
" Plugins
" --------------------------------------------------

" Command-T
let g:CommandTMaxHeight=20

" NERD Tree
let NERDTreeIgnore=['.vim$', '.rbc$', '\~$']

" Ruby
compiler ruby

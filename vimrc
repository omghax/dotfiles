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
set modelines=0                 " disable modelines for security reasons
set confirm                     " confirm, don't abort, when closing dirty files
set nobackup
set noswapfile

if exists("&undofile")
  set undofile                  " make undo history persist across file reloads
endif

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

  if has("gui_running")
    set background=light
    colorscheme solarized
  else
    colorscheme vividchalk
  endif
endif

" --------------------------------------------------
" UI
" --------------------------------------------------

set ruler                       " show the cursor position all the time
set showcmd                     " display incomplete commands
set nolazyredraw                " turn off lazy redraw
set wildmenu                    " turn on wild menu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,tmp,doc
set ch=2                        " command line height
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set nostartofline               " don't jump to the start of line when scrolling
set foldmethod=indent           " use indent folding (syntax-based is slow)
set foldlevelstart=20           " don't fold everything when opening a file

if exists("&relativenumber")
  set relativenumber            " relative (rather than absolute) line numbers
endif

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
set list                        " show invisible characters like tabstops / EOLs
set listchars=tab:▸\ ,eol:¬     " ...and use the same chars as TextMate for them

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
set virtualedit=block           " allow virtual edit in visual block

if exists("&colorcolumn")
  set colorcolumn=85            " colored column line at 85 characters
endif

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

" Use the arrow keys for something useful
map <Right> :bn<CR>
map <Left> :bp<CR>

" Leader-cd to switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>

" Reflow content with Q.
nnoremap Q gqap
onoremap Q gqq
vnoremap Q gq

" Toggle folding.
nnoremap <Leader>f za
vnoremap <Leader>f za

" Leader-A to ack for the word under the cursor
nnoremap <Leader>A :Ack "\b<cword>\b"<CR>

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

" F5 to toggle Tagbar
nnoremap <F5> :TagbarToggle<CR>

" F6 to toggle Gundo
nnoremap <F6> :GundoToggle<CR>

" Faster ESC
inoremap <Control>[ <Esc>
inoremap jj <Esc>

" Easy buffer navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Open a new split buffer and jump into it
map <Leader>v :vsplit <CR> <C-w>l
map <Leader>h :split  <CR> <C-w>j

" Clean whitespace
map <Leader>ws :%s/\s\+$//<CR>:let @/=''<CR>

" Close all buffers
nnoremap <Leader>bd :bufdo bd<CR>

" Command-T
map <Leader>t :CommandT<CR>
function! CommandTFlushAndReload()
  :CommandTFlush
  :CommandT
endfunction
map <Leader>T :exec CommandTFlushAndReload()<CR>

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
nmap <Leader>a, :Tabularize /,\zs<CR>
vmap <Leader>a, :Tabularize /,\zs<CR>
omap <Leader>a, :Tabularize /,\zs<CR>

" Sort lines
nmap <Leader>s :sort<CR>
" Sort lines and remove duplicates
nmap <Leader>S :sort u<CR>

" Parentheses/bracket expansion
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Autocompletion for (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

" --------------------------------------------------
" Auto Commands
" --------------------------------------------------

if has("autocmd")
  " Jump to last position of buffer when opening
  autocmd! BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

  " Source the vimrc file after saving it
  autocmd! BufWritePost $MYVIMRC source $MYVIMRC | if has("gui_running") | source $MYGVIMRC | endif
  autocmd! BufWritePost $MYGVIMRC source $MYGVIMRC

  autocmd! BufNewFile,BufRead *.html map <Leader>ft Vatzf

  " Bind Ctrl+l to hashrocket in ruby
  autocmd! FileType ruby imap <C-l> <Space>=><Space>

  " Buildfile, Gemfile, Rakefile, Thorfile, and config.ru are Ruby
  autocmd! BufRead,BufNewFile {Buildfile,Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

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

  " omni-completion
  autocmd FileType c set omnifunc=ccomplete#Complete
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete 
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
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

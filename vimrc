" Personal preference .vimrc file
" Maintained by Dray Lacy <dray@envylabs.com>
"
" This configuration is based on the following:
"
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" https://github.com/carlhuda/janus
" https://github.com/nvie/vimrc
" https://github.com/rtomayko/dotfiles
"
" To start vim without using this .vimrc file, use:
"     vim -u NORC
"
" To start vim without loading any .vimrc or plugins, use:
"     vim -u NONE

" Use vim settings, rather than vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory.
filetype off " force reloading *after* pathogen is loaded
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on " enable detection, plugins, and indenting in one step

" Change the mapleader from \ to ,
let mapleader=","

" Editing behavior {{{
set showmode                    " always show what mode we're currently editing in
set wrap                        " wrap lines
set tabstop=2                   " a tab is 2 spaces
set softtabstop=2               " when hitting <BS>, pretend like a tab is removed,
                                "   even if spaces
set expandtab                   " expand tabs by default (overloadable by file type later)
set shiftwidth=2                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " show line number in the gutter
set showmatch                   " set show matching parentheses
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "   case-sensitive otherwise
set smarttab                    " insert tabs on the start of a line according to
                                "   shiftwidth, not tabstop
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
set virtualedit=all             " allow the cursor to go to 'invalid' places
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set gdefault                    " search/replace 'globally' (on a line) by default
set listchars=tab:▸\ ,eol:¬     " use same chars as TextMate for invisibles
set nolist                      " don't show invisible characters by default,
                                "   but it's enabled for some file types (see later)
set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "   paste mode, where you can paste mass data
                                "   that won't be autoindented
set mouse=a                     " enable using the mouse if terminal emulator
                                "   supports it (xterm does)
set fileformats=unix,dos,mac
set formatoptions+=1            " when wrapping paragraphs, don't end lines with
                                "   1-letter words (looks stupid)
set formatoptions+=n            " support for numbered / bulleted lists
set confirm                     " confirm, don't abort, when closing a dirty file

" Thanks to Steve Losh for this liberating tip
" See http://stevelosh.com/blog/2010/09/coming-home-to-vim
nnoremap / /\v
vnoremap / /\v

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
" }}}

" Folding rules {{{
set foldenable                  " enable folding
set foldcolumn=2                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=0            " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()
" }}}

" Editor layout {{{
set termencoding=utf-8
set encoding=utf-8
set lazyredraw                  " don't update the display when executing macros
set laststatus=2                " tell vim to always put a status line in, even if
                                "   there is only one window
set cmdheight=1                 " use a status bar that is 1 row high
set ruler                       " show the cursor position all the time
set cursorline                  " highlight the current line

if exists("&colorcolumn")
  set colorcolumn=85            " colored column line at 85 characters
endif
" }}}

" Vim behavior {{{
set hidden                      " hide buffers instead of closing them; this
                                "   means that the current buffer can be put to
                                "   background without being written, and that
                                "   marks and undo history are preserved
set switchbuf=useopen           " reveal already opened files from the quickfix
                                "   window instead of opening new buffers
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
if exists("&undofile")
  set undofile                  " keep a persistent undo file
  set undodir=~/.vim/tmp/undo//,~/tmp//,/tmp//
endif
set nobackup                    " no backup files; it's 70's style cluttering
set noswapfile                  " do not write annoying intermediate swap files,
                                "   who did ever restore from swap files anyway?
set directory=~/.vim/tmp//,~/tmp//,/tmp//
                                " store swap files in one of these directories
                                "   (in case swapfile is ever turned on)
set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                "   than 80 lines of registers
set wildmenu                    " make file/buffer tab completion act like bash
set wildmode=list:full          " show a list when pressing tab and complete first full match
set wildignore=*.o,*.obj,*.swp,*.bak,*.pyc,*.rbc,*.class,tmp/**
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " no really, don't beep
set showcmd                     " show (partial) command in the last line of the
                                "   screen; this also shows visual selection info
set nomodeline                  " disable mode lines (security measure)
set ttyfast                     " always use a fast terminal

command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
" }}}

" Highlighting {{{
if &t_Co >= 256 || has("gui_running")
  colorscheme molokai
endif

if &t_Co > 2 || has("gui_running")
  syntax on                     " syntax highlighting on if the terminal is color
endif
" }}}

" Tags {{{
" Include tags for RVM gems.
set tags+=,$HOME/.rvm/gems/tags

" Ctrl+\ to jump to the next matching tag.
map <C-\> :tnext<CR>
" }}}

" Shortcut mappings {{{
" Since I never use the ; key anyway, this is a real optimization for almost
" all vim commands, since we don't have to press that annoying Shift key that
" slows the commands down
nnoremap ; :

" Avoid accidental hits of <F1> while aiming for <Esc>
inoremap <F1> <Esc>
nnoremap <F1> <Esc>
vnoremap <F1> <Esc>

" Quickly close the current window
nnoremap <leader>q :q<CR>

" Use Q for formatting the current paragraph (or visual selection)
vnoremap Q gq
onoremap Q gqq
nnoremap Q gqap

" Make p in visual mode replace the selected text with the yank register
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Shortcut to make
nmap mk :make<CR>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" Use the damn hjkl keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Easy window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Adjust split window sizes
nnoremap _ 3<C-w><LT>
nnoremap + 3<C-w>>

" Open a new split buffer and jump into it
nnoremap <leader>h <C-w>s<C-w>j
nnoremap <leader>v <C-w>v<C-w>l

" Complete whole filenames/lines with a quicker shortcut key in insert mode
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

" Quick yanking to the end of the line; makes Y consistent with C and D
nmap Y y$

" Yank/paste to the OS clipboard with ,y and ,p
nmap <leader>y "+y
nmap <leader>Y "+yy
nmap <leader>p "+p
nmap <leader>P "+P

" Clears the search register
nmap <silent> <leader>/ :nohlsearch<CR>

" Quickly get out of insert mode without your fingers having to leave the home
" row (either use 'jj' or 'jk')
inoremap jj <Esc>
inoremap jk <Esc>

" Quick alignment of text
nmap <leader>al :left<CR>
nmap <leader>ar :right<CR>
nmap <leader>ac :center<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
nmap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Jump to matching pairs easily, with Tab
omap <Tab> %
nmap <Tab> %
vmap <Tab> %

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Strip all trailing whitespace from a file, using ,w
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Run Ack fast
" nnoremap <leader>a :Ack<Space>
nnoremap <leader>A :Ack "\b<cword>\b"<CR>

" Visually select the text that was last edited / pasted with gV
nnoremap gV `[V`]

" Quickly close all buffers with ,bd
nnoremap <leader>bd :bufdo bd<CR>

" Sorting
noremap <leader>ss :sort<CR>
noremap <leader>su :sort u<CR>

" Open files in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<CR>
map <leader>e :edit %%

" Tabular
vnoremap <leader>a :Tabularize /
onoremap <leader>a :Tabularize /
nnoremap <leader>a :Tabularize /
vnoremap <leader>a= :Tabularize /=<CR>
onoremap <leader>a= :Tabularize /=<CR>
nnoremap <leader>a= :Tabularize /=<CR>
vnoremap <leader>a: :Tabularize /:\zs<CR>
onoremap <leader>a: :Tabularize /:\zs<CR>
nnoremap <leader>a: :Tabularize /:\zs<CR>
vnoremap <leader>a> :Tabularize /=><CR>
onoremap <leader>a> :Tabularize /=><CR>
nnoremap <leader>a> :Tabularize /=><CR>
vnoremap <leader>a, :Tabularize /,\zs<CR>
onoremap <leader>a, :Tabularize /,\zs<CR>
nnoremap <leader>a, :Tabularize /,\zs<CR>

" Quick open config/routes.rb into a split
map <leader>gr :topleft :split config/routes.rb<CR>

" CommandT
map <leader>gv :CommandTFlush<CR>\|:CommandT app/views<CR>
map <leader>gc :CommandTFlush<CR>\|:CommandT app/controllers<CR>
map <leader>gm :CommandTFlush<CR>\|:CommandT app/models<CR>
map <leader>gh :CommandTFlush<CR>\|:CommandT app/helpers<CR>
map <leader>gl :CommandTFlush<CR>\|:CommandT lib<CR>
map <leader>gs :CommandTFlush<CR>\|:CommandT spec<CR>
map <leader>gt :CommandTFlush<CR>\|:CommandTTag<CR>
map <leader>f :CommandTFlush<CR>\|:CommandT<CR>
map <leader>F :CommandTFlush<CR>\|:CommandT %%<CR>

" BufExplorer
nnoremap <F4> :BufExplorer<CR>

" NERDTree settings {{{
" Put focus to the NERD Tree with F3 (tricked by quickly closing it and
" immediately showing it again, since there is no :NERDTreeFocus command)
nmap <leader>n :NERDTreeClose<CR>:NERDTreeToggle<CR>
nmap <leader>m :NERDTreeClose<CR>:NERDTreeFind<CR>
nmap <leader>N :NERDTreeClose<CR>

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Show hidden files, too
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1

" Quit on opening files from the tree
let NERDTreeQuitOnOpen=1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

" Use a single click to fold/unfold directories and a double click to open
" files
let NERDTreeMouseMode=2

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$' ]

" }}}

" TagList settings {{{
nmap <leader>l :TlistClose<CR>:TlistToggle<CR>
nmap <leader>L :TlistClose<CR>

" quit Vim when the TagList window is the last open window
let Tlist_Exit_OnlyWindow=1         " quit when TagList is the last open window
let Tlist_GainFocus_On_ToggleOpen=1 " put focus on the TagList window when it opens
"let Tlist_Process_File_Always=1     " process files in the background, even when the TagList window isn't open
"let Tlist_Show_One_File=1           " only show tags from the current buffer, not all open buffers
let Tlist_WinWidth=40               " set the width
let Tlist_Inc_Winwidth=1            " increase window by 1 when growing

" shorten the time it takes to highlight the current tag (default is 4 secs)
" note that this setting influences Vim's behaviour when saving swap files,
" but we have already turned off swap files (earlier)
"set updatetime=1000

" the default ctags in /usr/bin on the Mac is GNU ctags, so change it to the
" exuberant ctags version in /usr/local/bin
" let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

" show function/method prototypes in the list
let Tlist_Display_Prototype=1

" don't show scope info
let Tlist_Display_Tag_Scope=0

" show TagList window on the right
let Tlist_Use_Right_Window=1
" }}}

" Conflict markers {{{
" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" shortcut to jump to next conflict marker
nmap <silent> <leader>c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
" }}}

" FileType specific handling {{{
" only do this part when compiled with support for autocommands
if has("autocmd")
  " Automatically turn off syntax highlighting for large files (>1MB) {{{
  autocmd! BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif
  " }}}

  augroup invisible_chars "{{{
    au!

    " Show invisible characters in all of these files
    autocmd FileType vim setlocal list
    autocmd FileType python,rst setlocal list
    autocmd FileType ruby setlocal list
    autocmd FileType javascript,css setlocal list
  augroup end "}}}

  augroup omni_completion "{{{
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
  augroup end "}}}

  augroup vim_files "{{{
    au!

    " Bind <F1> to show the keyword under cursor
    " general help can still be entered manually, with :h
    autocmd FileType vim noremap <buffer> <F1> <Esc>:help <C-r><C-w><CR>
    autocmd FileType vim noremap! <buffer> <F1> <Esc>:help <C-r><C-w><CR>
  augroup end "}}}

  augroup html_files "{{{
    au!

    " This function detects, based on HTML content, whether this is a
    " Django template, or a plain HTML file, and sets FileType accordingly
    fun! s:DetectHTMLVariant()
      let n = 1
      while n < 50 && n < line("$")
        " check for django
        if getline(n) =~ '{%\s*\(extends\|load\|block\|if\|for\|include\|trans\)\>'
          set ft=htmldjango.html
          return
        endif
        let n = n + 1
      endwhile
      " go with html
      set ft=html
    endfun

    autocmd BufNewFile,BufRead *.html,*.htm call s:DetectHTMLVariant()

    " Auto-closing of HTML/XML tags
    let g:closetag_default_xml=1
    autocmd FileType html,htmldjango let b:closetag_html_style=1
    " autocmd FileType html,xhtml,xml source ~/.vim/scripts/closetag.vim
  augroup end " }}}

  augroup python_files "{{{
    au!

    " This function detects, based on Python content, whether this is a
    " Django file, which may enabling snippet completion for it
    fun! s:DetectPythonVariant()
      let n = 1
      while n < 50 && n < line("$")
        " check for django
        if getline(n) =~ 'import\s\+\<django\>' || getline(n) =~ 'from\s\+\<django\>\s\+import'
          set ft=python.django
          "set syntax=python
          return
        endif
        let n = n + 1
      endwhile
      " go with html
      set ft=python
    endfun
    autocmd BufNewFile,BufRead *.py call s:DetectPythonVariant()

    " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
    " earlier, as it is important)
    autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType python setlocal textwidth=80
    autocmd FileType python match ErrorMsg '\%>80v.\+'

    " But disable autowrapping as it is super annoying
    autocmd FileType python setlocal formatoptions-=t

    " Folding for Python (uses syntax/python.vim for fold definitions)
    "autocmd FileType python,rst setlocal nofoldenable
    "autocmd FileType python setlocal foldmethod=expr

    " Python runners
    autocmd FileType python map <buffer> <F5> :w<CR>:!python %<CR>
    autocmd FileType python imap <buffer> <F5> <Esc>:w<CR>:!python %<CR>
    autocmd FileType python map <buffer> <S-F5> :w<CR>:!ipython %<CR>
    autocmd FileType python imap <buffer> <S-F5> <Esc>:w<CR>:!ipython %<CR>

    " Run a quick static syntax check every time we save a Python file
    autocmd BufWritePost *.py call Pyflakes()
  augroup end " }}}

  augroup ruby_files "{{{
    au!

    " Buildfile, Gemfile, Rakefile, Thorfile, and config.ru are all Ruby
    autocmd BufRead,BufNewFile {Buildfile,Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

    autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

    " Ruby runners
    autocmd FileType ruby map <buffer> <F5> :w<CR>:!ruby %<CR>
    autocmd FileType ruby imap <buffer> <F5> <Esc>:w<CR>:!ruby %<CR>
    autocmd FileType ruby map <buffer> <S-F5> :w<Esc>:!irb %<CR>
    autocmd FileType ruby imap <buffer> <S-F5> <Esc>:w<CR>:!irb %<CR>

    " Ctrl+l for hashrocket
    autocmd FileType ruby imap <C-l> <Space>=><Space>
  augroup end " }}}

  augroup rst_files "{{{
    au!

    " Auto-wrap text around 74 chars
    autocmd FileType rst setlocal textwidth=74
    autocmd FileType rst setlocal formatoptions+=nqt
    autocmd FileType rst match ErrorMsg '\%>74v.\+'
  augroup end " }}}

  augroup css_files "{{{
    au!

    autocmd FileType css,less setlocal foldmethod=marker foldmarker={,}
  augroup end "}}}

  augroup javascript_files "{{{
    au!

    autocmd FileType javascript setlocal expandtab
    autocmd FileType javascript setlocal listchars=trail:·,extends:#,nbsp:·
    autocmd FileType javascript setlocal foldmethod=marker foldmarker={,}
  augroup end "}}}

  augroup textile_files "{{{
    au!

    autocmd FileType textile set tw=78 wrap

    " Render YAML front matter inside Textile documents as comments
    autocmd FileType textile syntax region frontmatter start=/\%^---$/ end=/^---$/
    autocmd FileType textile highlight link frontmatter Comment
  augroup end "}}}
endif
" }}}

" Restore cursor position upon reopening files {{{
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" }}}

" Common abbreviations / misspellings {{{
source ~/.vim/autocorrect.vim
" }}}

" Rename current file {{{
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>r :call RenameFile()<CR>
" }}}

" Extra vi-compatibility {{{
" set extra vi-compatible options
set formatoptions-=o " don't start new lines w/ comment leader on pressing 'o'
au FileType vim set formatoptions-=o
                     " somehow, during vim FileType detection, this gets set
                     " for vim files, so explicitly unset it again
" }}}

" Creating underline/overline headings for markup languages
" Inspired by http://sphinx.pocoo.org/rest.html#sections
nnoremap <leader>1 yyPVr=jyypVr=
nnoremap <leader>2 yyPVr*jyypVr*
nnoremap <leader>3 yypVr=
nnoremap <leader>4 yypVr-
nnoremap <leader>5 yypVr^
nnoremap <leader>6 yypVr"

iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit
iab llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi
iab lllorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi.  Integer hendrerit lacus sagittis erat fermentum tincidunt.  Cras vel dui neque.  In sagittis commodo luctus.  Mauris non metus dolor, ut suscipit dui.  Aliquam mauris lacus, laoreet et consequat quis, bibendum id ipsum.  Donec gravida, diam id imperdiet cursus, nunc nisl bibendum sapien, eget tempor neque elit in tortor

if has("gui_running")
  set guifont=Inconsolata:h14
  set background=light
  "colorscheme autumnleaf
  "colorscheme baycomb
  "colorscheme molokai
  "colorscheme mustang
  colorscheme railscasts2
  "colorscheme twilight

  " Uncomment the following to use Solarized.
  " let g:solarized_termcolors=256
  " let g:solarized_bold = 1
  " let g:solarized_underline = 1
  " let g:solarized_italic = 1
  " colorscheme solarized

  " Remove toolbar, left scrollbar and right scrollbar
  set guioptions-=T
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R

  " Screen recording mode
  function! ScreenRecordMode()
    set columns=86
    set guifont=Droid\ Sans\ Mono:h14
    set cmdheight=1
    colorscheme molokai_deep
  endfunction
  command! -bang -nargs=0 ScreenRecordMode call ScreenRecordMode()
else
  colorscheme wombat256
endif

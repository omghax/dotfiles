set guioptions-=T " hide toolbar
set lines=55 columns=100

if has('gui_running')
  set guifont=Inconsolata:h14,AnonymousPro:h14,Andale\ Mono\ 14,DejaVu\ Sans\ Mono\ 14,Terminal
  colorscheme railscasts
  set background=dark

  set go-=T
  set go-=l
  set go-=L
  set go-=r
  set go-=R

  if has("gui_macvim")
    macmenu &File.New\ Tab key=<nop>
    map <D-t> :CommandT<CR>
  end

  highlight SpellBad term=underline gui=undercurl guisp=Orange
else
  colors elflord
endif


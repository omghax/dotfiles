set guioptions-=T " hide toolbar
set lines=55 columns=100

if has('gui_running')
  set guifont=AnonymousPro:h12,Inconsolata,Andale\ Mono\ 12,DejaVu\ Sans\ Mono\ 12,Terminal
  colorscheme railscasts
  set background=dark

  set go-=T
  set go-=l
  set go-=L
  set go-=r
  set go-=R

  if has("gui_macvim")
    macmenu &File.New\ Tab key=<nop>
  end

  highlight SpellBad term=underline gui=undercurl guisp=Orange
else
  colors elflord
endif


#!/usr/bin/env sh

HOMEBREW=$HOME/Homebrew

export PATH=$HOMEBREW/bin:$PATH
export LIBRARY_PATH=$HOMEBREW/lib:/usr/lib
export LD_LIBRARY_PATH=$HOMEBREW/lib:/usr/lib
export DYLD_FALLBACK_LIBRARY_PATH=$HOMEBREW/lib
export C_INCLUDE_PATH=$HOMEBREW/include
export CPLUS_INCLUDE_PATH=$HOMEBREW/include

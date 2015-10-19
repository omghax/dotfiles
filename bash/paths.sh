#!/usr/bin/env sh

add_path() {
  if [[ "$PATH" != "*$1*" ]]; then
    export PATH="$1:$PATH"
  fi
}

add_path "$HOME/Homebrew/bin"

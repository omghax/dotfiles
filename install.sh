#!/bin/bash

step() {
  echo -e "\x1B[34m==>\x1B[0m \x1B[1m$1\x1B[0m"
}

warn() {
  echo -e "\x1B[93m==>\x1B[0m \x1B[1m$1\x1B[0m"
}

# *** Homebrew

homebrew="$HOME/Homebrew"

step "Installing Homebrew"
if command -v brew >/dev/null; then
  echo "Homebrew is already installed"
else
  mkdir -p "$homebrew" && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C "$homebrew"
fi

brew() {
  command "$homebrew/bin/brew" "$@"
}

step "Updating Homebrew formulae"
brew update

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

brew_is_installed() {
  brew list -1 | grep -Fqx "$(brew_expand_alias "$1")"
}

brew_is_upgradable() {
  ! brew outdated --quiet "$(brew_expand_alias "$1")" >/dev/null
}

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    step "Upgrading '$1'"
    if brew_is_upgradable "$1"; then
      brew upgrade "$@"
    else
      echo "Already using the latest version of '$1'"
    fi
  else
    step "Installing '$1'"
    brew install "$@"
  fi
}

maybe_link() {
  step "Linking '$1' to '$2'"
  if [ -e $2 ]; then
    echo "'$2' already exists"
  else
    ln -s "$1" "$2"
  fi
}

brew_launchctl_restart() {
  local name="$(brew_expand_alias "$1")"
  local domain="homebrew.mxcl.$name"
  local plist="$domain.plist"

  if [ ! -d "$HOME/Library/LaunchAgents" ]; then
    mkdir -p "$HOME/Library/LaunchAgents"
  fi

  maybe_link "$homebrew/opt/$name/$plist" "$HOME/Library/LaunchAgents/$plist"

  step "Restarting '$1'"
  if launchctl list | grep -Fq "$domain"; then
    launchctl unload "$HOME/Library/LaunchAgents/$plist" >/dev/null
  fi
  launchctl load "$HOME/Library/LaunchAgents/$plist" >/dev/null
}

brew_install_or_upgrade "git"

brew_install_or_upgrade "openssl"
brew unlink openssl && brew link openssl --force

# *** Dotfiles

dotfiles="$HOME/Dotfiles"

step "Installing Dotfiles"
if [ -d "$dotfiles/.git" ]; then
  echo "Dotfiles are already installed"
else
  git clone -b new https://github.com/omghax/dotfiles.git "$dotfiles"
fi

# *** Git

maybe_link "$dotfiles/gitconfig" "$HOME/.gitconfig"
maybe_link "$dotfiles/gitignore" "$HOME/.gitignore"

# *** Bash

brew_install_or_upgrade "bash-completion"

maybe_link "$dotfiles/bash" "$HOME/.bash"
maybe_link "$dotfiles/bash_profile" "$HOME/.bash_profile"
maybe_link "$dotfiles/bashrc" "$HOME/.bashrc"

source "$HOME/.bash_profile"

# *** The Silver Searcher (ag)

brew_install_or_upgrade "the_silver_searcher"

maybe_link "$dotfiles/agignore" "$HOME/.agignore"

# *** Ack

brew_install_or_upgrade "ack"

maybe_link "$dotfiles/ackrc" "$HOME/.ackrc"

# *** Vim

brew_install_or_upgrade "ctags-exuberant"
brew_install_or_upgrade "vim"

maybe_link "$dotfiles/vim" "$HOME/.vim"
maybe_link "$dotfiles/vimrc" "$HOME/.vimrc"
maybe_link "$dotfiles/vimrc.bundles" "$HOME/.vimrc.bundles"

if [ ! -d "$dotfiles/vim/bundle" ]; then
  mkdir -p "$dotfiles/vim/bundle"
fi

if [ ! -e "$dotfiles/vim/bundle/vundle" ]; then
  step "Installing vundle"
  git clone https://github.com/gmarik/vundle.git "$dotfiles/vim/bundle/vundle"
fi

step "Installing vundle plugins"
vim -u "$dotfiles/vimrc.bundles" +BundleInstall! +BundleClean +qall

# *** Tmux

brew_install_or_upgrade "tmux"

maybe_link "$dotfiles/tmux.conf" "$HOME/.tmux.conf"

# *** PostgreSQL

brew_install_or_upgrade "postgres"
brew_launchctl_restart "postgresql"

# *** Ruby

brew_install_or_upgrade "rbenv"
brew_install_or_upgrade "ruby-build"

eval "$(rbenv init -)"

ruby_version="2.2.3"

if rbenv versions | grep -Fq "$ruby_version"; then
  echo "Ruby $ruby_version is already installed"
else
  step "Installing Ruby $ruby_version"
  rbenv install -s "$ruby_version"
fi

rbenv global "$ruby_version"
rbenv shell "$ruby_version"

maybe_link "$dotfiles/gemrc" "$HOME/.gemrc"
maybe_link "$dotfiles/irbrc" "$HOME/.irbrc"

step "Updating RubyGems"
gem update --system

gem_install_or_update() {
  if gem list "$1" --installed >/dev/null; then
    step "Updating '$1'"
    gem update "$@"
  else
    step "Installing '$1'"
    gem install "$@"
    rbenv rehash
  fi
}

gem_install_or_update "bundler"

step "Configuring Bundler"
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))
bundle config --global build.eventmachine --with-cppflags=-I`brew --prefix`/opt/openssl/include

# *** NodeJS

brew_install_or_upgrade "node"

npm_is_installed() {
  npm list --depth 1 -g "$1" >/dev/null 2>&1
}

npm_is_updatable() {
  ! npm outdated -g "$1" >/dev/null 2>&1
}

npm_install_or_update() {
  if npm_is_installed "$1"; then
    step "Updating '$1'"
    if npm_is_updatable "$1"; then
      npm update -g "$@"
    else
      echo "Already using the latest version of '$1'"
    fi
  else
    step "Installing '$1'"
    npm install -g "$@"
  fi
}

step "Installing global npm packages"
npm_install_or_update "bower"
npm_install_or_update "ember-cli"

step "Cleaning up Homebrew"
brew cleanup

source ~/.bash/config.sh
source ~/.bash/aliases.sh
source ~/.bash/homebrew.sh
source ~/.bash/completion.sh
source ~/.bash/rbenv.sh
source ~/.bash/nvm.sh
source ~/.bash/gpg-agent.sh

# Use .bash_local.rc for settings specific to one system
if [ -f ~/.bash_local.rc ]; then
  source ~/.bash_local.rc
fi

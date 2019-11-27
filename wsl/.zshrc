#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Directoy Colours
if [ -f ~/.dir_colors ]; then
  eval `dircolors ~/.dir_colors`
fi

export DOCKER_HOST=tcp://0.0.0.0:2375

source /usr/local/bin/aws_zsh_completer.sh
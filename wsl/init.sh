#!/bin/bash

# zsh
sudo apt install zsh -y

# prezto
touch ~/.zshrc
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

rm ~/.zshrc
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
 ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
rm ~/.zshrc
cp .zshrc ~/
cp .zpreztorc ~/
chsh -s $(which zsh)

# wsl
sudo cp  ./wsl.conf /etc/
# Restart LxssManager service

# docker
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y
sudo apt-get install -y docker-ce

# Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER

#git 
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update -y
sudo apt install git -y
git config --global pull.rebase true

# Directory Colors
cp .dir_colors ~/
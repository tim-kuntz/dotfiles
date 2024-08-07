#!/bin/bash
############################
# STOP!!! WIP!!!
#
# This script is for setting up a Github Codespace VM and
# more specifically one with a minikube install for test
# and/or training purposes.
############################

########## Variables

CODESPACES_DIR=/workspaces/.codespaces/.persistedshare/dotfiles

dir=~/dotfiles                    # dotfiles directory
if [ -d $CODESPACES_DIR ]; then
    dir=$CODESPACES_DIR
fi
olddir=~/dotfiles_old             # old dotfiles backup directory
files="zshrc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        sudo chsh "$(id -un)" --shell $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_tmux () {
    if [ -f /usr/bin/nvim ]; then
        echo "Tmux already installed"
    else
        echo "Tmux installing"
        sudo apt-get update
        sudo apt-get install tmux -y
    fi
}

install_neovim () {
    if [ -f /usr/bin/nvim ]; then
        echo "Neovim already installed"
    else
        echo "Neovim installing"
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update
        sudo apt-get install neovim -y
    fi

    ln -s $dir/nvim ~/.config/nvim
}

install_k9s () {
    if [ -f /usr/bin/k9s ]; then
        echo "K9s already installed"
    else
        echo "K9s installing"
        wget "https://github.com/derailed/k9s/releases/download/v0.28.2/k9s_Linux_amd64.tar.gz" -O k9s.tar.gz
        sudo tar -xvf k9s.tar.gz -C /usr/bin
        rm k9s.tar.gz
    fi
}

install_zsh
install_tmux 
install_neovim
install_k9s 


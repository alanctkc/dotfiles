#!/usr/bin/env bash

link_file() {
    if [ ! -z "$HOME" ] && [ ! -z "$2" ]; then
        rm -f $HOME/$2
    fi
    ln -s `pwd`/home/$1 $HOME/$2
}

link_directory() {
    if [ ! -z "$HOME" ] && [ ! -z "$2" ]; then
        rm -rf $HOME/$2
    fi
    ln -s `pwd`/home/$1 $HOME/$2
}

copy_file() {
    cp `pwd`/home/$1 $HOME/$2
}

clone_or_pull_repo() {
    if [ ! -f $HOME/$2/README.md ]; then
        git clone https://github.com/$1.git $HOME/$2
    else
        pushd $HOME/$2 > /dev/null
        git pull
        popd > /dev/null
    fi
}

install_oh_my_zsh() {
    echo "Installing oh-my-zsh..."
    clone_or_pull_repo robbyrussell/oh-my-zsh .oh-my-zsh
}

install_spacemacs() {
    echo "Installing spacemacs..."
    clone_or_pull_repo syl20bnr/spacemacs .emacs.d
}

configure_shell() {
    echo "Configuring common shell environment..."
    link_file .bash_aliases .bash_aliases
    link_file .shenv .shenv
    if [ "$OSTYPE" == "darwin"* ]; then
        copy_file .bash_local-mac .bash_local
    else
        copy_file .bash_local-linux .bash_local
    fi
}

configure_bash() {
    echo "Configuring bash..."
    link_file .bash_profile .bash_profile
    link_file .bashrc .bashrc
}

configure_zsh() {
    echo "Configuring zsh..."
    link_file .zshrc .zshrc
    rm -f $HOME/.zcompdump
}

configure_termite() {
    echo "Configuring termite..."
    mkdir -p $HOME/.config/termite
    link_file .config/termite/config .config/termite/config
}

configure_tmux() {
    echo "Configuring tmux..."
    link_file .tmux.conf .tmux.conf
}

configure_git() {
    echo "Configuring git..."
    link_file .gitconfig-global .gitconfig
    copy_file .gitignore-global .gitignore
}

configure_emacs() {
    echo "Configuring emacs..."
    link_file .spacemacs .spacemacs
}

configure_python() {
    echo "Configuring python..."
    mkdir -p $HOME/.config
    link_file .config/flake8 .config/flake8
}

configure_i3() {
    echo "Configuring i3..."
    mkdir -p $HOME/.config
    mkdir -p $HOME/.config/dunst
    link_directory .config/i3 .config/i3
    link_file .config/compton.conf .config/compton.conf
    link_file .config/dunst/dunstrc .config/dunst/dunstrc
}

configure_desktop() {
    echo "Configuring Desktop settings..."
    link_file .config/user-dirs.dirs .config/user-dirs.dirs
}

configure_vimperator() {
    echo "Configuring Vimperator..."
    link_file .vimperatorrc .vimperatorrc
}

set -e

install_oh_my_zsh
install_spacemacs
configure_shell
configure_bash
configure_zsh
configure_termite
configure_tmux
configure_git
configure_emacs
configure_python
configure_i3
configure_desktop
configure_vimperator

touch $HOME/.dotted
echo "Done."

#!/bin/bash

CURRENT_DIR=$PWD

FISH_CONFIG="$HOEM/.config/fish"
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
POWERLINE_FONTS_URL="https://github.com/powerline/fonts.git"
ENV_URL="https://github.com/Gitfz810/env_conf.git"
ENV_DIR="$HOME/workspace/github/env_conf"

function exist() {
    command -v $1 >/dev/null 2>&1
    return $?
}

function clone_env() {
    if [[ ! -d $ENV_DIR ]]; then
        git clone $ENV_URL $ENV_DIR
    fi
}

function install_brew() {
    echo "exec install brew..."

    if [[ `uname` == "Darwin" ]] && ! `exist brew` then
        xcode-select --install
        ruby -e "$(curl -fsSL $BREW_URL)"
    fi
}


function install_brew_pkg() {
    echo "exec install brew package..."

    for item in `cat $ENV_DIR/packages/brew-pkg`
    do
        read -p "Do you want to install '$item'? (y/n) " confirm
        if [[ confirm == "y" ]]; then
            brew install $item
            brew cleanup $item
        fi
    done
}

function install_powerline_fonts() {
    echo "exec install powerline fonts..."

    if [[ ! -d $HOME/.powerline-fonts ]]; then
        git clone --depth=1 $POWERLINE_FONTS_URL $HOME/.powerline-fonts
        $HOME/.powerline-fonts/install.sh
    fi
}

function init_env() {
    echo "exec init environment..."

    clone_env

    cd $HOME
    ln -sfv $ENV_DIR/gitconfig .gitconfig
    ln -sfv $ENV_DIR/tmux.conf .tmux.conf
    ln -sfv $ENV_DIR/vimrc .vimrc
    ln -sfv $ENV_DIR/fish .config/fish
    cd $CURRENT_DIR
}

function install_all() {
    clone_env
    install_brew
    install_brew_pkg
    install_powerline_fonts

    init_env
}

cat << EOF
select a function code:
===============================
【 1 】 Install brew
【 2 】 Install brew packages
【 3 】 Install powerline fonts
【 4 】 Init environment
【 0 】 Install all
【 e 】 Exit
===============================
EOF

if [[ -n $1 ]]; then
    choice=$1
    echo "execute: $1"
else
    read -p "select: " choice
fi

case $choice in
    1) install_brew;;
    2) install_brew_pkg;;
    3) install_powerline_fonts;;
    4) init_env;;
    0) install_all;;
    e) echo 'Bye' && exit;;
esac

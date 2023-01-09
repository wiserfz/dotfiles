#!/bin/bash

CURRENT_DIR=$PWD

FISH_CONFIG="$HOEM/.config/fish"
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
POWERLINE_FONTS_URL="https://github.com/powerline/fonts.git"
ENV_URL="https://github.com/Gitfz810/env_conf.git"
ENV_DIR="$HOME/workspace/env_conf"

Black=$'\e[0;30m'; Red=$'\e[0;31m'; Green=$'\e[0;32m'; Orange=$'\e[0;33m'; Blue=$'\e[0;34m'; Purple=$'\e[0;35m'; Cyan=$'\e[0;36m'; LightGray=$'\e[0;37m'
DarkGray=$'\e[1;30m'; LightRed=$'\e[1;31m'; LightGreen=$'\e[1;32m'; Yellow=$'\e[1;33m'; LightBlue=$'\e[1;34m'; LightPurple=$'\e[1;35m'; LightCyan=$'\e[1;36m'
White=$'\e[1;37m'; NC=$'\e[0m'

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
    echo "${LightGreen}execute install brew...${NC}"

    if [[ `uname` == "Darwin" ]] && ! `exist brew`; then
        xcode-select --install
        ruby -e "$(curl -fsSL $BREW_URL)"
    fi
}

function install_brew_pkg() {
    echo "${LightGreen}execute install brew package...${NC}"

    for item in `cat $ENV_DIR/packages/brew-pkg`
    do
        read -p "${LightRed}Do you want to install '$item'? (y/n) ${NC}" confirm
        if [[ $confirm == "y" ]]; then
            brew install $item
			if [[ $item == "go" ]]; then
				go env -w GOPATH="$HOME/workspace/go"
				go env -w GOPROXY="https://goproxy.cn,direct"
				go env -w GO111MODULE="on"
			fi
            brew cleanup $item
        fi
    done
}

function install_cask_pkg() {
    echo "${LightGreen}execute install cask package...${NC}"

    for item in `cat $ENV_DIR/packages/cask-pkg`
    do
        read -p "${LightRed}Do you want to install '$item'? (y/n) ${NC}" confirm
        if [[ $confirm == "y" ]]; then
            brew install --cask $item
            brew cleanup $item
        fi
    done
}

function install_powerline_fonts() {
    echo "${LightGreen}execute install powerline fonts...${NC}"

    if [[ ! -d $HOME/.powerline-fonts ]]; then
        git clone --depth=1 $POWERLINE_FONTS_URL $HOME/.powerline-fonts
        $HOME/.powerline-fonts/install.sh
    fi
}

function init_env() {
    echo "${LightGreen}execute init environment...${NC}"

    clone_env

    cd $HOME
    ln -sfv $ENV_DIR/gitconfig .gitconfig
    ln -sfv $ENV_DIR/tmux.conf .tmux.conf
    ln -sfv $ENV_DIR/vimrc .vimrc
    ln -sfv $ENV_DIR/vim_dir .vim
    ln -sfv $ENV_DIR/fish .config/fish
    ln -sfv $ENV_DIR/neovim/lua .config/nvim/lua
    ln -sfv $ENV_DIR/neovim/init.lua .config/nvim/init.lua
    cd $CURRENT_DIR
}

function install_all() {
    clone_env
    install_brew
    install_brew_pkg
    install_cask_pkg
    install_powerline_fonts

    init_env
}

cat << EOF
select a function code:
===============================
【 1 】 Install brew
【 2 】 Install brew packages
【 3 】 Install cask packages
【 4 】 Install powerline fonts
【 5 】 Init environment
【 0 】 Install all
【 e 】 Exit
===============================
EOF

if [[ -n $1 ]]; then
    choice=$1
    echo "${LightGreen}execute: $1 ${NC}"
else
    read -p $"${Orange}select: ${NC}" choice
fi

case $choice in
    1) install_brew;;
    2) install_brew_pkg;;
    3) install_cask_pkg;;
    4) install_powerline_fonts;;
    5) init_env;;
    0) install_all;;
    e) echo "${LightGreen}Bye, Bye.${NC}" && exit;;
esac

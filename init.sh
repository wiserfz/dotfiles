#!/bin/bash
# shellcheck disable=2013

CURRENT_DIR=$PWD

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
POWERLINE_FONTS_URL="https://github.com/powerline/fonts.git"
PYTHON_VERSION="3.11.2"
PYENV_URL="https://pyenv.run"
ENV_URL="https://github.com/Gitfz810/env_conf.git"
ENV_DIR="$HOME/workspace/env_conf"

# Black=$'\e[0;30m'
Red=$'\e[0;31m'
Green=$'\e[0;32m'
Orange=$'\e[0;33m'
Blue=$'\e[0;34m'
# Purple=$'\e[0;35m'
Cyan=$'\e[0;36m'
# LightGray=$'\e[0;37m'
# DarkGray=$'\e[1;30m'
LightRed=$'\e[1;31m'
LightGreen=$'\e[1;32m'
Yellow=$'\e[1;33m'
# LightBlue=$'\e[1;34m'
# LightPurple=$'\e[1;35m'
# LightCyan=$'\e[1;36m'
White=$'\e[1;37m'
NC=$'\e[0m'

function exist() {
    command -v "$1" >/dev/null 2>&1
    return $?
}

function clone_env() {
    if [[ ! -d $ENV_DIR ]]; then
        git clone "$ENV_URL" "$ENV_DIR"
    fi
}

function install_brew() {
    read -rp "${Yellow}Do you want to install Homebrew? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    if [[ $(uname) == "Darwin" ]] && ! exist brew
    then
        xcode-select --install
        ruby -e "$(curl -fsSL $BREW_URL)"
    fi

    echo "${LightGreen}Install Homebrew over.${NC}"
}

function install_brew_pkg() {
    read -rp "${Yellow}Do you want to install Homebrew packages? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    for item in $(cat "$ENV_DIR/packages/brew-pkg"); do
        read -rp "${Blue}Do you want to install ${Red}'$item'${Blue}? (y/n): ${NC}" confirm
        if [[ $confirm == "y" ]]
        then
            brew install "$item"
            if [[ $item == "go" ]]
            then
                go env -w GOPATH="$HOME/workspace/go"
                go env -w GOPROXY="https://goproxy.cn,direct"
                go env -w GO111MODULE="on"
            fi
            brew cleanup "$item"
            echo "${Green}Install ${Red}$item ${Blue}over.${NC}"
        fi
    done

    echo "${LightGreen}Install Homebrew packages over.${NC}"
}

function install_cask_pkg() {
    read -rp "${Yellow}Do you want to install cask packages? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    for item in $(cat "$ENV_DIR/packages/cask-pkg"); do
        read -rp "${Blue}Do you want to install ${Red}'$item'${Blue}? (y/n): ${NC}" confirm
        if [[ $confirm == "y" ]]
        then
            brew install --cask "$item"
            brew cleanup "$item"
            echo "${Blue}Install ${Red}$item ${Blue}over.${NC}"
        fi
    done

    echo "${LightGreen}Install cask packages over.${NC}"
}

function install_pyenv() {
    read -rp "${Yellow}Do you want to install pyenv? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    if [[ ! -d "$HOME/.pyenv" ]]; then
        curl "$PYENV_URL" | bash
        eval "$HOME/.pyenv/bin/pyenv init -"
        eval "$HOME/.pyenv/bin/pyenv virtualenv-init -"
        "$HOME/.pyenv/bin/pyenv" update

        echo "${LightGreen}Install pyenv over.${NC}"
    else
        echo "${LightGreen}Pyenv is already installed.${NC}"
    fi
}

function install_python_pkg() {
    read -rp "${Yellow}Do you want to install python packages? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    pyenv global "$PYTHON_VERSION"
    pip install -r "$ENV_DIR/packages/python-pkg"

    echo "${LightGreen}Python packages are installed over.${NC}"
}

function install_powerline_fonts() {
    read -rp "${Yellow}Do you want to install powerline fonts? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    if [[ ! -d $HOME/.powerline-fonts ]]; then
        git clone --depth=1 "$POWERLINE_FONTS_URL $HOME/.powerline-fonts"
        "$HOME/.powerline-fonts/install.sh"
    fi

    echo "${LightGreen}Install powerline fonts over.${NC}"
}

function install_nerd_fonts() {
    read -rp "${Yellow}Do you want to install nerd fonts? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    if ! exist brew; then
        echo "${LightRed}Homebrew not installed, please install it first!${NC}"
        return
    fi

    brew tap homebrew/cask-fonts
    read -rp "${White}Enter fonts name which should be installed, suggest ${LightRed}'font-jetbrains-mono-nerd-font': ${NC}" confirm
    brew install "${confirm}"

    echo "${LightGreen}Install nerd fonts ${LightRed}$confirm ${LightGreen}over.${NC}"
}

function init_env() {
    read -rp "${Yellow}Do you want to init environment? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    clone_env

    cd "$HOME" || return
    rm -rf .gitconfig
    ln -sfv "$ENV_DIR"/gitconfig .gitconfig

    rm -rf .gitignore
    ln -sfv "$ENV_DIR"/gitignore-glob .gitignore

    rm -rf .tmux.conf
    ln -sfv "$ENV_DIR"/tmux.conf .tmux.conf

    rm -rf .vimrc
    ln -sfv "$ENV_DIR"/vimrc .vimrc

    rm -rf .vim
    ln -sfv "$ENV_DIR"/vim_dir .vim

    rm -rf .config/fish
    ln -sfv "$ENV_DIR"/fish .config/fish

    rm -rf .config/nvim/lua
    ln -sfv "$ENV_DIR"/neovim/lua .config/nvim/lua

    rm -rf .config/nvim/init.lua
    ln -sfv "$ENV_DIR"/neovim/init.lua .config/nvim/init.lua

    cd "$CURRENT_DIR" || return

    echo "${LightGreen}Init environment finished.${NC}"
}

function install_all() {
    clone_env
    install_brew
    install_brew_pkg
    install_cask_pkg
    install_pyenv
    install_python_pkg
    install_powerline_fonts
    install_nerd_fonts

    init_env
}

cat << EOF
${Cyan}select a function code:
===============================
【 1 】 Install brew
【 2 】 Install brew packages
【 3 】 Install cask packages
【 4 】 Install pyenv
【 5 】 Install python packages
【 6 】 Install powerline fonts
【 7 】 Install nerd fonts
【 8 】 Init environment
【 0 】 Install all
【 e 】 Exit
===============================${NC}
EOF

if [[ -n $1 ]]; then
    choice=$1
    echo "${LightGreen}execute: $1 ${NC}"
else
    read -rp $"${Orange}select: ${NC}" choice
fi

case $choice in
    1) install_brew;;
    2) install_brew_pkg;;
    3) install_cask_pkg;;
    4) install_pyenv;;
    5) install_python_pkg;;
    6) install_powerline_fonts;;
    7) install_nerd_fonts;;
    8) init_env;;
    0) install_all;;
    e) echo "${LightGreen}Bye, Bye.${NC}" && exit;;
esac

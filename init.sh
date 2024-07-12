#!/bin/bash
# shellcheck disable=2013

CURRENT_DIR=$PWD

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
POWERLINE_FONTS_URL="https://github.com/powerline/fonts.git"
PYTHON_VERSION="3.11.2"
PRJ_URL="https://github.com/Gitfz810/dotfiles.git"
PRJ_DIR="$HOME/workspace/dotfiles"
CODELLDB_DIR="$HOME/.local/codelldb"
ARCH=$(uname -m)

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
    command -v "$1" > /dev/null 2>&1
    return $?
}

function clone_env() {
    if [[ ! -d $PRJ_DIR ]]; then
        git clone "$PRJ_URL" "$PRJ_DIR"
    fi
}

function install_brew() {
    read -rp "${Yellow}Do you want to install Homebrew? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    if [[ $(uname) == "Darwin" ]] && ! exist brew; then
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

    for item in $(cat "$PRJ_DIR/packages/brew-pkg"); do
        read -rp "${Blue}Do you want to install ${Red}'$item'${Blue}? (y/n): ${NC}" confirm
        if [[ $confirm == "y" ]]; then
            brew install "$item"
            if [[ $item == "go" ]]; then
                # go env -w GOPATH="$HOME/go"
                go env -w GOPROXY="https://goproxy.cn,direct"
                go env -w GO111MODULE="on"
            elif [[ $item == "tmux" ]]; then
                if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
                    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
                fi
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

    for item in $(cat "$PRJ_DIR/packages/cask-pkg"); do
        read -rp "${Blue}Do you want to install ${Red}'$item'${Blue}? (y/n): ${NC}" confirm
        if [[ $confirm == "y" ]]; then
            brew install --cask "$item"
            brew cleanup "$item"
            echo "${Blue}Install ${Red}$item ${Blue}over.${NC}"
        fi
    done

    echo "${LightGreen}Install cask packages over.${NC}"
}

function install_python_pkg() {
    read -rp "${Yellow}Do you want to install python packages? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    pyenv global "$PYTHON_VERSION"
    pip install -r "$PRJ_DIR/packages/python-pkg"

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
    read -rp "${White}Enter fonts name which should be installed, suggest ${LightRed}'font-jetbrains-mono-nerd-font': ${NC}" font
    brew install "${font}"

    echo "${LightGreen}Install nerd fonts ${LightRed}$font ${LightGreen}over.${NC}"
}

function install_codelldb() {
    read -rp "${Yellow}Do you want to install codelldb(debug plugin)? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    read -rp "${Yellow}Please enter install version of codelldb(e.g. v1.9.0): ${NC}" version

    arch=$ARCH
    if [[ "$ARCH" == "arm64" ]]; then
        arch="aarch64"
    fi

    url=$(printf "https://github.com/vadimcn/codelldb/releases/download/%s/codelldb-${arch}-darwin.vsix" "$version")
    echo "$url"

    if [[ ! -d "$CODELLDB_DIR/extension" ]]; then
        filename="codelldb-${arch}-darwin.vsix"
        curl --location --remote-name -s "$url" -o "$filename"
        unzip -qo "$filename" -d "$CODELLDB_DIR/"
        rm -f "$filename"
    fi

    echo "${LightGreen}Install codelldb version $version over.${NC}"
}

function init_env() {
    read -rp "${Yellow}Do you want to init environment? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    clone_env

    cd "$HOME" || return
    rm -rf .gitconfig
    ln -sfv "$PRJ_DIR"/gitconfig .gitconfig

    rm -rf .gitignore
    ln -sfv "$PRJ_DIR"/gitignore .gitignore

    rm -rf .tmux.conf
    ln -sfv "$PRJ_DIR"/tmux.conf .tmux.conf

    rm -rf .vimrc
    ln -sfv "$PRJ_DIR"/vimrc .vimrc

    rm -rf .vim
    ln -sfv "$PRJ_DIR"/vim_dir .vim

    rm -rf .config/fish
    ln -sfv "$PRJ_DIR"/fish .config/fish

    dir="$HOME/.config/nvim"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi

    rm -rf .config/nvim
    ln -sfv "$PRJ_DIR"/nvim .config/nvim

    rm -rf .config/yamllint
    ln -sfv "$PRJ_DIR"/config/yamllint .config/yamllint

    rm -rf .config/yamlfmt
    ln -sfv "$PRJ_DIR"/config/yamlfmt .config/yamlfmt

    rm -rf .config/hadolint.yaml
    ln -sfv "$PRJ_DIR"/config/hadolint.yaml .config/hadolint.yaml

    rm -rf .config/gitstatus.py
    ln -sfv "$PRJ_DIR"/gitstatus.py .config/gitstatus.py

    cd "$CURRENT_DIR" || return

    echo "${LightGreen}Init environment finished.${NC}"
}

function install_all() {
    clone_env
    install_brew
    install_brew_pkg
    install_cask_pkg
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
【 4 】 Install python packages
【 5 】 Install powerline fonts
【 6 】 Install nerd fonts
【 7 】 Init environment
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
    1) install_brew ;;
    2) install_brew_pkg ;;
    3) install_cask_pkg ;;
    4) install_python_pkg ;;
    5) install_powerline_fonts ;;
    6) install_nerd_fonts ;;
    7) init_env ;;
    0) install_all ;;
    e) echo "${LightGreen}Bye, Bye.${NC}" && exit ;;
esac

#!/bin/bash
# shellcheck disable=2013

CURRENT_DIR=$PWD

BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
POWERLINE_FONTS_URL="https://github.com/powerline/fonts.git"
PRJ_URL="https://github.com/wiserfz/dotfiles.git"
PRJ_DIR="$HOME/Workspace/dotfiles"
ARCH=$(uname -m)

HOMEBREW_PREFIX="/usr/local"
if [[ $ARCH == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
fi

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
        bash -c "$(curl -fsSL $BREW_URL)"
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
            if [[ $item == "mise" ]]; then
                # for mise completion
                mise use -g usage
            elif [[ $item == "tmux" ]]; then
                if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
                    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
                fi
                if [[ $ARCH == "arm64" ]]; then
                    sudo mkdir -p /usr/local/bin/

                    sudo ln -sfv "$HOMEBREW_PREFIX/bin/tmux" /usr/local/bin/tmux
                fi
            elif [[ $item == "fish" ]]; then
                if [[ $ARCH == "arm64" ]]; then
                    sudo mkdir -p /usr/local/bin/
                    sudo ln -sfv "$HOMEBREW_PREFIX/bin/fish" /usr/local/bin/fish
                fi

                # set default shell to fish
                echo /usr/local/bin/fish | sudo tee -a /etc/shells
                chsh -s /usr/local/bin/fish
            elif [[ $item = "pinentry-mac" ]]; then
                echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf

                killall gpg-agent
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

function install_go() {
    if ! exist mise; then
        echo "${LightRed}mise not installed, please install it first!${NC}"
        return
    fi

    mise use -g go
    # set go env
    go env -w GO111MODULE="on"
    go env -w GOPROXY="https://goproxy.cn,direct"

    echo "${LightGreen}Install go over.${NC}"
}

function install_python() {
    if ! exist mise; then
        echo "${LightRed}mise not installed, please install it first!${NC}"
        return
    fi

    mise use -g python

    echo "${LightGreen}Install python over.${NC}"
}

function install_erlang() {
    if ! exist mise; then
        echo "${LightRed}mise not installed, please install it first!${NC}"
        return
    fi

    # need install wxwidgets brew install wxwidgets
    env KERL_CONFIGURE_OPTIONS="--enable-wx --with-wx-config=$HOMEBREW_PREFIX/bin/wx-config-3.0 --without-javac --without-odbc --enable-threads --with-ssl=$(brew --prefix openssl@1.1)" mise use -g erlang@26

    echo "${LightGreen}Install erlang over.${NC}"
}

function install_rust() {
    if exist rustc; then
        echo "${LightRed}Rust already installed!${NC}"
        return
    fi

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    echo "${LightGreen}Install rust over.${NC}"
}

function install_node() {
    if ! exist mise; then
        echo "${LightRed}mise not installed, please install it first!${NC}"
        return
    fi

    mise use -g node

    echo "${LightGreen}Install node over.${NC}"
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

function init_env() {
    read -rp "${Yellow}Do you want to init environment? (y/n): ${NC}" confirm
    if [[ $confirm == "n" ]]; then
        return
    fi

    clone_env

    cd "$HOME" || return
    rm -rf .gitconfig
    ln -sfv "$PRJ_DIR/git/gitconfig" .gitconfig

    rm -rf .gitignore
    ln -sfv "$PRJ_DIR/git/gitignore" .gitignore

    rm -rf .tmux.conf
    ln -sfv "$PRJ_DIR/tmux.conf" .tmux.conf

    rm -rf .vimrc
    ln -sfv "$PRJ_DIR/vimrc" .vimrc

    rm -rf .vim
    ln -sfv "$PRJ_DIR/vim" .vim

    dir="$HOME/.config"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi

    rm -rf .config/fish
    ln -sfv "$PRJ_DIR/fish" .config/fish

    rm -rf .config/nvim
    ln -sfv "$PRJ_DIR/nvim" .config/nvim

    rm -rf .config/alacritty
    ln -sfv "$PRJ_DIR/alacritty" .config/alacritty

    rm -rf .config/neovide
    ln -sfv "$PRJ_DIR/neovide" .config/neovide

    rm -rf .config/yamllint
    ln -sfv "$PRJ_DIR/config/yamllint" .config/yamllint

    rm -rf .config/yamlfmt
    ln -sfv "$PRJ_DIR/config/yamlfmt" .config/yamlfmt

    rm -rf .config/hadolint.yaml
    ln -sfv "$PRJ_DIR/config/hadolint.yaml" .config/hadolint.yaml

    cd "$CURRENT_DIR" || return

    echo "${LightGreen}Init environment finished.${NC}"
}

function install_all() {
    clone_env
    install_brew
    install_brew_pkg
    install_cask_pkg
    install_go
    install_python
    install_rust
    install_node
    install_nerd_fonts

    init_env
}

cat << EOF
${Cyan}select a function code:
===============================
【 1 】 Install brew
【 2 】 Install brew packages
【 3 】 Install cask packages
【 4 】 Install golang
【 5 】 Install python
【 6 】 Install rust
【 7 】 Install node
【 8 】 Install nerd fonts
【 9 】 Init environment
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
    4) install_go ;;
    5) install_python ;;
    6) install_rust ;;
    7) install_node ;;
    8) install_nerd_fonts ;;
    9) init_env ;;
    0) install_all ;;
    e) echo "${LightGreen}Bye, Bye.${NC}" && exit ;;
esac

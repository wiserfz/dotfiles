if status is-interactive
    if test (uname) = "Darwin"
        fish_add_path /usr/local/bin
    end

    if test -d $HOME/.local/bin
        fish_add_path $HOME/.local/bin
    end

    if test -d $HOME/.cargo/bin
        fish_add_path $HOME/.cargo/bin
    end

    if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
    end

    if test -d /opt/homebrew/sbin
        fish_add_path /opt/homebrew/sbin
    end

    if test -d $HOME/.pyenv
        set -Ux PYENV_ROOT $HOME/.pyenv
        set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

        # NOTE: disable pyenv prompt
        # see https://github.com/pyenv/pyenv-virtualenv/issues/385
        set -gx PYENV_VIRTUALENV_DISABLE_PROMPT 1
        pyenv init - | source
        pyenv virtualenv-init - | source
    end

    if test -d $HOME/.local/share/nvim/mason/bin
        fish_add_path $HOME/.local/share/nvim/mason/bin
    end

    set go_path (go env GOPATH)
    set -Ux GOPATH $go_path
    if test -d "$GOPATH"/bin
        fish_add_path -g $GOPATH/bin
    end
end

# delete welcome message of fish shell
set fish_greeting ""
set -Ux fish_prompt_pwd_dir_length 0

set -Ux LC_ALL "en_US.UTF-8"
set -Ux CLICOLOR 1

# colorizing pager for man, using bat
set -x MANPAGER "sh -c 'col -bx | bat -l man -p --theme \"Monokai Extended\"'"
# customize colored man pages
# set -x LESS_TERMCAP_mb (printf "\033[01;31m") # begin blinking
# set -x LESS_TERMCAP_md (printf "\033[01;31m") # begin bold
# set -x LESS_TERMCAP_me (printf "\033[0m")     # end mode
# set -x LESS_TERMCAP_se (printf "\033[0m")     # end standout-mode
# set -x LESS_TERMCAP_so (printf "\033[01;44;33m")  # begin standout-mode - info box
# set -x LESS_TERMCAP_ue (printf "\033[0m")     # end underline
# set -x LESS_TERMCAP_us (printf "\033[01;32m") # begin underline

# brew
if command -v brew >/dev/null 2>&1
    set -Ux HOMEBREW_NO_AUTO_UPDATE true  # disable homebrew auto update
    # setup homebrew mirror
    set -Ux HOMEBREW_BREW_GIT_REMOTE "https://mirrors.ustc.edu.cn/brew.git"
    set -Ux HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 7
end

# setup with zoxide
zoxide init fish | source

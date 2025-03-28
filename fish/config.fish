fish_config theme choose "Dracula Official"

if status is-interactive
    if test (uname) = Darwin
        fish_add_path /usr/local/bin
    end

    if test -d $HOME/.local/bin
        fish_add_path $HOME/.local/bin
    end

    if test -d $HOME/.cargo/bin
        fish_add_path $HOME/.cargo/bin
    end

    if command -q brew
        fish_add_path (brew --prefix)/bin
        fish_add_path (brew --prefix)/sbin
    end

    if test -d $HOME/.local/share/nvim/mason/bin
        fish_add_path $HOME/.local/share/nvim/mason/bin
    end
end

# delete welcome message of fish shell
set fish_greeting ""

set -x LC_ALL "en_US.UTF-8"

# colorizing pager for man, using bat
set -x MANPAGER "sh -c 'col -bx | bat -l man -p --theme \"Monokai Extended\"'"

# brew
if command -v brew >/dev/null 2>&1
    # disable homebrew auto update
    set -x HOMEBREW_NO_AUTO_UPDATE true
    # setup homebrew mirror for install package
    # see: https://mirrors.ustc.edu.cn/help/brew.git.html#homebrew-linuxbrew
    set -x HOMEBREW_BREW_GIT_REMOTE "https://mirrors.ustc.edu.cn/brew.git"
    set -x HOMEBREW_CORE_GIT_REMOTE "https://mirrors.ustc.edu.cn/homebrew-core.git"
    set -x HOMEBREW_BOTTLE_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles"
    set -x HOMEBREW_API_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles/api"

    set -x HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 7
    # disable homebrew installed dependents check
    set -x HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK true
end

# # fzf
# set -x FZF_CTRL_T_OPTS "
#     --walker-skip .git,target
#     --preview 'bat -n --color=always {}'
#     --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# set -x FZF_CTRL_R_OPTS "
#     --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
#     --color header:italic
#     --header 'Press CTRL-Y to copy command into clipboard'"
# fzf --fish | source

# setup with mise
mise activate fish | source

# setup with zoxide
zoxide init fish | source

# setup with atuin instead of fzf
atuin init fish | source

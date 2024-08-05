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

    if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
    end

    if test -d /opt/homebrew/sbin
        fish_add_path /opt/homebrew/sbin
    end

    if test -d $HOME/.local/share/nvim/mason/bin
        fish_add_path $HOME/.local/share/nvim/mason/bin
    end
end

# delete welcome message of fish shell
set fish_greeting ""
set -Ux fish_prompt_pwd_dir_length 0

set -Ux LC_ALL "en_US.UTF-8"
set -Ux CLICOLOR 1

# colorizing pager for man, using bat
set -x MANPAGER "sh -c 'col -bx | bat -l man -p --theme \"Monokai Extended\"'"

# brew
if command -v brew >/dev/null 2>&1
    # disable homebrew auto update
    set -Ux HOMEBREW_NO_AUTO_UPDATE true
    # setup homebrew mirror
    set -Ux HOMEBREW_BREW_GIT_REMOTE "https://mirrors.ustc.edu.cn/brew.git"
    set -Ux HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 7
    # disable homebrew installed dependents check
    set -Ux HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK true
end

# fzf
set -Ux FZF_CTRL_T_OPTS "
    --walker-skip .git,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
set -Ux FZF_CTRL_R_OPTS "
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"
fzf --fish | source

# setup with mise
mise activate fish | source

# setup with zoxide
zoxide init fish | source

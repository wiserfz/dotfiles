function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q __dotfiles_project
        set __dotfiles_project ~/workspace/dotfiles/
    end
    # Colors
    # Reset
    set reset_color (set_color normal) # Text Reset

    # Regular Colors
    set red (set_color red) # red
    set yellow (set_color yellow) # yellow
    set blue (set_color blue) # blue
    set white (set_color white)
    set green (set_color green)

    # Bold
    set bold_red (set_color -o red)
    set bold_green (set_color -o green) # Green
    set bold_white (set_color -o white)

    set git_changed_color (set_color -o ffc600)
    set git_add_color (set_color -o 3ad900)
    set git_delete_color (set_color -o ff2600)
    set git_remote_color (set_color -o 009aa6)

    # High Intensty
    set intensty_black (set_color -o black) # Black

    # Bold High Intensty
    set magenta (set_color -o purple) # Purple

    set tiffany_blue (set_color -o 81D8D0)

    # rust
    set bold_orange (set_color -o F05A1B)
    # go
    set br_blue (set_color -o 4DD1FF)
    # python
    set br_green (set_color -o BFD55D)

    # Default values for the appearance of the prompt. Configure at will.
    set prompt_prefix "["
    set prompt_suffix "]"
    set prompt_separator "|"

    # Various variables you might want for your PS1 prompt instead
    # set Time (date +%R)
    set path_short (pwd|sed "s=$HOME=~=")

    set prompt_start "$yellow$path_short$reset_color"
    set prompt_end " \n$bold_white\$ $reset_color"
    if test $__last_command_exit_status != 0
        set prompt_end " \n$bold_red\$ $reset_color"
    end

    # pyenv
    set prompt_pyenv ""
    set py_env $VIRTUAL_ENV
    set requirements "requirements.txt"
    if test -n "$py_env" || test -f "$requirements"
        set python_icon "🐍"
        set python_version (pyenv version-name)
        set prompt_pyenv " $python_icon $br_green$python_version$reset_color"
    end

    # rust
    set prompt_rust ""
    set cargo_config "Cargo.toml"
    if test -f "$cargo_config"
        set rust_icon "🦀"
        set rust_version (rustc --version | string split ' ' -f 2)
        set prompt_rust " $rust_icon $bold_orange$rust_version$reset_color"
    end

    # go
    set prompt_go ""
    set go_config "go.mod"
    if test -f "$go_config"
        set go_icon "ʕ◔ϖ◔ʔ"
        set go_version (go version | string split ' ' -f 3 | string trim -c "go")
        set prompt_go " $br_blue$go_icon $go_version$reset_color"
    end

    set -e __current_git_status
    set gitstatus "$__dotfiles_project/git/gitstatus.py"

    set __current_git_status (python $gitstatus)

    set __current_git_status_param_count (count $__current_git_status)

    set git_prompt_branch "$magenta"
    set git_prompt_staged "$git_add_color● "
    set git_prompt_conflicts "$git_delete_color✖ "
    set git_prompt_changed "$git_changed_color✚ "
    set git_prompt_remote "$git_remote_color 󰅡 "
    set git_prompt_untracked "$tiffany_blue "
    set git_prompt_stashed "$intensty_black⚑ "
    set git_prompt_clean "$bold_green✔"

    if test 0 -ne $__current_git_status_param_count
        set git_branch "$__current_git_status[1]"
        set git_remote "$__current_git_status[2]"
        if contains "." "$git_remote"
            set -e git_remote
        end
        set git_staged $__current_git_status[3]
        set git_conflicts $__current_git_status[4]
        set git_changed $__current_git_status[5]
        set git_untracked $__current_git_status[6]
        set git_stashed $__current_git_status[7]
        set git_clean $__current_git_status[8]
    end

    if test -n "$__current_git_status"
        set git_status " $prompt_prefix$git_prompt_branch$git_branch$reset_color"

        if set -q git_remote
            set git_status "$git_status$git_prompt_remote$git_remote$reset_color"
        end

        set git_status "$git_status$prompt_separator"

        if [ $git_staged != 0 ]
            set git_status "$git_status$git_prompt_staged$git_staged$reset_color"
        end

        if [ $git_conflicts != 0 ]
            set git_status "$git_status$git_prompt_conflicts$git_conflicts$reset_color"
        end

        if [ $git_changed != 0 ]
            set git_status "$git_status$git_prompt_changed$git_changed$reset_color"
        end

        if [ "$git_untracked" != 0 ]
            set git_status "$git_status$git_prompt_untracked$git_untracked$reset_color"
        end

        if [ "$git_stashed" != 0 ]
            set git_status "$git_status$git_prompt_stashed$git_stashed$reset_color"
        end

        if [ "$git_clean" = 1 ]
            set git_status "$git_status$git_prompt_clean"
        end

        set git_status "$git_status$reset_color$prompt_suffix"

        set PS1 "$prompt_start$git_status$prompt_pyenv$prompt_go$prompt_rust$prompt_end"
    else
        set PS1 "$prompt_start$prompt_pyenv$prompt_go$prompt_rust$prompt_end"
    end

    echo -e $PS1

end

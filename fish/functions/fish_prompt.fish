function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q __CONFIG_DIR
        set __CONFIG_DIR ~/.config
    end
    # Colors
    # Reset
    set ResetColor (set_color normal) # Text Reset

    # Regular Colors
    set Red (set_color red) # Red
    set Yellow (set_color yellow) # Yellow
    set Blue (set_color blue) # Blue
    set White (set_color white)
    set Green (set_color green)

    # Bold
    set BRed (set_color -o red)
    set BGreen (set_color -o green) # Green
    set BWhite (set_color -o white)
    set BBlue (set_color -o blue)

    # High Intensty
    set IBlack (set_color -o black) # Black

    # Bold High Intensty
    set Magenta (set_color -o purple) # Purple

    set BCyan (set_color -o cyan)

    # rust
    set BOrange (set_color -o F05A1B)
    # go
    set BBrBlue (set_color -o 4DD1FF)
    # python
    set BBrGreen (set_color -o BFD55D)

    # Default values for the appearance of the prompt. Configure at will.
    set PROMPT_PREFIX "["
    set PROMPT_SUFFIX "]"
    set PROMPT_SEPARATOR "|"
    set PROMPT_

    # Various variables you might want for your PS1 prompt instead
    # set Time (date +%R)
    set PathShort (pwd|sed "s=$HOME=~=")

    set PROMPT_START "$Yellow$PathShort$ResetColor"
    set PROMPT_END " \n$BWhite\$ $ResetColor"
    if test $__last_command_exit_status != 0
        set PROMPT_END " \n$BRed\$ $ResetColor"
    end

    # pyenv
    set PROMPT_PYENV ""
    set py_env $VIRTUAL_ENV
    if test -n "$py_env"
        set PYTHON "🐍"
        set PYTHON_VERSION (pyenv version-name)
        set PROMPT_PYENV " $PYTHON $BBrGreen$PYTHON_VERSION$ResetColor"
    end

    # rust
    set PROMPT_RUST ""
    set CARGO_CONFIG "Cargo.toml"
    if test -f "$CARGO_CONFIG"
        set RUST "🦀"
        set RUST_VERSION (rustc --version | string split ' ' -f 2)
        set PROMPT_RUST " $RUST $BOrange$RUST_VERSION$ResetColor"
    end

    # go
    set PROMPT_GO ""
    set GO_CONFIG "go.mod"
    if test -f "$GO_CONFIG"
        set GO "ʕ◔ϖ◔ʔ"
        set GO_VERSION (go version | string split ' ' -f 3 | string trim -c "go")
        set PROMPT_GO " $BBrBlue$GO $GO_VERSION$ResetColor"
    end

    set -e __CURRENT_GIT_STATUS
    set gitstatus "$__CONFIG_DIR/gitstatus.py"

    set _GIT_STATUS (python $gitstatus)
    set __CURRENT_GIT_STATUS $_GIT_STATUS

    set __CURRENT_GIT_STATUS_PARAM_COUNT (count $__CURRENT_GIT_STATUS)

    set GIT_PROMPT_BRANCH "$Magenta"
    set GIT_PROMPT_STAGED "$Red● "
    set GIT_PROMPT_CONFLICTS "$Red✖ "
    set GIT_PROMPT_CHANGED "$Blue✚ "
    set GIT_PROMPT_REMOTE " "
    set GIT_PROMPT_UNTRACKED "…"
    set GIT_PROMPT_STASHED "⚑ "
    set GIT_PROMPT_CLEAN "$BGreen✔"

    if not test 0 -eq $__CURRENT_GIT_STATUS_PARAM_COUNT
        set GIT_BRANCH $__CURRENT_GIT_STATUS[1]
        set GIT_REMOTE "$__CURRENT_GIT_STATUS[2]"
        if contains "." "$GIT_REMOTE"
            set -e GIT_REMOTE
        end
        set GIT_STAGED $__CURRENT_GIT_STATUS[3]
        set GIT_CONFLICTS $__CURRENT_GIT_STATUS[4]
        set GIT_CHANGED $__CURRENT_GIT_STATUS[5]
        set GIT_UNTRACKED $__CURRENT_GIT_STATUS[6]
        set GIT_STASHED $__CURRENT_GIT_STATUS[7]
        set GIT_CLEAN $__CURRENT_GIT_STATUS[8]
    end

    if test -n "$__CURRENT_GIT_STATUS"
        set STATUS " $PROMPT_PREFIX$GIT_PROMPT_BRANCH$GIT_BRANCH$ResetColor"

        if set -q GIT_REMOTE
            set STATUS "$STATUS$GIT_PROMPT_REMOTE$GIT_REMOTE$ResetColor"
        end

        set STATUS "$STATUS$PROMPT_SEPARATOR"

        if [ $GIT_STAGED != 0 ]
            set STATUS "$STATUS$GIT_PROMPT_STAGED$GIT_STAGED$ResetColor"
        end

        if [ $GIT_CONFLICTS != 0 ]
            set STATUS "$STATUS$GIT_PROMPT_CONFLICTS$GIT_CONFLICTS$ResetColor"
        end

        if [ $GIT_CHANGED != 0 ]
            set STATUS "$STATUS$GIT_PROMPT_CHANGED$GIT_CHANGED$ResetColor"
        end

        if [ "$GIT_UNTRACKED" != 0 ]
            set STATUS "$STATUS$GIT_PROMPT_UNTRACKED$GIT_UNTRACKED$ResetColor"
        end

        if [ "$GIT_STASHED" != 0 ]
            set STATUS "$STATUS$GIT_PROMPT_STASHED$GIT_STASHED$ResetColor"
        end

        if [ "$GIT_CLEAN" = 1 ]
            set STATUS "$STATUS$GIT_PROMPT_CLEAN"
        end

        set STATUS "$STATUS$ResetColor$PROMPT_SUFFIX"

        set PS1 "$PROMPT_START$STATUS$PROMPT_PYENV$PROMPT_GO$PROMPT_RUST$PROMPT_END"
    else
        set PS1 "$PROMPT_START$PROMPT_PYENV$PROMPT_GO$PROMPT_RUST$PROMPT_END"
    end

    echo -e $PS1

end

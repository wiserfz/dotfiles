function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q -g __fish_arrow_functions_defined
        set -g __fish_arrow_functions_defined
        function _git_branch_name
            set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
            set -l branch_name
            if set -q branch[1]
                set branch_name (string replace -r '^refs/heads/' '' $branch)
            else
                set branch_name (git rev-parse --short HEAD 2>/dev/null)
            end

            echo $branch_name
        end

        function _is_git_dirty
            not command git diff-index --cached --quiet HEAD -- &>/dev/null
            or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
        end

        function _git_show_ahead
            set -l ahead

            set -l ahead_mark "↑"
            set -l ahead_count (git rev-list origin/$argv[1]..HEAD --count 2>/dev/null)

            if test $status -eq 0
                and test $ahead_count -gt 0
                set ahead " $ahead_mark$ahead_count"
            end
            echo $ahead
        end

        function _git_show_behind
            set -l behind

            set -l behind_mark "↓"
            set -l behind_count (git rev-list HEAD..origin/$argv[1] --count 2>/dev/null)

            if test $status -eq 0
                and test $behind_count -gt 0
                set behind " $behind_mark$behind_count"
            end
            echo $behind
        end

        function _is_git_repo
            type -q git
            or return 1
            git rev-parse --git-dir >/dev/null 2>&1
        end

        function _hg_branch_name
            echo (hg branch 2>/dev/null)
        end

        function _is_hg_dirty
            set -l stat (hg status -mard 2>/dev/null)
            test -n "$stat"
        end

        # TODO: show upstream for hg
        function _hg_show_ahead
            return 0
        end

        function _hg_show_behind
            return 0
        end

        function _is_hg_repo
            fish_print_hg_root >/dev/null
        end

        function _repo_branch_name
            _$argv[1]_branch_name
        end

        function _is_repo_dirty
            _is_$argv[1]_dirty
        end

        function _show_ahead
            _$argv[1]_show_ahead $argv[2]
        end

        function _show_behind
            _$argv[1]_show_behind $argv[2]
        end

        function _repo_type
            if _is_hg_repo
                echo hg
                return 0
            else if _is_git_repo
                echo git
                return 0
            end
            return 1
        end
    end

    set -l black (set_color -o black)
    set -l white (set_color -o white)
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l magenta (set_color -o magenta)
    set -l normal (set_color normal)

    set -l time (date +%H:%M:%S)
    set time "$magenta$time "

    set -l dollar_color "$green"
    if test $__last_command_exit_status != 0
        set dollar_color "$red"
    end

    set -l dollar "$dollar_color\$ "
    if fish_is_root_user
        set dollar "$dollor_color# "
    end

    set -l cwd $yellow(prompt_pwd)

    set -l repo_info
    if set -l repo_type (_repo_type)
        set -l repo_branch (_repo_branch_name $repo_type)
        set -l repo_ahead (_show_ahead $repo_type $repo_branch)
        set -l repo_behind (_show_behind $repo_type $repo_branch)

        set repo_info "$blue $repo_type:($cyan$repo_branch$green$repo_ahead$red$repo_behind$blue)"

        if _is_repo_dirty $repo_type
            set -l dirty "$red ✗"
            set repo_info "$repo_info$dirty"
        end
    end

    echo -n -s ''$time $cwd $repo_info $normal \n''$dollar''
end

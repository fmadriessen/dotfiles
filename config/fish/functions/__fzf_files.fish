function __fzf_files --description 'List files and folders'
    set --local commandline (__fzf_parse_commandline)
    set --local dir $commandline[1]
    set --local query $commandline[2]
    set --local prefix $commandline[3]


    test -n "$FZF_CTRL_T_COMMAND"; or set -l FZF_CTRL_T_COMMAND "command fd --exclude .git --full-path \$dir"
    test -n "$FZF_TMUX_HEIGHT"; or set -l FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

    eval "$FZF_CTRL_T_COMMAND | "fzf' --query "'$query'"' | while read -l r
        set result $result $r
    end

    if test -z "$result"
        commandline --function repaint
        return
    else
        commandline --current-token ""
    end

    for i in $result
        commandline -it -- $prefix
        commandline -it -- (string escape $i)
        commandline -it -- ' '
    end

    commandline --function repaint
end

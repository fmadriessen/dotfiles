function __fzf_cd --description 'Change directory'
    set --local commandline (__fzf_parse_commandline)
    set --local dir $commandline[1]
    set --local query $commandline[2]
    set --local prefix $commandline[3]

    test -n "$FZF_ALT_C_COMMAND"; or set --local FZF_ALT_C_COMMAND "command fd --follow --exclude .git --real-path \$dir"
    test -n "$FZF_TMUX_HEIGHT"; or set --local FZF_TMUX_HEIGHT 40%

    set --local --export FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS"
    eval "$FZF_ALT_C_COMMAND | "fzf' +m --query "'$query'"' | read --local result

    if test -n "$result"
        cd -- $result

        commandline --current-token ""
        commandline -it -- $prefix
    end

    commandline --function repaint
end

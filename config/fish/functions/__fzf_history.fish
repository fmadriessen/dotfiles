function __fzf_history --description "Show command history"
    set -lx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m"

    history --null \
        | string replace -ar "\x0" ";__delim__;" \
        | fish_indent --ansi --no-indent \
        | string replace --all --regex __delim__ "\x0" \
        | fzf --no-multi --tiebreak=index --read0 --print0 --ansi --query=(commandline) \
        | read --local --null cmd

    if test $status -eq 0
        commandline --replace -- (echo $cmd | sed -zr "s#^\s+|\s+\$##g")
    end

    commandline --function repaint
end

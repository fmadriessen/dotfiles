function __fzf_parse_commandline --description 'Parse the current commandline and return existing filepath, query, and optional -option= prefix'
    set --local commandline (commandline --current-token)

    # Strip prefix from commandline
    set --local prefix (string match --regex -- '^-[^\s=]+=' $commandline)
    set commandline (string replace -- "$prefix" "" $commandline)

    # Use eval to perform shell expansion
    eval set commandline $commandline

    if test -z $commandline
        set dir '.'
        set query ''
    else
        set dir (__fzf_get_dir $commandline)

        if test $dir = "." -a (string sub --length 1 -- $commandline) != "."
            set query $commandline
        else
            set query (string replace --regex "^$dir/?" -- '' $commandline)
        end
    end

    echo $dir
    echo $query
    echo $prefix
end

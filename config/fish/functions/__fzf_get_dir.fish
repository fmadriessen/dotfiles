function __fzf_get_dir --description 'Find the longest filepath in input string'
    set dir $argv

    if test (string length -- $dir) -gt 1
        set dir (string replace --regex '/*$' -- '' $dir)
    end

    while not test -d $dir
        set dir (dirname -- $dir)
    end

    echo $dir
end

function tree --wraps=exa
    set --local ignored .git node_modules
    set ignored (string join --no-empty '|' $ignored)

    exa --tree --git --ignore-glob $ignored $argv
end

function zg --description 'Jump to git root directory'
    set --local repo_info (command git rev-parse --is-inside-work-tree --show-toplevel 2>/dev/null)
    set --local inside_worktree $repo_info[1]
    set --local toplevel $repo_info[2]

    if not test $inside_worktree = true
        echo "Not inside a git directory"
        exit 1
    end

    cd $toplevel
end

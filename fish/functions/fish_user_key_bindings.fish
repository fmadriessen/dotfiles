function fish_user_key_bindings
    bind \cy accept-autosuggestion
    #bind \ce suppress-autosuggestion

    bind \cn complete
    bind \cp complete-and-search

    bind \cz 'fg 2>/dev/null 1>&2; commandline --function repaint'
end

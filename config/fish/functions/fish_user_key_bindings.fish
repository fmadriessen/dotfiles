function fish_user_key_bindings
    bind \ce suppress-autosuggestion
    bind \cy accept-autosuggestion

    bind \cn complete
    bind \cp complete-and-search
    bind \cj history-search-forward
    bind \ck history-search-backward

    bind \cz 'fg 2>/dev/null; commandline --function repaint'

    bind \cr __fzf_history
    bind \ct __fzf_files
    bind \ec __fzf_cd
end

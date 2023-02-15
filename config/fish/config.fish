# See also
# - ./functions/fish_user_key_bindings.fish - Key bindings
# - ./conf.d/fzf.fish - Configuration of FZF widgets

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"

set -gx ZK_NOTEBOOK_DIR $HOME/doc/notes

fish_add_path $HOME/.local/bin

if status is-interactive
    set --global fish_greeting

    abbr --add !! --position anywhere --function __last_history_item

    alias edit nvim
    alias diff delta
    alias view bat
    alias ls "exa --git --icons"
    alias ll "ls --long"
    alias la "ls --long --all"
    alias copy wl-copy

    command zoxide init fish | source
    command starship init fish | source
    _shell_integration
end

set --export EDITOR nvim
set --export MANPAGER 'nvim +Man'

# The following is only executed for interactive shells
if not status is-interactive
    exit
end

set --global fish_greeting

alias edit nvim

abbr :e edit
abbr :q exit

zoxide init fish | source

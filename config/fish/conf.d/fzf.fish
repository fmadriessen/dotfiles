# FZF is configured using the following variables
# - $FZF_DEFAULT_COMMAND
# - $FZF_DEFAULT_OPTS
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS
#
# See also https://github.com/junegunn/fzf and `man fzf`

set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --exclude .git"
set -gx FZF_DEFAULT_OPTS "
    --color=16
    --height 40%
    --layout reverse
    --preview-window down
    --multi
    --bind 'ctrl-d:preview-half-page-down'
    --bind 'ctrl-u:preview-half-page-up'
    --bind 'ctrl-/:change-preview-window(hidden|)'"

set -gx FZF_CTRL_T_COMMAND "fd --follow --exclude .git --full-path \$dir"
set -gx FZF_CTRL_T_OPTS "
    --select-1
    --exit-0
    --preview 'bat --style plain --color=always {}'
    --bind 'alt-i:reload($FZF_CTRL_T_COMMAND --hidden)'"

set -gx FZF_ALT_C_COMMAND "fd --type directory --follow --exclude .git"
set -gx FZF_ALT_C_OPTS "
    --select-1
    --exit-0
    --no-multi
    --preview 'tree {}'
    --bind 'alt-i:reload($FZF_ALT_C_COMMAND --hidden)'"

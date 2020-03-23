# jeff-fino.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for all people. Tested on Linux Ubuntu Bionic.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#   fino
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

BOX_NAME=${SHORT_HOST:-$HOST}

local git_info='$(git_prompt_info)'
local prompt_char='$'


PROMPT="
%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}${BOX_NAME}%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}${git_info} %{$FG[239]%}
${prompt_char}%{$reset_color%} "
RPROMPT="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} x"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%} ✔"
ZSH_THEME_RUBY_PROMPT_PREFIX="‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Machine-specific overrides
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

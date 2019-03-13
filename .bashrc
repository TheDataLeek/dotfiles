#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=$PATH:/home/zoe/bin:/home/zoe/node_modules/bin
export npm_config_prefix=/home/zoe/node_modules

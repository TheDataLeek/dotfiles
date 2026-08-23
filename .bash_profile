# ~/.bash_profile

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Machine-specific overrides
[[ -f ~/.bash_profile.local ]] && source ~/.bash_profile.local

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

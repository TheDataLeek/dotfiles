function ls
    command ls -lah --color $argv
end

function lt
    command ls -lahtr --color $argv
end

function c
    command uvx diffweave-ai $argv
end

# PATH
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/node_modules/bin
fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin
fish_add_path /opt/google-cloud-sdk/bin

# Homebrew (macOS Apple Silicon)
if test -d /opt/homebrew
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/opt/rsync/bin
end

# Environment
set -x EDITOR (which nvim)
set -x SHELL (which fish)

# Tool hooks
type -q direnv; and direnv hook fish | source
type -q zoxide; and zoxide init fish | source
type -q uv; and uv generate-shell-completion fish | source
type -q uvx; and uvx --generate-shell-completion fish | source

# Google Cloud SDK
if test -f "$HOME/google-cloud-sdk/path.fish.inc"
    source "$HOME/google-cloud-sdk/path.fish.inc"
end

# Bun
if test -d "$HOME/.bun"
    set --export BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
end

# Machine-specific overrides live in ~/.config/fish/conf.d/

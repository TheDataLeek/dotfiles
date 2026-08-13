# Starship cross-shell prompt — https://starship.rs
#
# NOTE: conf.d/*.fish loads BEFORE config.fish (where brew paths are added to
# PATH via fish_add_path), so the starship binary may not yet be on PATH here.
# Make it reachable regardless of load order before initializing the prompt.
if not type -q starship
    for dir in /opt/homebrew/bin /usr/local/bin
        if test -x $dir/starship
            fish_add_path $dir
            break
        end
    end
end

type -q starship; and starship init fish | source

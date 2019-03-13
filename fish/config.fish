function ls
    command ls -lah --color $argv
end

function accio
    command pacaur -S $argv
end

set PATH ""
set PATH /opt/google-cloud-sdk/bin $PATH
set PATH /usr/local/sbin $PATH
set PATH /usr/local/bin $PATH
set PATH /usr/bin $PATH
set PATH /usr/bin/site_perl $PATH
set PATH /usr/bin/vendor_perl $PATH
set PATH /usr/bin/core_perl $PATH
set PATH /home/zoe/.local/bin $PATH
set PATH /home/zoe/bin $PATH
set PATH /home/zoe/node_modules/bin $PATH

set MYPYPATH ""
set MYPYPATH /home/zoe/.local/lib/python3.6/site-packages $MYPYPATH
set MYPYPATH /usr/lib/python3.6/site-packages $MYPYPATH

set PYTHONPATH ""
set PYTHONPATH /home/zoe/.local/lib/python3.6/site-packages $PYTHONPATH
set PYTHONPATH /usr/lib/python3.6/site-packages $PYTHONPATH

set -x EDITOR /usr/bin/nvim

set -x SHELL /usr/bin/fish
set -x PYENV_SHELL /usr/bin/fish

set -x npm_config_prefix /home/zoe/node_modules

# eval (pipenv --completion)

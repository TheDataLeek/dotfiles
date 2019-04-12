"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialize Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plugin 'VundleVim/Vundle.vim'         " Plugin management
Plugin 'vim-scripts/spellcheck.vim'   " Spellcheck
Plugin 'flazz/vim-colorschemes'       " Expanded colors
Plugin 'godlygeek/tabular'            " Formatting and Alignment
Plugin 'dhruvasagar/vim-table-mode'   " More alignment things
Plugin 'gerw/vim-latex-suite'         " Latex tools
Plugin 'Valloric/YouCompleteMe'       " Autocomplete
Plugin 'euclio/vim-markdown-composer' " Markdown support
Plugin 'itchyny/lightline.vim'        " Easy status line
Plugin 'tpope/vim-commentary'         " Easy commenting stuff out
Plugin 'hdima/python-syntax'          " Expanded Python syntax
Plugin 'majutsushi/tagbar'            " Quickly see file object structure
Plugin 'tpope/vim-vinegar'            " Easy file browsing
Plugin 'simnalamburt/vim-mundo'       " History
Plugin 'jalvesaq/Nvim-R'              " Sexy R environment
Plugin 'metakirby5/codi.vim'          " Interactive Scratchpad
" Plugin 'xolox/vim-misc'               " Misc autoload tools. Needed for easytags
" Plugin 'xolox/vim-easytags'           " Jump to definition
Plugin 'mileszs/ack.vim'              " Searching
Plugin 'jiangmiao/auto-pairs'         " Auto insert pairs
Plugin 'kien/rainbow_parentheses.vim' " Rainbow Parentheses
Plugin 'junegunn/goyo.vim'            " Remove EVERYTHING
Plugin 'Yggdroot/indentLine'          " Pretty indent lines
Plugin 'tpope/vim-dadbod'             " Database Connection
Plugin 'b4b4r07/vim-sqlfmt'           " SQL Formatting

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Finalize Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call vundle#end()
filetype plugin on
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Generic Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set Leader Key
let mapleader = ","

" Line Numbering
" We want relative line numbering with static for the current line
set relativenumber
set number

" Textwidth
set tw=120

" Set Spelling
set spell

" Don't wrap text
set nowrap

" Space at beginning and end
" https://www.reddit.com/r/vim/comments/4v07o7/is_there_a_way_to_scroll_intelligently_beyond/
set scrolloff=2

" Set keytimeout
" http://www.johnhawthorn.com/2012/09/vi-escape-delays/
" potentially important for tmux
set timeoutlen=1000 ttimeoutlen=0

" Set C-d and C-u to move up and down one line at a time
" http://vimdoc.sourceforge.net/htmldoc/scroll.html
set scroll=1

" Set width of fold column
" http://vimdoc.sourceforge.net/htmldoc/fold.html
set foldcolumn=1

" Highlight current line
set cursorline

" Prevent python comment unindent
" http://stackoverflow.com/questions/2360249/vim-automatically-removes-indentation-on-python-comments
:inoremap # X<BS>#

" Bind semicolon to colon (speed matters)
nmap ; :

" Align equals signs
vmap t :Tabularize /=<Enter>

" Set characters for tabs and trailing whitespace
set list listchars=tab:▸\ ,trail:⋅,nbsp:⋅

" <F1> Shortcut
nmap <leader>1 <F1>

" Copy current file to windows downloads
nmap <leader>c :w<Enter>:!cp % /mnt/c/Users/zfarmer/Downloads/<Enter><Enter>

" Copy current file clipboard
nmap <leader>y :%y+<Enter>

" Searching Smart Cases
set infercase
set hlsearch
set incsearch

" Allow saving of files as sudo when I forgot to start vim using sudo.
" https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! w !sudo tee > /dev/null %

"""""""""""""""""""""""""""""""""""""""""
" Commentary.vim Plugin
"""""""""""""""""""""""""""""""""""""""""
vmap q gc
vmap <C-_> gc
nmap <C-_> gcc

"""""""""""""""""""""""""""""""""""""""""
" Shell commands from vim
" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
"""""""""""""""""""""""""""""""""""""""""
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  execute "NeomakeSh ".expanded_cmdline
  execute "copen"
  normal <C-w>L
  1
endfunction

"""""""""""""""""""""""""""""""""""""""""
" Terminal Config
" https://neovim.io/doc/user/nvim_terminal_emulator.html
"""""""""""""""""""""""""""""""""""""""""
tnoremap <leader><leader> <C-\><C-n>

"""""""""""""""""""""""""""""""""""""""""
" Coloring Config
"""""""""""""""""""""""""""""""""""""""""
" Turn on syntax coloring
syntax on

" Use this colorscheme
colorscheme jellybeans

" Folded section color
hi Folded ctermfg=darkblue ctermbg=gray     " Fold colors
hi FoldColumn ctermfg=darkblue ctermbg=None " Foldcolumn colors

" Setup normal coloring for everything (we want it to be clear)
hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=None

" Colouring for trailing chars
hi SpecialKey guibg=NONE ctermbg=NONE

" Colouring for line numbers
" Transparent left gutter
hi LineNr guibg=NONE ctermbg=NONE
" Coloured left gutter

"""""""""""""""""""""""""""""""""""""""""
" Syntax Highlighting
"""""""""""""""""""""""""""""""""""""""""
let python_highlight_all = 1

"""""""""""""""""""""""""""""""""""""""""
" Arrow Keys
"""""""""""""""""""""""""""""""""""""""""
nmap <Left> 10<C-w><
nmap <Right> 10<C-w>>
vmap <Left> <gv
vmap <Right> >gv
noremap <Up> 10<C-w>+
noremap <Down> 10<C-w>-

"""""""""""""""""""""""""""""""""""""""""
" Copy-Paste
"""""""""""""""""""""""""""""""""""""""""
vmap <C-c> "+y
nmap <C-c> "+p

"""""""""""""""""""""""""""""""""""""""""
" Splits
"""""""""""""""""""""""""""""""""""""""""
noremap H <C-w>h
noremap L <C-w>l
noremap J <C-w>j
noremap K <C-w>k

"""""""""""""""""""""""""""""""""""""""""
" Vim Folding
"""""""""""""""""""""""""""""""""""""""""
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
noremap <Space> za

"""""""""""""""""""""""""""""""""""""""""
" Smart tabbing and cases
"""""""""""""""""""""""""""""""""""""""""
set smartindent
set smartcase  " capital letters = case sensitive
set tabstop=4
set shiftwidth=4
set expandtab

" Javascript
autocmd Filetype markdown setlocal tabstop=2

"""""""""""""""""""""""""""""""""""""""""
" Word Swap
" http://stackoverflow.com/questions/3578549/easiest-way-to-swap-occurrences-of-two-strings-in-vim
"""""""""""""""""""""""""""""""""""""""""
function! Mirror(dict)
    for [key, value] in items(a:dict)
        let a:dict[value] = key
    endfor
    return a:dict
endfunction

function! S(number)
    return submatch(a:number)
endfunction

function! SwapWords(dict, ...)
    let words = keys(a:dict) + values(a:dict)
    let words = map(words, 'escape(v:val, "|")')
    if(a:0 == 1)
        let delimiter = a:1
    else
        let delimiter = '/'
    endif
    let pattern = '\v(' . join(words, '|') . ')'
    exe '%s' . delimiter . pattern . delimiter
        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
        \ . delimiter . 'g'
endfunction

""""""""""""""""""""""""""""""""""""'
" Searching
" https://www.reddit.com/r/vim/comments/79hi4q/vim_801238_adds_highlighting_of_all_matches_while/
""""""""""""""""""""""""""""""""""""'
set hlsearch

""""""""""""""""""""""""""""""""""""'
" Lightline
""""""""""""""""""""""""""""""""""""'
let g:lightline = {
\  'colorscheme': 'jellybeans',
\  'active': {
\    'left': [['mode', 'paste'],
\             ['filename', 'relativepath', 'modified']],
\    'right': [['lineinfo'],
\              ['percent'],
\              ['fileformat', 'fileencoding', 'filetype']]
\  }
\ }

" https://github.com/itchyny/lightline.vim/issues/87
function! LLFileName()
    return expand('%:p:h')
endfunction

""""""""""""""""""""""""""""""""""""'
" Gundo/Mundo
""""""""""""""""""""""""""""""""""""'
nnoremap <F5> :MundoToggle<CR>

set undofile
set undodir=~/.config/nvim/undo

""""""""""""""""""""""""""""""""""""'
" Terminal Configuration
""""""""""""""""""""""""""""""""""""'
" https://www.reddit.com/r/neovim/comments/32944o/disable_spell_check_in_neovim_terminal/
augroup terminal
  autocmd TermOpen * setlocal nospell
augroup END

""""""""""""""""""""""""""""""""""""'
" Tagbar - https://github.com/majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>
""""""""""""""""""""""""""""""""""""'

""""""""""""""""""""""""""""""""""""'
" Easytags
""""""""""""""""""""""""""""""""""""'
let g:easytags_async=1  " Async eval
let g:easytags_by_filetype='~/.config/nvim/tags'  " tags by ft

""""""""""""""""""""""""""""""""""""'
" Searching...
""""""""""""""""""""""""""""""""""""'
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

nmap <leader><Space> :Ack 
nmap <leader>t :Ack todo<cr>

""""""""""""""""""""""""""""""""""""'
" Rainbow Parentheses
""""""""""""""""""""""""""""""""""""'
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 14

""""""""""""""""""""""""""""""""""""'
" Vim LaTeX
""""""""""""""""""""""""""""""""""""'
let g:tex_flavor='latex'

""""""""""""""""""""""""""""""""""""'
" Indent Lines
" for colouring use https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
""""""""""""""""""""""""""""""""""""'
let g:indentLine_enabled = 1
" let g:indentLine_char = '|'
let g:indentLine_color_term = 237
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

""""""""""""""""""""""""""""""""""""'
" SQL Formatting
""""""""""""""""""""""""""""""""""""'
let g:sqlfmt_command = "sqlformat"
let g:sqlfmt_options = ""

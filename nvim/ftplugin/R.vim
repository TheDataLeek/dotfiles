""""""""""""""""""""""""""""""""""""'
" NeoVim R
""""""""""""""""""""""""""""""""""""'
if has("gui_running")
    inoremap <C-Space> <C-x><C-o>
else
    inoremap <Nul> <C-x><C-o>
endif
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine

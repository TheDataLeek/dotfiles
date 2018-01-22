""""""""""""""""""""""""""""""""""""'
" NeoVim IPython
""""""""""""""""""""""""""""""""""""'
let g:nvim_ipy_perform_mappings = 0
function Py()
    exec "IPython"
    vmap <Space> <Plug>(IPy-Run)
    nmap <Space> <Plug>(IPy-Run)j
    wincmd H
endfunction
nmap <F7> :call Py()<cr>
nmap <F31> <Plug>(IPy-Interrupt)


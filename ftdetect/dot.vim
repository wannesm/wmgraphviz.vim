fun! s:DetectGraphviz()
    if getline(1) == 'digraph'
        set filetype=dot
    endif
endfun

au BufRead,BufNewFile *.gv,*.dot set filetype=dot
au BufRead,BufNewFile * call s:DetectGraphviz()


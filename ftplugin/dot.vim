" wmgraphviz.vim plugin
" Author: Wannes Meert
" Email: wannesm@gmail.com

if exists('s:loaded')
	finish
endif
let s:loaded = 1


fu! GraphvizCompile()
	let cmd = '!dot -O -Tpdf ' . expand('%:p')
	exec cmd
endfu

fu! GraphvizShow()
	exec '!open ' . expand('%:p') . '.pdf'
endfu

com! -nargs=0 GraphvizCompile :call GraphvizCompile()
com! -nargs=0 GraphvizShow :silent call GraphvizShow()

" Mappings
nmap <buffer> <LocalLeader>ll :GraphvizCompile<CR>
nmap <buffer> <LocalLeader>lv :GraphvizShow<CR>


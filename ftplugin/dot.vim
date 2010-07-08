" wmgraphviz.vim plugin
" Author: Wannes Meert
" Email: wannesm@gmail.com

if exists('s:loaded')
	finish
endif
let s:loaded = 1


fu! GraphvizCompile
	let cmd = '!dot -O -Tpdf ' . expand('%:p')
	exec cmd
endfu

com! -nargs=0 GraphvizCompile :silent call GraphvizCompile


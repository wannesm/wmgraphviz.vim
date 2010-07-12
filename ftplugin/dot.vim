" wmgraphviz.vim plugin
" Author: Wannes Meert
" Email: wannesm@gmail.com
" Version: 1.0

if exists('s:loaded')
	finish
endif
let s:loaded = 1

" Settings

if !exists('g:WMGraphviz_dot')
	let g:WMGraphviz_dot = 'dot'
endif

if !exists('g:WMGraphviz_output')
	let g:WMGraphviz_output = 'pdf'
endif

if !exists('g:WMGraphviz_viewer')
	if has('mac')
		let g:WMGraphviz_viewer = 'open'
	elseif has ('unix')
		if g:WMGraphviz_output == 'pdf'
			let g:WMGraphviz_viewer = 'acroread'
		elseif g:WMGraphviz_output == 'ps'
			let g:WMGraphviz_viewer = 'gv'
		else
			let g:WMGraphviz_viewer = 'acroread'
		endif
	else
		let g:WMGraphviz_viewer = 'open'
	endif
endif

if !exists('g:WMGraphviz_shelloptions')
	let g:WMGraphviz_shelloptions = ''
endif

" Compilation
fu! GraphvizCompile()
	let s:logfile = expand('%:p:r') . '.log'
	let cmd = 'silent !(' . g:WMGraphviz_dot . ' -o' . expand('%:p:r') . '.' . g:WMGraphviz_output . ' -T' . g:WMGraphviz_output . ' ' . g:WMGraphviz_shelloptions . ' ' . expand('%:p') . ' 2>&1) | tee ' . expand('%:p:r') . '.log'
	exec cmd
	exec 'cfile ' . s:logfile
endfu

" Viewing
fu! GraphvizShow()
	if !filereadable(expand('%:p') . '.pdf')
		call GraphvizCompile()
	endif
	exec '!' . g:WMGraphviz_viewer . ' ' . expand('%:p:r') . '.pdf'
endfu

com! -nargs=0 GraphvizCompile :call GraphvizCompile()
com! -nargs=0 GraphvizShow :silent call GraphvizShow()

" Mappings
nmap <buffer> <LocalLeader>ll :GraphvizCompile<CR>
nmap <buffer> <LocalLeader>lv :GraphvizShow<CR>

" Completion
setlocal omnifunc=GraphvizComplete
let s:completion_type = ''

" Dictionaries

let s:attrs = [
\	{'word': 'arrowhead=',     'menu': 'Style of arrowhead at head end [E]'},
\	{'word': 'arrowsize=',     'menu': 'Scaling factor for arrowheads [E]'},
\	{'word': 'arrowtail=',     'menu': 'Style of arrowhead at tail end [E]'},
\	{'word': 'bgcolor=',       'menu': 'Background color [G]'},
\	{'word': 'color=',         'menu': 'Node shape/edge/cluster color [E,G,N]'},
\	{'word': 'comment=',       'menu': 'Any string [E,G,N]'},
\	{'word': 'compound=',      'menu': 'Allow edges between clusters [G]'},
\	{'word': 'concentrate=',   'menu': 'Enables edge concentrators [G]'},
\	{'word': 'constraints=',   'menu': 'Use edge to affect node ranking [E]'},
\	{'word': 'decorate=',      'menu': 'If set, line between label and edge [E]'},
\	{'word': 'dir=',           'menu': 'Direction of edge [E]'},
\	{'word': 'distortion=',    'menu': 'Node distortion [N]'},
\	{'word': 'fillcolor=',     'menu': 'Node/cluster fill color [G,N]'},
\	{'word': 'fixedsize=',     'menu': 'Label text has no effect on node size [N]'},
\	{'word': 'fontcolor=',     'menu': 'Font face color [E,G,N]'},
\	{'word': 'fontname=',      'menu': 'Font family [E,G,N]'},
\	{'word': 'fontsize=',      'menu': 'Point size of label [E,G,N]'},
\	{'word': 'group=',         'menu': 'Name of node group [N]'},
\	{'word': 'headlabel=',     'menu': 'Label placed near head of edge [E]'},
\	{'word': 'headport=',      'menu': 'Location of label [E]'},
\	{'word': 'height=',        'menu': 'Height in inches [N]'},
\	{'word': 'label=',         'menu': 'Any string [E,N]'},
\	{'word': 'labelangle=',    'menu': 'Ange in degrees [E]'},
\	{'word': 'labeldistance=', 'menu': 'Scaling factor for distance for head or tail label [E]'},
\	{'word': 'labelfontcolor=','menu': 'Type face color for head and tail labels [E]'},
\	{'word': 'labelfontname=', 'menu': 'Font family for head and tail labels [E]'},
\	{'word': 'labelfontsize=', 'menu': 'Point size for head and tail labels [E]'},
\	{'word': 'labeljust=',     'menu': 'Label justficiation [G]'},
\	{'word': 'labelloc=',      'menu': 'Label vertical justficiation [G]'},
\	{'word': 'layer=',         'menu': 'Overlay range [E,N]'},
\	{'word': 'lhead=',         'menu': '[E]'},
\	{'word': 'ltail=',         'menu': '[E]'},
\	{'word': 'minlen=',        'menu': '[E]'},
\	{'word': 'nodesep=',       'menu': 'Separation between nodes, in inches [G]'},
\	{'word': 'orientation=',   'menu': 'Node rotation angle [N]'},
\	{'word': 'peripheries=',   'menu': 'Number of node boundaries [N]'},
\	{'word': 'rank=',          'menu': '[G]'},
\	{'word': 'rankdir=',       'menu': '[G]'},
\	{'word': 'ranksep=',       'menu': 'Separation between ranks, in inches [G]'},
\	{'word': 'ratio=',         'menu': 'Aspect ratio [G]'},
\	{'word': 'regular=',       'menu': 'Force polygon to be regular [N]'},
\	{'word': 'rotate=',        'menu': 'If 90, set orientation to landscape [G]'},
\	{'word': 'samehead=',      'menu': '[E]'},
\	{'word': 'sametail=',      'menu': '[E]'},
\	{'word': 'shape=',         'menu': 'Node shape [N]'},
\	{'word': 'shapefile=',     'menu': 'External custom shape file [N]'},
\	{'word': 'sides=',         'menu': 'Number of sides for shape=polygon [N]'},
\	{'word': 'skew=',          'menu': 'Skewing node for for shape=polygon [N]'},
\	{'word': 'style=',         'menu': 'Graphics options [E,N]'},
\	{'word': 'taillabel=',     'menu': 'Label placed near tail of edge [E]'},
\	{'word': 'tailport=',      'menu': '[E]'},
\	{'word': 'weight=',        'menu': 'Integer cost of stretching an edge [E]'},
\	{'word': 'width=',         'menu': 'width in inches [N]'}
\	]

let s:shapes = [
\	{'word': 'box'},
\	{'word': 'circle'},
\	{'word': 'diamond'},
\	{'word': 'doublecircle'},
\	{'word': 'doubleoctagon'},
\	{'word': 'egg'},
\	{'word': 'ellipse'},
\	{'word': 'hexagon'},
\	{'word': 'house'},
\	{'word': 'invhouse'},
\	{'word': 'invtrapezium'},
\	{'word': 'invtriangle'},
\	{'word': 'octagon'},
\	{'word': 'plaintext'},
\	{'word': 'parallelogram'},
\	{'word': 'point'},
\	{'word': 'polygon'},
\	{'word': 'record'},
\	{'word': 'traingle'},
\	{'word': 'trapezium'},
\	{'word': 'tripleoctagon'},
\	{'word': 'Mcircle'},
\	{'word': 'Mdiamon'},
\	{'word': 'Mrecord'},
\	{'word': 'Msquare'}
\	]

let s:arrowheads =  [
\	{'word': 'normal'},
\	{'word': 'dot'},
\	{'word': 'odot'},
\	{'word': 'inv'},
\	{'word': 'invdot'},
\	{'word': 'invodot'},
\	{'word': 'none'}
\	]

" More colornames are available but make the menu too long.
let s:colors =  [
\	{'word': '#000000'},
\	{'word': '0.0 0.0 0.0'},
\	{'word': 'beige'},
\	{'word': 'black'},
\	{'word': 'blue'},
\	{'word': 'brown'},
\	{'word': 'cyan'},
\	{'word': 'gray'},
\	{'word': 'gray[0-100]'},
\	{'word': 'green'},
\	{'word': 'magenta'},
\	{'word': 'orange'},
\	{'word': 'orchid'},
\	{'word': 'red'},
\	{'word': 'violet'},
\	{'word': 'white'},
\	{'word': 'yellow'}
\	]

let s:fonts =  [
\	{'abbr': 'Courier'          , 'word': '"Courier"'},
\	{'abbr': 'Courier-Bold'     , 'word': '"Courier-Bold"'},
\	{'abbr': 'Courier-Oblique'  , 'word': '"Courier-Oblique"'},
\	{'abbr': 'Helvetica'        , 'word': '"Helvetica"'},
\	{'abbr': 'Helvetica-Bold'   , 'word': '"Helvetica-Bold"'},
\	{'abbr': 'Helvetica-Narrow' , 'word': '"Helvetica-Narrow"'},
\	{'abbr': 'Helvetica-Oblique', 'word': '"Helvetica-Oblique"'},
\	{'abbr': 'Symbol'           , 'word': '"Symbol"'},
\	{'abbr': 'Times-Bold'       , 'word': '"Times-Bold"'},
\	{'abbr': 'Times-BoldItalic' , 'word': '"Times-BoldItalic"'},
\	{'abbr': 'Times-Italic'     , 'word': '"Times-Italic"'},
\	{'abbr': 'Times-Roman'      , 'word': '"Times-Roman"'}
\	]

let s:style =  [
\	{'word': 'bold'},
\	{'word': 'dotted'},
\	{'word': 'filled'}
\	]

let s:dir =  [
\	{'word': 'forward'},
\	{'word': 'back'},
\	{'word': 'both'},
\	{'word': 'none'}
\	]

let s:port =  [
\	{'word': 'n'},
\	{'word': 'ne'},
\	{'word': 'e'},
\	{'word': 'se'},
\	{'word': 's'},
\	{'word': 'sw'},
\	{'word': 'w'},
\	{'word': 'nw'}
\	]

let s:rank =  [
\	{'word': 'same'},
\	{'word': 'min'},
\	{'word': 'max'},
\	{'word': 'source'},
\	{'word': 'sink'}
\	]

let s:rankdir =  [
\	{'word': 'TB'},
\	{'word': 'LR'}
\	]

let s:just =  [
\	{'word': 'centered'},
\	{'word': 'l'},
\	{'word': 'r'}
\	]

let s:loc =  [
\	{'word': 'top'},
\	{'word': 'b'}
\	]

let s:boolean =  [
\	{'word': 'true'},
\	{'word': 'false'}
\	]

fu! GraphvizComplete(findstart, base)
	"echomsg 'findstart=' . a:findstart . ', base=' . a:base
	if a:findstart
		" return the starting point of the word
		let line = getline('.')
		let pos = col('.') - 1
		while pos > 0 && line[pos - 1] !~ '=\|,\|\['
			let pos -= 1
		endwhile

		if line[pos - 1] == '='
			" label=...?
			let labelpos = pos - 1
			while labelpos > 0 && line[labelpos - 1] =~ '[a-z]'
				let labelpos -= 1
			endwhile
			let labelstr=strpart(line, labelpos, pos - 1 - labelpos)

			if labelstr == 'shape'
				let s:completion_type = 'shape'
			elseif labelstr =~ 'fontname'
				let s:completion_type = 'font'
			elseif labelstr =~ 'color'
				let s:completion_type = 'color'
			elseif labelstr == 'arrowhead'
				let s:completion_type = 'arrowhead'
			elseif labelstr == 'rank'
				let s:completion_type = 'rank'
			elseif labelstr == 'port'
				let s:completion_type = 'port'
			elseif labelstr == 'rankdir'
				let s:completion_type = 'rankdir'
			elseif labelstr == 'style'
				let s:completion_type = 'style'
			elseif labelstr == 'labeljust'
				let s:completion_type = 'just'
			elseif labelstr == 'fixedsize' || labelstr == 'regular' || labelstr == 'constraint' || labelstr == 'labelfloat' || labelstr == 'center' || labelstr == 'compound' || labelstr == 'concentrate'
				let s:completion_type = 'boolean'
			elseif labelstr == 'labelloc'
				let s:completion_type = 'loc'
			else
				let s:completion_type = ''
			endif
		elseif line[pos - 1] =~ ',\|\['
			" attr
			let attrstr=line[0:pos - 1]
			" skip spaces
			while line[pos] =~ '\s'
				let pos += 1
			endwhile

			if attrstr =~ '^\s*node'
				let s:completion_type = 'attrnode'
			elseif attrstr =~ '^\s*edge'
				let s:completion_type = 'attredge'
			elseif attrstr =~ '\( -> \)\|\( -- \)'
				let s:completion_type = 'attredge'
			elseif attrstr =~ '^\s*graph'
				let s:completion_type = 'attrgraph'
			else
				let s:completion_type = 'attrnode'
			endif
		else
			let s:completion_type = ''
		endif

		return pos
	else
		" return suggestions in an array
		let suggestions = []

		if s:completion_type == 'shape'
			for entry in s:shapes
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'arrowhead'
			for entry in s:arrowheads
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'boolean'
			for entry in s:boolean
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'font'
			for entry in s:fonts
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'color'
			for entry in s:colors
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rank'
			for entry in s:rank
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rankdir'
			for entry in s:rankdir
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'style'
			for entry in s:style
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'port'
			for entry in s:port
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'just'
			for entry in s:just
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'loc'
			for entry in s:loc
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attr'
			for entry in s:attrs
				if entry.word =~ '^' . escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrnode'
			for entry in s:attrs
				if entry.word =~ '^' . escape(a:base, '/') && entry.menu =~ '\[.*N.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attredge'
			for entry in s:attrs
				if entry.word =~ '^' . escape(a:base, '/') && entry.menu =~ '\[.*E.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrgraph'
			for entry in s:attrs
				if entry.word =~ '^' . escape(a:base, '/') && entry.menu =~ '\[.*G.*\]'
					call add(suggestions, entry)
				endif
			endfor
		endif
		if !has('gui_running')
			redraw!
		endif
		return suggestions
	endif
endfu

" Quickfix list

setlocal errorformat=%EError:\ %f:%l:%m,%+Ccontext:\ %.%#,%WWarning:\ %m



" wmgraphviz.vim plugin
" Author: Wannes Meert
" Email: wannesm@gmail.com
" Version: 1.0.3

if exists('b:wmgraphviz_dot_loaded')
	finish
endif
let b:wmgraphviz_dot_loaded = 1

" Settings

if !exists('g:WMGraphviz_dot')
	let g:WMGraphviz_dot = 'dot'
endif

if !exists('g:WMGraphviz_neato')
	let g:WMGraphviz_neato = 'neato'
endif

if !exists('g:WMGraphviz_fdp')
	let g:WMGraphviz_fdp = 'fdp'
endif

if !exists('g:WMGraphviz_sfdp')
	let g:WMGraphviz_sfdp = 'sfdp'
endif

if !exists('g:WMGraphviz_twopi')
	let g:WMGraphviz_twopi = 'twopi'
endif

if !exists('g:WMGraphviz_circo')
	let g:WMGraphviz_circo = 'circo'
endif

if !exists('g:WMGraphviz_output')
	let g:WMGraphviz_output = 'pdf'
endif

if !exists('g:WMGraphviz_viewer')
	if has('mac')
		let g:WMGraphviz_viewer = 'open'
	elseif has ('unix')
		if executable('xdg-open')
			let g:WMGraphviz_viewer = 'xdg-open'
		else
			if g:WMGraphviz_output == 'ps'
				let g:WMGraphviz_viewer = 'gv'
			else
				let g:WMGraphviz_viewer = 'acroread'
			endif
		endif
	elseif has('win32')
		let g:WMGraphviz_viewer = ' start'
	else
		let g:WMGraphviz_viewer = 'open'
	endif
endif

if !exists('g:WMGraphviz_shelloptions')
	let g:WMGraphviz_shelloptions = ''
endif

if !exists('g:WMGraphviz_dot2tex')
	let g:WMGraphviz_dot2tex = 'dot2tex'
endif

if !exists('g:WMGraphviz_dot2texoptions')
	let g:WMGraphviz_dot2texoptions = '-tmath'
endif

if !exists('g:WMGraphviz_tool')
    let g:WMGraphviz_tool = 'dot'
endif

fu! GraphvizOutputFile(output)
	return expand('%:p:r') . '.' . a:output
endfu

fu! GraphvizLogFile()
	return tempname().'.log'
endfu

" Compilation
" If argument given, use it as output
fu! GraphvizCompile(tool, output)
	if !executable(a:tool)
		echoerr 'The "'.a:tool.'" executable was not found.'
		return
	endif

	if has('win32')
	    exe 'set makeprg='.a:tool.'\ -T'.a:output.'\ '.substitute(g:WMGraphviz_shelloptions, ' ', '\\ ', 'g').'\ %\ -o\ %:p:.:r.'.a:output
	    exec 'make'
	else
	    let s:logfile = GraphvizLogFile()
	    let cmd = '!('.a:tool.' -T'.a:output.' '.g:WMGraphviz_shelloptions.' '.shellescape(expand('%:p')).' -o '.shellescape(GraphvizOutputFile(a:output)).' &> '.shellescape(s:logfile) . ')'
	    silent! exec cmd
	    silent! exec 'cfile '.escape(s:logfile, ' \"!?''')

        if len(getqflist()) > 0
            copen
        else
            cclose
        endif

        call delete(s:logfile)
	endif
endfu

fu! GraphvizCompileToLaTeX(...)
	if !executable(g:WMGraphviz_dot2tex)
		echoerr 'The "'.g:WMGraphviz_dot2tex.'" executable was not found.'
		return
	endif

	if has('win32')
	    let cmd = '!('.g:WMGraphviz_tool.' -Txdot '.g:WMGraphviz_shelloptions.' % | '.g:WMGraphviz_dot2tex.' '.g:WMGraphviz_dot2texoptions.' > %:p:.:r.tex)'
	    exec cmd
	else
	    let s:logfile = GraphvizLogFile()
	    let cmd = '!(('.g:WMGraphviz_dot2tex.' '.g:WMGraphviz_dot2texoptions.' '.shellescape(expand('%:p')).' > '.shellescape(GraphvizOutputFile("tex")).') 2>&1) | tee '.shellescape(s:logfile)
	    silent exec cmd
	    exec 'cfile '.escape(s:logfile, ' \"!?''')
	    call delete(s:logfile)
	endif
endfu

" Viewing
fu! GraphvizShow()
	if !filereadable(GraphvizOutputFile(g:WMGraphviz_output))
		call GraphvizCompile(g:WMGraphviz_dot, g:WMGraphviz_output)
	endif

	if !has('win32')
	    if !executable(g:WMGraphviz_viewer)
		echoerr 'Viewer program not found: "'.g:WMGraphviz_viewer.'"'
		return
	    endif

	    silent exec '!'.g:WMGraphviz_viewer.' '.shellescape(GraphvizOutputFile(g:WMGraphviz_output)).' &'
	else
	    exec '!'.g:WMGraphviz_viewer.' /b %:p:.:r.'.g:WMGraphviz_output
	endif

endfu

" Interactive viewing. "dot -Txlib <file.gv>" uses inotify to immediately
" redraw image when the input file is changed.
fu! GraphvizInteractive()
	if !executable(g:WMGraphviz_dot)
		echoerr 'The "'.g:WMGraphviz_dot.'" executable was not found.'
		return
	endif

	silent exec '!'.g:WMGraphviz_dot.' -Txlib '.shellescape(expand('%:p')).' &'
endfu

" Available functions
com! -nargs=0 GraphvizCompile :call GraphvizCompile(g:WMGraphviz_tool, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompilePS :call GraphvizCompile(g:WMGraphviz_dot, 'ps')
com! -nargs=0 GraphvizCompilePDF :call GraphvizCompile(g:WMGraphviz_dot, 'pdf')

com! -nargs=0 GraphvizCompileDot :call GraphvizCompile(g:WMGraphviz_dot, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompileNeato :call GraphvizCompile(g:WMGraphviz_neato, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompileCirco :call GraphvizCompile(g:WMGraphviz_circo, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompileFdp :call GraphvizCompile(g:WMGraphviz_fdp, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompileSfdp :call GraphvizCompile(g:WMGraphviz_sfdp, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompileTwopi :call GraphvizCompile(g:WMGraphviz_twopi, g:WMGraphviz_output)
com! -nargs=0 GraphvizCompileToLaTeX :call GraphvizCompileToLaTeX()

com! -nargs=0 GraphvizShow : call GraphvizShow()
com! -nargs=0 GraphvizInteractive : call GraphvizInteractive()

" Mappings
nnoremap <silent> <buffer> <LocalLeader>ll :GraphvizCompile<CR>
nnoremap <silent> <buffer> <LocalLeader>lt :GraphvizCompileToLaTeX<CR>
nnoremap <silent> <buffer> <LocalLeader>lv :GraphvizShow<CR>
nnoremap <silent> <buffer> <LocalLeader>li :GraphvizInteractive<CR>

" Completion
let s:completion_type = ''

" Completion dictionaries

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
\	{'word': 'headport=',      'menu': 'Where on the node to attach head of edge [E]'},
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
\	{'word': 'tailport=',      'menu': 'Where on the node to attach tail of edge [E]'},
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
\	{'word': 'trapezium'},
\	{'word': 'triangle'},
\	{'word': 'tripleoctagon'},
\	{'word': 'Mcircle'},
\	{'word': 'Mdiamond'},
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
\	{'word': 'diagonals', 'menu': '[N]'},
\	{'word': 'filled',    'menu': '[N]'},
\	{'word': 'rounded',   'menu': '[N]'},
\	{'word': 'striped',   'menu': '[N]'},
\	{'word': 'wedged',    'menu': '[N]'},
\	{'word': 'tapered',   'menu': '[E]'},
\	{'word': 'bold',      'menu': '[E,N]'},
\	{'word': 'dashed',    'menu': '[E,N]'},
\	{'word': 'dotted',    'menu': '[E,N]'},
\	{'word': 'invis',     'menu': '[E,N]'},
\	{'word': 'solid',     'menu': '[E,N]'}
\	]

let s:dir =  [
\	{'word': 'forward'},
\	{'word': 'back'},
\	{'word': 'both'},
\	{'word': 'none'}
\	]

let s:port =  [
\	{'word': '_',   'menu': 'appropriate side or center (default)' },
\	{'word': 'c',   'menu': 'center'},
\	{'word': 'e'},
\	{'word': 'n'},
\	{'word': 'ne'},
\	{'word': 'nw'},
\	{'word': 's'},
\	{'word': 'se'},
\	{'word': 'sw'},
\	{'word': 'w'},
\	]

let s:rank =  [
\	{'word': 'same'},
\	{'word': 'min'},
\	{'word': 'max'},
\	{'word': 'source'},
\	{'word': 'sink'}
\	]

let s:rankdir =  [
\	{'word': 'BT'},
\	{'word': 'LR'},
\	{'word': 'RL'},
\	{'word': 'TB'},
\	]

let s:just =  [
\	{'word': 'centered'},
\	{'word': 'l'},
\	{'word': 'r'}
\	]

let s:loc =  [
\	{'word': 'b', 'menu': 'bottom'},
\	{'word': 'c', 'menu': 'center'},
\	{'word': 't', 'menu': 'top'},
\	]

let s:boolean =  [
\	{'word': 'true'},
\	{'word': 'false'}
\	]

fu! GraphvizComplete(findstart, base)
	"echomsg 'findstart='.a:findstart.', base='.a:base
	if a:findstart
		" return the starting point of the word
		let line = getline('.')
		let pos = col('.') - 1
		while pos > 0 && line[pos - 1] !~ '=\|,\|\[\|\s'
			let pos -= 1
		endwhile
		let withspacepos = pos
		if line[withspacepos - 1] =~ '\s'
			while withspacepos > 0 && line[withspacepos - 1] !~ '=\|,\|\['
				let withspacepos -= 1
			endwhile
		endif

		if line[withspacepos - 1] == '='
			" label=...?
			let labelpos = withspacepos - 1
			" ignore spaces
			while labelpos > 0 && line[labelpos - 1] =~ '\s'
				let labelpos -= 1
				let withspacepos -= 1
			endwhile
			while labelpos > 0 && line[labelpos - 1] =~ '[a-z]'
				let labelpos -= 1
			endwhile
			let labelstr=strpart(line, labelpos, withspacepos - 1 - labelpos)

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
			elseif labelstr == 'headport' || labelstr == 'tailport'
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
		elseif line[withspacepos - 1] =~ ',\|\['
			" attr
			let attrstr=line[0:withspacepos - 1]
			" skip spaces
			while line[withspacepos] =~ '\s'
				let withspacepos += 1
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
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'arrowhead'
			for entry in s:arrowheads
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'boolean'
			for entry in s:boolean
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'font'
			for entry in s:fonts
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'color'
			for entry in s:colors
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rank'
			for entry in s:rank
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rankdir'
			for entry in s:rankdir
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'style'
			for entry in s:style
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'port'
			for entry in s:port
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'just'
			for entry in s:just
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'loc'
			for entry in s:loc
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attr'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrnode'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*N.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attredge'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*E.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrgraph'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*G.*\]'
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

setlocal omnifunc=GraphvizComplete

" Quickfix list

setlocal errorformat=%EError:\ %f:%l:%m,%+Ccontext:\ %.%#,%WWarning:\ %m

" Comments

set commentstring="// %s"



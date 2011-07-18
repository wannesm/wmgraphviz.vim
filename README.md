WM Graphviz
===========

Summary
-------
Vim plugin for [Graphviz](http://www.graphviz.org) `dot`.

Features
--------

* Compiling: `:GraphvizCompile`, `<Leader>ll`
* Viewing: `:GraphvizShow`, `<Leader>lv`
* Omnicompletion: `<C-X><C-O>`
* Quickfix window for errors and warnings
* Snipmate support

Settings
--------

* `g:WMGraphviz_dot` : default `"dot"`
* `g:WMGraphviz_output` : default `"pdf"`
* `g:WMGraphviz_viewer` : default `"open"` (Mac) or `"xdg-open"` (Unix)
* `g:WMGraphviz_shelloptions` : default `""`

Dependencies
------------

* [Graphiz](http://www.graphviz.org) `dot`.

Recommendations
---------------

This plugin combines nicely with:

* [Pathogen](http://www.vim.org/scripts/script.php?script_id=2332)
* [Snipmate](http://www.vim.org/scripts/script.php?script_id=2540)
* [Dot2TeX](http://www.fauskes.net/code/dot2tex/)

Contact
-------

Wannes Meert, wannesm@gmail.com


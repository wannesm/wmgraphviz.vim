# 
# Makefile
# For wmgraphviz.vim
#
# Create by Wannes Meert on 12/07/10.
#

.PHONY : dist

DISTFILES=doc/wmgraphviz.txt ftplugin/dot.vim snippets/dot.snippets
DIR=wmgraphviz.vim.git
DIST=wmgraphviz.vim

all:
	@echo No default action, you probably want to use \'dist\'.

dist:
	tar -czvf ${DIST}.tgz ${DISTFILES}

clean:
	rm -rf *.tgz


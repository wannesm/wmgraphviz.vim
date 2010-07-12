# 
# Makefile
# For wmgraphviz.vim
#
# Create by Wannes Meert on 12/07/10.
#

.PHONY : dist

DISTFILES=doc/wmgraphviz.txt ftplugin/dot.vim
DIR=wmgraphviz.vim.git
DIST=wmgraphviz.vim

all:
	@echo No default action, you probably want to use \'dist\'.

dist:
	echo ${DISTFILES} > MANIFEST;
	cat MANIFEST | tr ' ' '\n' | sed -e "s/^/${DIST}\//g" > MANIFEST;
	(cd ..; ln -s ${DIR} ${DIST});
	(cd ..; tar -czvf ${DIR}/${DIST}.tgz `cat ${DIR}/MANIFEST`);
	(cd ..; rm ${DIST});
	rm MANIFEST;



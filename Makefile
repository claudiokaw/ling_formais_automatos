all:
	rm -rf prj_exec prj_bison.tab.h prj_bison.tab.c lex.yy.c
	bison -d prj_bison.y
	flex -l prj_flex.lex
	gcc prj_bison.tab.c lex.yy.c -ll -o prj_exec
	./prj_exec
build: for.l for.y
	bison -Wcounterexamples -yvd for.y
	flex for.l
	gcc -g lex.yy.c y.tab.c
	./a.out main.cpp

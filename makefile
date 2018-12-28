all:
	bison -d calc.y
	flex --header-file=lex.h calc.l 
	g++ lex.yy.c calc.tab.c -o calc -std=c++11
	
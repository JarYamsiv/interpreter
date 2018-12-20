all:lex yacc
	gcc lex.yy.c y.tab.c -o calc

lex:
	flex calc.l

yacc:
	bison -d calc.y
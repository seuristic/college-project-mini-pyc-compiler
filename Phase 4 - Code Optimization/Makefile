a.out: y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -ll -w
lex.yy.c: python.l 
	lex python.l 
y.tab.c: python.y 
	yacc python.y -d
clean: 
	rm -rf a.out lex.yy.c y.tab.c y.tab.h

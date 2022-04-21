a.out: lex.yy.c
	gcc lex.yy.c -ll
lex.yy.c: python.l 
	lex python.l 
clean: 
	rm -rf a.out lex.yy.c 

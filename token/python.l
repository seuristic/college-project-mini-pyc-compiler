%{
#include <stdio.h> 
#include<stdlib.h>
#include "symbol.h" 

extern FILE *yyin;
extern FILE *yyout;
	
int lineno = 1; // initialize to 1
void ret_print(char* token_type);

%} 

%% 
\. { ret_print("DOT"); }
\n { lineno+=1;}
#.* {ret_print("single comment"); }
[ ] {}
\t {}
False { ret_print("FALSE"); }
None { ret_print("NONE");  }
True { ret_print("TRUE");  }
and { ret_print("LAND");  }
break { ret_print("BREAK");  }
continue { ret_print("CONTINUE");  }
elif { ret_print("ELIF"); }
del { ret_print("DEL");  }
else { ret_print("ELSE");  }
for { ret_print("FOR");  }
if { ret_print("IF");  }
in { ret_print("IN"); }
not { ret_print("NOT");  }
or { ret_print("LOR");  }
while { ret_print("WHILE");  }
input { ret_print("INPUT"); }
print { ret_print("PRINT");  }
int { ret_print("INT");  }
float { ret_print("FLOAT");  }
str { ret_print("STR");  }
list { ret_print("LIST");  }
split { ret_print("SPLIT");  }
map { ret_print("MAP"); }
append { ret_print("APPEND");  }
pop { ret_print("POP");  }
insert { ret_print("INSERT");  }
len { ret_print("LEN");  }
range { ret_print("RANGE"); }
[a-zA-Z_][a-zA-Z0-9_]* { ret_print("ID"); insert("ID",yytext,NULL,NULL,lineno);display();	
}
[0-9]* { ret_print("CINT");  }
[0-9]*\.[0-9]* { ret_print("CFLOAT");  }
; { ret_print("SEMI");  }
: { ret_print("COLON");  }
, { ret_print("COMMA");  }
\".*\" { ret_print("CSTR");  }
\*\* { ret_print("EPOP");  }
\* { ret_print("MUL"); }
\/ { ret_print("DIV"); }
\/\/ { ret_print("FDIV");}
\% { ret_print("MOD"); }
\+ { ret_print("ADD"); }
\- { ret_print("SUB");  }
= { ret_print("ASOP");  ;}
\<  { ret_print("L");  }
> { ret_print("G"); }
'>=' { ret_print("GE"); }
'<=' { ret_print("LE"); }
'==' { ret_print("EOP"); }
'!=' { ret_print("NEOP"); }
\^ { ret_print("XOR");  }
\& { ret_print("BAND");  }
\| { ret_print("BOR");}
\{ { ret_print("LBRACE");  }
\} { ret_print("RBRACE");  }
\( { ret_print("LPAREN"); }
\) { ret_print("RPAREN"); }
\[ { ret_print("LBRACKET"); }
\] { ret_print("RBRACKET"); }

%% 

int yywrap()  
{  
   return 1;
} 
void ret_print(char *token_type){
	
	printf("yytext: %s\ttoken: %s\tlineno: %d\n", yytext, token_type, lineno);
	///display();
}
int yyerror(){
	printf("Invalid Token Format");
	
}
int main()
{
	yylex();
}


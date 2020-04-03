%{
#include <stdio.h> 
#include<stdlib.h>
#include<ctype.h>
#include "y.tab.h"
#include "SymbolTable.h" 

extern FILE *yyin;
extern FILE *yyout;
int lineno = 1; // initialize to 1
void ret_print(char* token_type);

%} 
%% 
\. { ret_print("DOT");  strcpy(yylval.val,yytext);return DOT; }
\n { lineno+=1;}
#.* {}
[ ] {}
\t {}
False { ret_print("FALSE"); strcpy(yylval.val,"FALSE");return FALSE; }
None { ret_print("NONE");  strcpy(yylval.val,"NONE");return NONE; }
True { ret_print("TRUE");  strcpy(yylval.val,"TRUE");return TRUE; }
and { ret_print("LAND");  strcpy(yylval.val,yytext);return LAND; }
break { ret_print("BREAK");  strcpy(yylval.val,yytext);return BREAK; }
continue { ret_print("CONTINUE");  strcpy(yylval.val,yytext);return CONTINUE; }
elif { ret_print("ELIF");  strcpy(yylval.val,yytext);return ELIF;}
del { ret_print("DEL");   strcpy(yylval.val,yytext);return DEL;}
else { ret_print("ELSE");   strcpy(yylval.val,yytext);return ELSE;}
for { ret_print("FOR");   strcpy(yylval.val,yytext);return FOR;}
if { ret_print("IF");   strcpy(yylval.val,yytext);return IF;}
in { ret_print("IN");  strcpy(yylval.val,yytext);return IN;}
not { ret_print("NOT");   strcpy(yylval.val,yytext);return NOT;}
or { ret_print("LOR");  strcpy(yylval.val,yytext);return LOR; }
while { ret_print("WHILE");  strcpy(yylval.val,yytext);return WHILE; }
input { ret_print("INPUT");  strcpy(yylval.val,yytext);return INPUT;}
print { ret_print("PRINT");  strcpy(yylval.val,yytext);return PRINT; }
int { ret_print("INT");   strcpy(yylval.val,yytext);return INT;}
float { ret_print("FLOAT");   strcpy(yylval.val,yytext);return FLOAT;}
str { ret_print("STR");  strcpy(yylval.val,yytext);return STR; }
list { ret_print("LIST");   strcpy(yylval.val,yytext);return LIST;}
split { ret_print("SPLIT");  strcpy(yylval.val,yytext);return SPLIT; }
map { ret_print("MAP");  strcpy(yylval.val,yytext);return MAP;}
append { ret_print("APPEND");   strcpy(yylval.val,yytext);return APPEND;}
pop { ret_print("POP");   strcpy(yylval.val,yytext);return POP;}
insert { ret_print("INSERT");   strcpy(yylval.val,yytext);return INSERT;}
len { ret_print("LEN");   strcpy(yylval.val,yytext);return LEN;}
range { ret_print("RANGE");  strcpy(yylval.val,yytext);return RANGE;}
>= { ret_print("GE");  strcpy(yylval.val,yytext);return GE;}
\<= { ret_print("LE");  strcpy(yylval.val,yytext);return LE;}
== { ret_print("EOP");  strcpy(yylval.val,yytext);return EOP;}
\!= { ret_print("NEOP");  strcpy(yylval.val,yytext);return NEOP;}
; { ret_print("SEMI");  strcpy(yylval.val,yytext);return SEMI; }
: { ret_print("COLON");  strcpy(yylval.val,yytext);return COLON; }
, { ret_print("COMMA");  strcpy(yylval.val,yytext);return COMMA; }
(\".*\")|(\'.*\') { ret_print("CSTR"); strcpy(yylval.val,yytext);return CSTR;}
\*\* { ret_print("EPOP");  strcpy(yylval.val,yytext);return EPOP; }
\* { ret_print("MUL");  strcpy(yylval.val,yytext);return MUL;}
\/ { ret_print("DIV");  strcpy(yylval.val,yytext);return DIV;}
\/\/ { ret_print("FDIV");  strcpy(yylval.val,yytext);return FDIV;}
\% { ret_print("MOD");  strcpy(yylval.val,yytext);return MOD;}
\+ { ret_print("ADD");  strcpy(yylval.val,yytext);return ADD;}
\- { ret_print("SUB");   strcpy(yylval.val,yytext);return SUB;}
= { ret_print("ASOP");   strcpy(yylval.val,yytext);return ASOP;}
\<  { ret_print("L");   strcpy(yylval.val,yytext);return L;}
> { ret_print("G");  strcpy(yylval.val,yytext);return G;}
\^ { ret_print("XOR");   strcpy(yylval.val,yytext);return XOR;}
\& { ret_print("BAND");   strcpy(yylval.val,yytext);return BAND;}
\| { ret_print("BOR");  strcpy(yylval.val,yytext);return BOR;}
\{ { ret_print("LBRACE");  strcpy(yylval.val,yytext);return LBRACE; }
\} { ret_print("RBRACE");  strcpy(yylval.val,yytext);return RBRACE; }
\( { ret_print("LPAREN");  strcpy(yylval.val,yytext);return LPAREN;}
\) { ret_print("RPAREN");  strcpy(yylval.val,yytext);return RPAREN;}
\[ { ret_print("LBRACKET");  strcpy(yylval.val,yytext);return LBRACKET;}
\] { ret_print("RBRACKET");  strcpy(yylval.val,yytext);return RBRACKET;}
[a-zA-Z_][a-zA-Z0-9_]* { ret_print("ID"); insert("ID",yytext,NULL,NULL,lineno); yylval.ctype.type=-1;strcpy(yylval.ctype.value,yytext);return ID;}
[0-9]* { ret_print("CINT");strcpy(yylval.val,yytext); return CINT;}
[0-9]*\.[0-9]* { ret_print("CFLOAT");  strcpy(yylval.val,yytext);return CFLOAT; }
. {printf("Unknown Symbol %s at line no %d",yytext,lineno); }

%% 

int yywrap()  
{  
    strcpy(yylval.val,yytext);return 1;
} 
void ret_print(char *token_type)
{
	//printf("yytext: %s\ttoken: %s\tlineno: %d\n", yytext, token_type, lineno);
}

/*int main()
{
	yylex();
  printf("Symbol Table : \n");
  display();
}
*/

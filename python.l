%{
#include <stdio.h> 
#include "y.tab.h" 
%} 

%% 
\. return DOT;
\n+ ;
#.* ;
[ ] ;
\t+ ;
False return FALSE;
None return NONE;
True return TRUE;
and return LAND;
break return BREAK;
continue return CONTINUE;
elif return ELIF;
del return DEL;
else return ELSE;
for return FOR;
if return IF;
in return IN;
not return NOT;
or return LOR;
while return WHILE;
input return INPUT;
print return PRINT;
int return INT;
float return FLOAT;
str return STR;
list return LIST;
split return SPLIT;
map return MAP;
append return APPEND;
pop return POP;
insert return INSERT;
len return LEN;
range return RANGE;
[a-zA-Z_][a-zA-Z0-9_]* return ID;
[0-9]* return CINT;
[0-9]*\.[0-9]* return CFLOAT;
; return SEMI;
: return COLON;
, return COMMA;
\".*\" return CSTR;
\*\* return EPOP;
\* return MUL;
\/ return DIV;
\/\/ return FDIV;
\% return MOD;
\+ return ADD;
\- return SUB;
= return ASOP;
\<  return L;
> return G;
'>=' return GE;
'<=' return LE;
'==' return EOP;
'!=' return NEOP;
\^ return XOR;
\& return BAND;
\| return BOR;
\{ return LBRACE;
\} return RBRACE;
\( return LPAREN;
\) return RPAREN;
\[ return LBRACKET;
\] return RBRACKET;

%% 

int yywrap()  
{  
  return 1;  
} 



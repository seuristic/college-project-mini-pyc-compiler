%{
#include <stdio.h> 
#include<stdlib.h>

#define ID "ID"
#define LITERAL "LITERAL"
#define KEYWORD "KEYWORD"
#define SYMBOL "SYMBOL"
#define OPERATOR "OPERATOR"
#define SEPERATOR "SEPERATOR"

// initialize to 1
int lineNo = 1;

void printToken(char* type, char* token) {
    printf("%-17s%-16s%d\n", type, token, lineNo);
}

void printError(int flag) {
    if (!flag) printf("\n❌ WRONG identifier at line no. %d\n\n", lineNo);
    else printf("❔ UNDEFINED symbol at line no. %d\n\n", lineNo);
}

%} 

%% 
\. {}
\n { lineNo += 1; }
#.* {}
[ ] {}
\t {}
False |
None |
True { printToken(LITERAL, yytext); }
and |
break |
continue |
elif |
del |
else |
for |
if |
in |
not |
or |
while |
input  |
print |
int |
float |
str |
list |
split |
map |
append |
pop |
insert  |
len |
range { printToken(KEYWORD, yytext); }
>= |
\<=  |
== |
\!= { printToken(OPERATOR, yytext); }
; |
: |
, { printToken(SEPERATOR, yytext); }
(\".*\")|(\'.*\') { printToken(LITERAL, yytext); }
\*\* |
\* |
\/ { printToken(SYMBOL, yytext); }
\/\/ {}
\% |
\+ |
\- |
= |
\< |
> |
\^ |
\&  |
\| { printToken(OPERATOR, yytext); }
\{ |
\} |
\( |
\) |
\[ |
\] { printToken(SEPERATOR, yytext); }
[a-zA-Z_][a-zA-Z0-9_]* { printToken(ID, yytext); }
^[^a-zA-Z _] { printError(0); }
[0-9]+ |
[0-9]+\.[0-9]+ { printToken(LITERAL, yytext); }
. { printError(1); }
%% 

int yywrap() {  
    return 1;
} 

int main() {
    printf("-----------------------------------------\n");
    printf("TYPE \t\t TOKEN \t\t LINE NO.\n");
    printf("-----------------------------------------\n");
    yylex();
}

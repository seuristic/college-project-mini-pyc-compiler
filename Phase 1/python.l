%{
#include <stdio.h> 
#include<stdlib.h>
int lineno = 1; // initialize to 1

%} 
%% 
\. {}
\n { lineno+=1; }
#.* {}
[ ] {}
\t {}
False {}
None {}
True {}
and {}
break {}
continue {}
elif {}
del {}
else {}
for {}
if {}
in {}
not {}
or {}
while {}
input  {}
print {}
int {}
float {}
str {}
list {}
split {}
map {}
append {}
pop {}
insert  {}
len {}
range {}
>= {}
\<=  {}
== {}
\!= {}
; {}
: {}
, {}
(\".*\")|(\'.*\') {}
\*\* {}
\* {}
\/ {}
\/\/ {}
\% {}
\+ {}
\- {}
= {}
\< {}
> {}
\^ {}
\&  {}
\| {}
\{ {}
\} {}
\( {}
\) {}
\[ {}
\] {}
[a-zA-Z_][a-zA-Z0-9_]* {}
^[^a-zA-Z _] {printf("wrong identifier at line no %d\n",lineno);}
[0-9]+ {}
[0-9]+\.[0-9]+ {}
. {printf("undefined symbol at line no %d\n",lineno);}

%% 

int yywrap()  
{  
    return 1;
} 


int main()
{
	yylex();
}

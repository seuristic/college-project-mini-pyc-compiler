%{ 
#include<stdio.h> 
#include<stdlib.h> 
#include<string.h>
//extern DataItem* hashArray[SIZE]; 
%} 
  
%token DOT LINE FALSE NONE TRUE LAND BREAK CONTINUE ELIF DEL ELSE FOR IF IN NOT LOR WHILE INPUT PRINT INT FLOAT STR LIST SPLIT MAP APPEND POP INSERT LEN ID CINT CFLOAT SEMI COMMA CSTR EPOP MUL DIV FDIV MOD ADD SUB ASOP G L GE LE EOP NEOP XOR BAND BOR LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET RANGE COLON
%defines %union{ struct{char value[256]; int type;}ctype; char val[256];int ival;};
%type<ctype> Exp Const Or_Exp And_Exp In_Exp Eq_Exp Rel_Exp Bit_Exp Add_Exp Mul_Exp Pow_Exp Unary_Exp Primary_Exp
//%type<val> CFLOAT CSTR TRUE FALSE NONE ID
//%type<ival> CINT

%% 
Translation_unit: Stmt Translation_unit |  ;
Stmt: Simple_stmt SEMI | Compound_stmt | Assignment_stmt SEMI ;
Assignment_stmt: ID ASOP Exp 
{
    //insert("ID",$1,$3.type,NULL,-1);
    printf("%s %d %s\n",$<val>1,$3.type,$3.value);
}
Simple_stmt: Expression_stmt | Print_stmt | Del_stmt | Jump_stmt ;
Compound_stmt: If_stmt | While_stmt | For_stmt ;
Jump_stmt: BREAK | CONTINUE ;
Del_stmt: DEL ID  ;
Print_stmt: PRINT LPAREN Param_list RPAREN ;
Param_list: Exp COMMA Param_list | Exp ; 
If_stmt: IF Exp COLON LBRACE Stmt RBRACE Elif_stmt Else_stmt ;
Elif_stmt: ELIF Exp COLON LBRACE Stmt RBRACE Elif_stmt | ;
Else_stmt: ELSE COLON LBRACE Stmt RBRACE | ;
While_stmt: WHILE Exp COLON LBRACE Stmt RBRACE ;
For_stmt: FOR ID IN Iterable COLON LBRACE Stmt RBRACE ;
Iterable: LBRACKET Param_list RBRACKET  | RANGE LPAREN Param_list RPAREN | LIST LPAREN Param_list RPAREN | ID DOT SPLIT LPAREN Param_list RPAREN | MAP LPAREN Param_list RPAREN | INPUT LPAREN CSTR RPAREN ;
Expression_stmt: Exp ;
Exp:  Or_Exp ;
Const: CINT {$$.type=1;printf("hello : %s\n",$<val>1); char *buff[200];sprintf(buff,"%d",$<ival>1);strcpy($$.value,buff); }
| CFLOAT {$$.type=2; strcpy($$.value,$<val>1);}
| CSTR {$$.type=3; strcpy($$.value,$<val>1);}
| TRUE {$$.type=4; strcpy($$.value,$<val>1);}
| FALSE {$$.type=4; strcpy($$.value,$<val>1);}
| NONE {$$.type=5; strcpy($$.value,$<val>1);}
Primary_Exp: ID {$$.type=-1; strcpy($$.value,"");}
| Const ;
Unary_Exp:  Primary_Exp ;
Pow_Exp: Unary_Exp | Pow_Exp EPOP Unary_Exp ;
Mul_Exp: Pow_Exp | Mul_Exp MUL Pow_Exp | Mul_Exp DIV Pow_Exp | Mul_Exp FDIV Pow_Exp | Mul_Exp MOD Pow_Exp;
Add_Exp: Mul_Exp | Add_Exp ADD Mul_Exp | Add_Exp SUB Mul_Exp ;
Bit_Exp: Add_Exp | Bit_Exp XOR Add_Exp | Bit_Exp BAND Add_Exp | Bit_Exp BOR Add_Exp;
Rel_Exp: Bit_Exp | Rel_Exp G Bit_Exp | Rel_Exp GE Bit_Exp | Rel_Exp L Bit_Exp | Rel_Exp LE Bit_Exp;
Eq_Exp: Rel_Exp | Eq_Exp EOP Rel_Exp | Eq_Exp NEOP Rel_Exp ;
In_Exp: Eq_Exp | In_Exp IN Eq_Exp ;
And_Exp: In_Exp | And_Exp LAND In_Exp ;
Or_Exp: And_Exp | Or_Exp LOR And_Exp ;

%% 
  
int yyerror(char *msg) 
{ 
  //printf("Syntax Error\n"); 
} 
  
 
main() 
{ 
  yyparse(); 
  display();
}


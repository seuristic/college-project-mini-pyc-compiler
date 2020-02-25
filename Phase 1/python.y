%{ 
#include<stdio.h> 
#include<stdlib.h> 
%} 
  
%token DOT LINE FALSE NONE TRUE LAND BREAK CONTINUE ELIF DEL ELSE FOR IF IN NOT LOR WHILE INPUT PRINT INT FLOAT STR LIST SPLIT MAP APPEND POP INSERT LEN ID CINT CFLOAT SEMI COMMA CSTR EPOP MUL DIV FDIV MOD ADD SUB ASOP G L GE LE EOP NEOP XOR BAND BOR LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET RANGE COLON

%% 
Translation_unit: Stmt Translation_unit |  ;
Stmt: Simple_stmt SEMI | Compound_stmt | Assignment_stmt SEMI ;
Assignment_stmt: ID ASOP Exp | SubScript ASOP Exp ;
Simple_stmt: Expression_stmt | Print_stmt | Del_stmt | Jump_stmt ;
Compound_stmt: If_stmt | While_stmt | For_stmt ;
Jump_stmt: BREAK | CONTINUE ;
Del_stmt: DEL ID | DEL SubScript ;
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
Const: CINT | CFLOAT | CSTR | TRUE | FALSE | NONE ;
Primary_Exp: ID | Const | RPAREN Exp LPAREN | SubScript  | Iterable | LEN LPAREN Iterable RPAREN | Iterable DOT POP LPAREN Exp RPAREN | Iterable DOT INSERT LPAREN Param_list RPAREN |  Iterable DOT APPEND LPAREN Param_list RPAREN | INT LPAREN Exp RPAREN | FLOAT LPAREN Exp RPAREN | STR  LPAREN Exp RPAREN ;
SubScript: ID LBRACKET Primary_Exp RBRACKET ;
Unary_Exp: '-' Primary_Exp | '+' Primary_Exp | NOT Primary_Exp | Primary_Exp ;
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
}


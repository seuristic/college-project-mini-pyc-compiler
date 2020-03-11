%{ 
#include<stdio.h> 
#include<stdlib.h> 
#include "y.tab.h"
#include<string.h>

typedef struct Node
{
	struct Node *parent;
	struct Node *sibling;
  struct Node *child;
	char *token;
  int leaf;
}Node;

typedef struct tree
{
	Node *node;
	struct tree *next;
}tree;

tree *tree_init();
Node* create_node(Node *parent, char *token, int leaf);
tree *add_tree(Node *newnode);
void push(Node* node);
void printTree(tree* T);
void print(Node* node);

tree *tree_init()
{
	tree *temp= (tree*)malloc(sizeof(tree));
	temp->node = NULL;
  return(temp);
}

Node* create_node(Node *parent, char *token, int leaf) 
{
	Node *newnode = (Node*)malloc(sizeof(Node));
  newnode->token = (char*)malloc(strlen(token)*sizeof(char));
	strcpy(newnode->token, token);
	newnode->parent = parent;
	newnode->sibling = NULL;
  newnode->child = NULL;
  newnode->leaf=leaf;
	return(newnode);
}

tree *add_tree(Node *node)
{
	tree *temp= (tree*)malloc(sizeof(tree));
	temp->node = node;
  return(temp);
}

void print(Node* node) 
{ 
    if(node == NULL) 
        return; 

    printf("%s",node->token);
    print(node->child);  
    print(node->sibling); 
}

void printTree(tree* T)
{
  tree *temp = T;
  while(temp!=NULL)
  {
    print(temp->node);
    temp = temp->next;
  }
}

void first_val(char *first,char *temp)
{
    int i=0;int n=strlen(first);
    while(i<n && first[i]!=',')
    {
      temp[i]=first[i];i++;
    }
}

void expand(char *str,char *temp)
{
  char *pt;int a=0,b=0,c=0,i=0; char buffer[1024]="";
  pt = strtok(str,",");
  if(pt==NULL)
  {
    if(strlen(str)==0)
    {
    strcat(temp,"");
    return;
    }
  }
  a=atoi(pt);
  pt = strtok(NULL,",");
  if(pt==NULL)
  {
    i=0;
    while(i<a-1)
    {
      sprintf(buffer,"%d",i);
      strcat(temp,buffer);strcat(temp,",");
      i++;
    }
    sprintf(buffer,"%d",i);
    strcat(temp,buffer);
    return;
  }
  b=atoi(pt);
  pt = strtok (NULL,",");
  if(pt==NULL)
  {
    i=a;
    while(i<b-1)
    {
      sprintf(buffer,"%d",i);
      strcat(temp,buffer);strcat(temp,",");
      i++;
    }
    sprintf(buffer,"%d",i);
    strcat(temp,buffer);
    return;
  }  
  c=atoi(pt);
  i=a;
  if(c>0)
  {
  while(i<b-c)
  {
    sprintf(buffer,"%d",i);
    strcat(temp,buffer);strcat(temp,",");
    i+=c;
  }
  sprintf(buffer,"%d",i);
  strcat(temp,buffer);
  return;
  }
  else 
  {

    while(i>b-c)
    {
      sprintf(buffer,"%d",i);
      strcat(temp,buffer);strcat(temp,",");
      i+=c;
    }
    sprintf(buffer,"%d",i);
    strcat(temp,buffer);
    return; 
  }

}

void len(char *val,char *temp)
{
  int t=strlen(val);
  t=t-t/2;
  sprintf(temp,"%d",t);
}

tree *head = NULL;
tree *T_curr = NULL;
Node *N_curr = NULL;

void push(Node* node)
{
  if(N_curr->child==NULL)
    N_curr->child = node;
  else
  {
    Node *n = N_curr->child;
    while(n->sibling!=NULL)
    {
      n=n->sibling;
    }
    n->sibling = node;
  }
  N_curr = node;
}

%} 

%union{ struct{char value[1024]; int type;}ctype; char val[1024];};
%token DOT LINE FALSE NONE TRUE LAND BREAK CONTINUE ELIF DEL ELSE FOR IF IN NOT LOR WHILE INPUT PRINT INT FLOAT STR LIST SPLIT MAP APPEND POP INSERT LEN ID CINT CFLOAT SEMI COMMA CSTR EPOP MUL DIV FDIV MOD ADD SUB ASOP G L GE LE EOP NEOP XOR BAND BOR LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET RANGE COLON
%type <ctype> Exp Const Or_Exp And_Exp In_Exp Eq_Exp Rel_Exp Bit_Exp Add_Exp Mul_Exp Pow_Exp Unary_Exp Primary_Exp ID Iterable Param_list
%type<val> DOT LINE FALSE NONE TRUE LAND BREAK CONTINUE ELIF DEL ELSE FOR IF IN NOT LOR WHILE INPUT PRINT INT FLOAT STR LIST SPLIT MAP APPEND POP INSERT LEN  CINT CFLOAT SEMI COMMA CSTR EPOP MUL DIV FDIV MOD ADD SUB ASOP G L GE LE EOP NEOP XOR BAND BOR LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET RANGE COLON 
%% 
Translation_unit: Stmt Translation_unit {T_curr->next=tree_init();T_curr=T_curr->next;T_curr->node=create_node(NULL,"Stmt",0);N_curr=T_curr->node;}
|  ;
Stmt: Simple_stmt SEMI 
| Compound_stmt 
| Assignment_stmt SEMI ;
Assignment_stmt: ID ASOP Exp 
{
  char buff[3]="";
  sprintf(buff,"%d",$3.type);
  insert("ID",$1.value,buff,$3.value,-1);
  Node *node = create_node(N_curr,"ID",0);
  //push(node);
}
Simple_stmt: Expression_stmt | Print_stmt | Jump_stmt ;
Compound_stmt: If_stmt | While_stmt | For_stmt ;
Jump_stmt: BREAK | CONTINUE ;
Print_stmt: PRINT LPAREN Param_list RPAREN ;
Param_list: Param_list COMMA Exp  {$$.type=50+$1.type;strcat($$.value,",");strcat($$.value,$3.value);}
| Exp {} ;
If_stmt: IF Exp COLON LBRACE Stmt RBRACE Elif_stmt Else_stmt ;
Elif_stmt: ELIF Exp COLON LBRACE Stmt RBRACE Elif_stmt | ;
Else_stmt: ELSE COLON LBRACE Stmt RBRACE | ;
While_stmt: WHILE Exp COLON LBRACE Stmt RBRACE ;
For_stmt: FOR ID IN Iterable COLON LBRACE Stmt RBRACE {char temp[1024]="";first_val($4.value,temp);insert("ID",$2.value,$4.type,temp,-1);}
Iterable: LBRACKET Param_list RBRACKET  {$$=$2;}
| RANGE LPAREN Param_list RPAREN {$$.type=51;char temp[1024]="";expand($3.value,temp);strcpy($$.value,temp);} 
Expression_stmt: Exp ;
Exp:  Or_Exp ;
Const: CINT {$$.type=1; strcpy($$.value,$1);}
| CFLOAT {$$.type=2; strcpy($$.value,$1);}
| CSTR {$$.type=3; strcpy($$.value,$1);}
| TRUE {$$.type=4; strcpy($$.value,$1);}
| FALSE {$$.type=4; strcpy($$.value,$1);}
| NONE {$$.type=5; strcpy($$.value,$1);}
| INPUT LPAREN RPAREN {$$.type=3; strcpy($$.value,"");}
Primary_Exp: ID {$$=$1;}
| Const {$$=$1;}
| RPAREN Exp LPAREN {$$=$2;}
| Iterable {$$=$1;}
| LEN LPAREN Iterable RPAREN {$$.type=1;char buffer[10]="";len($3.value,buffer) ;strcpy($$.value,buffer); }
| INT LPAREN Exp RPAREN {$$.type=1; strcpy($$.value,$3.value); }
| FLOAT LPAREN Exp RPAREN {$$.type=2; strcpy($$.value,$3.value); }
| STR  LPAREN Exp RPAREN {$$.type=3; strcpy($$.value,$3.value); }
Unary_Exp: SUB Primary_Exp {$$.type=$2.type;char buffer[1024]="-";strcat(buffer,$2.value);strcpy($$.value,buffer);}
| ADD Primary_Exp {$$=$2;}
| NOT Primary_Exp {$$.type=$2.type;char buffer[1024]="-";strcat(buffer,$2.value);strcpy($$.value,buffer);}
| Primary_Exp ;
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
  printf("Syntax Error\n"); 
  return 1;
} 
  
 
int main() 
{ 
  head = tree_init();
  T_curr = head;
  N_curr = T_curr->node;
  yyparse(); 
  display_symbol();
  printf("\n\nAbstract Syntax Tree\n\n");
  printTree(head);
  return 1;
}


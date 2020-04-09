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
}tree;

tree *tree_init();
Node* create_node(Node *parent, char *token, int leaf);
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

void print(Node* node) 
{ 
    if(node == NULL) 
        return; 

    printf("%s ",node->token);
    print(node->child);  
    print(node->sibling); 
}

void printTree(tree* T)
{
  print(T->node);
  printf("\n");
}

void first_val(char *first, char *temp)
{
    int i=0;int n=strlen(first);
    while(i<n && first[i]!=',')
    {
      temp[i]=first[i];i++;
    }
}

void expand(char *str, char *temp)
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

void add_child(Node* parent, Node* child)
{
  if(parent==NULL)
    return;
  
  if(parent->child==NULL)
  {
    parent->child = child;
  }
  else
  {
    Node *n = parent->child;
    while(n->sibling!=NULL)
    {
      n=n->sibling;
    }
    n->sibling = child;
  }
  child->parent = parent;
}

void add_sibling(Node* left, Node* new)
{
  if(left==NULL)
  {
    left = new;
    return;
  }
  
  if(left->sibling==NULL)
  {
    left->sibling = new;
  }
  else
  {
    Node *n = left;
    while(n->sibling!=NULL)
    {
      n=n->sibling;
    }
    n->sibling = new;
  }
}

Node* end_node(Node* left)
{
  if(left==NULL)
    return NULL;
  
  if(left->sibling==NULL)
  {
    return left;
  }
  else
  {
    Node *n = left;
    while(n->sibling!=NULL)
    {
      n=n->sibling;
    }
    return n;
  }
}

%} 

%union{ struct{char value[1024]; int type;struct Node *node;}ctype; char val[1024];};
%token DOT LINE FALSE NONE TRUE LAND BREAK CONTINUE ELIF DEL ELSE FOR IF IN NOT LOR WHILE INPUT PRINT INT FLOAT STR LIST SPLIT MAP APPEND POP INSERT LEN ID CINT CFLOAT SEMI COMMA CSTR EPOP MUL DIV FDIV MOD ADD SUB ASOP G L GE LE EOP NEOP XOR BAND BOR LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET RANGE COLON
%type <ctype> Exp Const Or_Exp And_Exp In_Exp Eq_Exp Rel_Exp Bit_Exp Add_Exp Mul_Exp Pow_Exp Unary_Exp Primary_Exp ID Iterable Param_list Translation_unit Stmt Assignment_stmt Simple_stmt Compound_stmt Jump_stmt Print_stmt If_stmt Elif_stmt Else_stmt While_stmt For_stmt Expression_stmt Start
%type<val> DOT LINE FALSE NONE TRUE LAND BREAK CONTINUE ELIF DEL ELSE FOR IF IN NOT LOR WHILE INPUT PRINT INT FLOAT STR LIST SPLIT MAP APPEND POP INSERT LEN  CINT CFLOAT SEMI COMMA CSTR EPOP MUL DIV FDIV MOD ADD SUB ASOP G L GE LE EOP NEOP XOR BAND BOR LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET RANGE COLON 
%% 
Start: Translation_unit
{
  add_child(head->node,create_node(NULL,"Translation_unit",0));
  add_child(head->node->child,$1.node);
}
;
Translation_unit: Stmt Translation_unit 
{
  $$.node = create_node(NULL,"Stmt",0);
  add_child(end_node($$.node),$1.node);
  add_sibling($$.node,create_node(NULL,"Translation_unit",0));
  add_child(end_node($$.node),$2.node);
}
| Stmt
{
  $$.node = create_node(NULL,"Stmt",0);
  add_child(end_node($$.node),$1.node);
}
;
Stmt: Simple_stmt SEMI 
{
  $$.node=create_node(NULL,"Simple_stmt",0);
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,";",0));
}
| Compound_stmt 
{
  $$.node=create_node(NULL,"Compound_stmt",0);
  add_child($$.node,$1.node);
}
| Assignment_stmt SEMI 
{
  $$.node=create_node(NULL,"Assignment_stmt",0);
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,";",0));
}
;
Assignment_stmt: ID ASOP Exp 
{
  char buff[3]="";
  sprintf(buff,"%d",$3.type);
  insert("ID",$1.value,buff,$3.value,-1);
  $$.node=create_node(NULL,"ID",0);
  add_child($$.node,create_node(NULL,$1.value,0));
  add_sibling($$.node,create_node(NULL,"=",0));
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),$3.node);
}
Simple_stmt: Expression_stmt {$$.node=create_node(NULL,"Expression_stmt",0);add_child($$.node,$1.node);}
| Print_stmt {$$.node=create_node(NULL,"Print_stmt",0);add_child($$.node,$1.node);}
| Jump_stmt {$$.node=create_node(NULL,"Jump_stmt",0);add_child($$.node,$1.node);}
;
Compound_stmt: If_stmt {$$.node=create_node(NULL,"If_stmt",0);add_child($$.node,$1.node);}
| While_stmt {$$.node=create_node(NULL,"While_stmt",0);add_child($$.node,$1.node);}
| For_stmt {$$.node=create_node(NULL,"For_stmt",0);add_child($$.node,$1.node);}
;
Jump_stmt: BREAK {$$.node=create_node(NULL,"BREAK",0);}
| CONTINUE {$$.node=create_node(NULL,"CONTINUE",0);}
;
Print_stmt: PRINT LPAREN Param_list RPAREN 
{
  $$.node=create_node(NULL,"PRINT",0);
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,$3.node);
  add_sibling($$.node,create_node(NULL,")",0));
}
;
Param_list: Param_list COMMA Exp  
{
  $$.type=50+$3.type;strcat($$.value,",");
  strcat($$.value,$3.value);
  $$.node = create_node(NULL,"Param_list",0);
  add_child(end_node($$.node),$1.node);
  add_sibling($$.node,create_node(NULL,",",0));
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),$3.node);
}
| Exp 
{  
  $$.node = create_node(NULL,"EXP",0);
  add_child(end_node($$.node),$1.node);
} 
;
If_stmt: IF Exp COLON LBRACE Translation_unit RBRACE Elif_stmt Else_stmt 
{
  $$.node = create_node(NULL,"IF",0);
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),$2.node);
  add_sibling($$.node,create_node(NULL,":",0));
  add_sibling($$.node,create_node(NULL,"{",0));
  add_sibling($$.node,create_node(NULL,"Translation_unit",0));
  add_child(end_node($$.node),$5.node);
  add_sibling($$.node,create_node(NULL,"}",0));
  add_sibling($$.node,create_node(NULL,"Elif_stmt",0));
  add_child(end_node($$.node),$7.node);
  add_sibling($$.node,create_node(NULL,"Else_stmt",0));
  add_child(end_node($$.node),$8.node);
}
;
Elif_stmt: ELIF Exp COLON LBRACE Translation_unit RBRACE Elif_stmt
{
  $$.node = create_node(NULL,"ELIF",0);
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),$2.node);
  add_sibling($$.node,create_node(NULL,":",0));
  add_sibling($$.node,create_node(NULL,"{",0));
  add_sibling($$.node,create_node(NULL,"Translation_unit",0));
  add_child(end_node($$.node),$5.node);
  add_sibling($$.node,create_node(NULL,"}",0));
  add_sibling($$.node,create_node(NULL,"Elif_stmt",0));
  add_child(end_node($$.node),$7.node);
} 
| {}
;
Else_stmt: ELSE COLON LBRACE Translation_unit RBRACE
{
  $$.node = create_node(NULL,"ELSE",0);
  add_sibling($$.node,create_node(NULL,":",0));
  add_sibling($$.node,create_node(NULL,"{",0));
  add_sibling($$.node,create_node(NULL,"Translation_unit",0));
  add_child(end_node($$.node),$4.node);
  add_sibling($$.node,create_node(NULL,"}",0));
} 
| {}
;
While_stmt: WHILE Exp COLON LBRACE Translation_unit RBRACE 
{
  $$.node = create_node(NULL,"WHILE",0);
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),$2.node);
  add_sibling($$.node,create_node(NULL,":",0));
  add_sibling($$.node,create_node(NULL,"{",0));
  add_sibling($$.node,create_node(NULL,"Translation_unit",0));
  add_child(end_node($$.node),$5.node);
  add_sibling($$.node,create_node(NULL,"}",0));
}
;
For_stmt: FOR ID IN Iterable COLON LBRACE Translation_unit RBRACE 
{
  char temp[1024]="";
  first_val($4.value,temp);
  char buff[3]="";
  sprintf(buff,"%d",$4.type%10);
  insert("ID",$2.value,buff,temp,-1);
  $$.node = create_node(NULL,"FOR",0);
  add_sibling($$.node,create_node(NULL,"ID",0));
  add_child(end_node($$.node),create_node(NULL,$2.value,0));
  add_sibling($$.node,create_node(NULL,"in",0));
  add_sibling($$.node,create_node(NULL,"Iterable",0));
  add_child(end_node($$.node),$4.node);
  add_sibling($$.node,create_node(NULL,":",0));
  add_sibling($$.node,create_node(NULL,"{",0));
  add_sibling($$.node,create_node(NULL,"Translation_unit",0));
  add_child(end_node($$.node),$7.node);
  add_sibling($$.node,create_node(NULL,"}",0));
}
;
Iterable: LBRACKET Param_list RBRACKET  
{
  $$=$2;
  $$.node = create_node(NULL,"[",0);
  add_sibling($$.node,create_node(NULL,"Param_list",0));
  add_child(end_node($$.node),$2.node);
  add_sibling($$.node,create_node(NULL,"]",0));
}
| RANGE LPAREN Param_list RPAREN 
{
  $$.type=51;
  char temp[1024]="";
  expand($3.value,temp);strcpy($$.value,temp);
  $$.node = create_node(NULL,"RANGE",0);
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,create_node(NULL,"Param_list",0));
  add_child(end_node($$.node),$3.node);
  add_sibling($$.node,create_node(NULL,")",0));
}
; 
Expression_stmt: Exp 
{
  $$.node = create_node(NULL,"Exp",0);
  add_child($$.node,$1.node);
}
;
Exp: Or_Exp 
{
  $$.node = create_node(NULL,"Or_Exp",0);
  add_child($$.node,$1.node);
}
;
Const: CINT 
{
  $$.type=1;
  strcpy($$.value,$1);
  $$.node = create_node(NULL,"CINT",0);
  add_child($$.node,create_node(NULL,$$.value,0));
}
| CFLOAT 
{
  $$.type=2;
  strcpy($$.value,$1);
  $$.node = create_node(NULL,"CFLOAT",0);
  add_child($$.node,create_node(NULL,$$.value,0));
}
| CSTR 
{
  $$.type=3;
  strcpy($$.value,$1);
  $$.node = create_node(NULL,"CSTR",0);
  add_child($$.node,create_node(NULL,$$.value,0));
}
| TRUE 
{
  $$.type=4;
  strcpy($$.value,$1);
  $$.node = create_node(NULL,"TRUE",0);
  add_child($$.node,create_node(NULL,$$.value,0));
}
| FALSE 
{
  $$.type=4;
  strcpy($$.value,$1);
  $$.node = create_node(NULL,"FALSE",0);
  add_child($$.node,create_node(NULL,$$.value,0));
}
| NONE 
{
  $$.type=5;
  strcpy($$.value,$1);
  $$.node = create_node(NULL,"NONE",0);
  add_child($$.node,create_node(NULL,$$.value,0));
}
| INPUT LPAREN RPAREN 
{
  $$.type=3;
  strcpy($$.value,"");
  $$.node = create_node(NULL,"INPUT",0);
  add_child($$.node,create_node(NULL,$$.value,0));
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,create_node(NULL,")",0));
}
;
Primary_Exp: ID 
{
  $$=$1; 
  $$.node = create_node(NULL,"ID",0); 
  add_child($$.node,create_node(NULL,$1.value,0));
}
| Const 
{
  $$=$1;  
  $$.node = create_node(NULL,"Const",0); 
  add_child($$.node,$1.node);
}
| RPAREN Exp LPAREN 
{
  $$=$2;
  $$.node = create_node(NULL,"(",0);
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),create_node(NULL,$2.node,0));
  add_sibling($$.node,create_node(NULL,")",0));
}
| Iterable 
{
  $$=$1;
  $$.node = create_node(NULL,"Iterable",0);
  add_child($$.node,$1.node);
}
| LEN LPAREN Iterable RPAREN 
{
  $$.type=1;
  char buffer[10]="";
  len($3.value,buffer) ;
  strcpy($$.value,buffer);
  $$.node = create_node(NULL,"LEN",0);
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,create_node(NULL,"Iterable",0));
  add_child(end_node($$.node),$3.node);
  add_sibling($$.node,create_node(NULL,")",0));
}
| INT LPAREN Exp RPAREN 
{
  $$.type=1;
  strcpy($$.value,$3.value);
  $$.node = create_node(NULL,"INT",0);
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),create_node(NULL,$3.node,0));
  add_sibling($$.node,create_node(NULL,")",0));
}
| FLOAT LPAREN Exp RPAREN 
{
  $$.type=2;
  strcpy($$.value,$3.value);
  $$.node = create_node(NULL,"FLOAT",0);
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),create_node(NULL,$3.node,0));
  add_sibling($$.node,create_node(NULL,")",0));
}
| STR LPAREN Exp RPAREN 
{
  $$.type=3;
  strcpy($$.value,$3.value);
  $$.node = create_node(NULL,"STR",0);
  add_sibling($$.node,create_node(NULL,"(",0));
  add_sibling($$.node,create_node(NULL,"EXP",0));
  add_child(end_node($$.node),create_node(NULL,$3.node,0));
  add_sibling($$.node,create_node(NULL,")",0));
}
;
Unary_Exp: SUB Primary_Exp 
{
  $$.type=$2.type;
  char buffer[1024]="-";
  strcat(buffer,$2.value);
  strcpy($$.value,buffer);
  $$.node = create_node(NULL,"-",0); 
  add_sibling($$.node,create_node(NULL,"Primary_Exp",0));
  add_child(end_node($$.node),$2.node);
}
| ADD Primary_Exp 
{
  $$=$2;
  $$.node = create_node(NULL,"+",0); 
  add_sibling($$.node,create_node(NULL,"Primary_Exp",0));
  add_child(end_node($$.node),$2.node);
}
| NOT Primary_Exp 
{
  $$.type=$2.type;
  char buffer[1024]="-";
  strcat(buffer,$2.value);
  strcpy($$.value,buffer);
  $$.node = create_node(NULL,"!",0); 
  add_sibling($$.node,create_node(NULL,"Primary_Exp",0));
  add_child(end_node($$.node),$$.node);
}
| Primary_Exp 
{
  $$.node = create_node(NULL,"Primary_Exp",0); 
  add_child($$.node,$1.node);
}
;
Pow_Exp: Unary_Exp 
{
  $$.node = create_node(NULL,"Unary_Exp",0); 
  add_child($$.node,$1.node);
}
| Pow_Exp EPOP Unary_Exp 
{
  $$.node = create_node(NULL,"Pow_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"**",0));
  add_sibling($$.node,create_node(NULL,"Unary_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
Mul_Exp: Pow_Exp 
{
  $$.node = create_node(NULL,"Pow_Exp",0); 
  add_child($$.node,$1.node);
}
| Mul_Exp MUL Pow_Exp 
{
  $$.node = create_node(NULL,"Mul_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"*",0));
  add_sibling($$.node,create_node(NULL,"Pow_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Mul_Exp DIV Pow_Exp 
{
  $$.node = create_node(NULL,"Mul_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"/",0));
  add_sibling($$.node,create_node(NULL,"Pow_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Mul_Exp FDIV Pow_Exp 
{
  $$.node = create_node(NULL,"Mul_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"//",0));
  add_sibling($$.node,create_node(NULL,"Pow_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Mul_Exp MOD Pow_Exp
{
  $$.node = create_node(NULL,"Mul_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"%",0));
  add_sibling($$.node,create_node(NULL,"Pow_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
Add_Exp: Mul_Exp 
{
  $$.node = create_node(NULL,"Mul_Exp",0); 
  add_child($$.node,$1.node);
}
| Add_Exp ADD Mul_Exp 
{
  $$.node = create_node(NULL,"Add_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"+",0));
  add_sibling($$.node,create_node(NULL,"Mul_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Add_Exp SUB Mul_Exp
{
  $$.node = create_node(NULL,"Add_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"-",0));
  add_sibling($$.node,create_node(NULL,"Mul_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
Bit_Exp: Add_Exp 
{
  $$.node = create_node(NULL,"Add_Exp",0); 
  add_child($$.node,$1.node);
}
| Bit_Exp XOR Add_Exp 
{
  $$.node = create_node(NULL,"Bit_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"^",0));
  add_sibling($$.node,create_node(NULL,"Add_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Bit_Exp BAND Add_Exp 
{
  $$.node = create_node(NULL,"Bit_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"&",0));
  add_sibling($$.node,create_node(NULL,"Add_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Bit_Exp BOR Add_Exp
{
  $$.node = create_node(NULL,"Bit_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"|",0));
  add_sibling($$.node,create_node(NULL,"Add_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
Rel_Exp: Bit_Exp 
{
  $$.node = create_node(NULL,"Bit_Exp",0); 
  add_child($$.node,$1.node);
}
| Rel_Exp G Bit_Exp 
{
  $$.node = create_node(NULL,"Rel_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,">",0));
  add_sibling($$.node,create_node(NULL,"Bit_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Rel_Exp GE Bit_Exp 
{
  $$.node = create_node(NULL,"Rel_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,">=",0));
  add_sibling($$.node,create_node(NULL,"Bit_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Rel_Exp L Bit_Exp 
{
  $$.node = create_node(NULL,"Rel_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"<",0));
  add_sibling($$.node,create_node(NULL,"Bit_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Rel_Exp LE Bit_Exp
{
  $$.node = create_node(NULL,"Rel_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"<=",0));
  add_sibling($$.node,create_node(NULL,"Bit_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
Eq_Exp: Rel_Exp 
{
  $$.node = create_node(NULL,"Rel_Exp",0); 
  add_child($$.node,$1.node);
}
| Eq_Exp EOP Rel_Exp 
{
  $$.node = create_node(NULL,"Eq_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"==",0));
  add_sibling($$.node,create_node(NULL,"Rel_Exp",0));
  add_child(end_node($$.node),$3.node);
}
| Eq_Exp NEOP Rel_Exp 
{
  $$.node = create_node(NULL,"Eq_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"!=",0));
  add_sibling($$.node,create_node(NULL,"Rel_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
In_Exp: Eq_Exp 
{
  $$.node = create_node(NULL,"Eq_Exp",0); 
  add_child($$.node,$1.node);
}
| Eq_Exp IN In_Exp   
{
  $$.node = create_node(NULL,"Eq_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"in",0));
  add_sibling($$.node,create_node(NULL,"In_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
And_Exp: In_Exp 
{
  $$.node = create_node(NULL,"In_Exp",0); 
  add_child($$.node,$1.node);
}
| In_Exp LAND And_Exp   
{
  $$.node = create_node(NULL,"In_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"and",0));
  add_sibling($$.node,create_node(NULL,"And_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;
Or_Exp: And_Exp 
{
  $$=$1;  
  $$.node = create_node(NULL,"And_Exp",0); 
  add_child($$.node,$1.node);
}
| And_Exp LOR Or_Exp 
{
  $$=$1;  
  $$.node = create_node(NULL,"And_Exp",0); 
  add_child($$.node,$1.node);
  add_sibling($$.node,create_node(NULL,"or",0));
  add_sibling($$.node,create_node(NULL,"Or_Exp",0));
  add_child(end_node($$.node),$3.node);
}
;

%% 
int yyerror(char *msg) 
{ 
  printf("Syntax Error\n"); 
  return 1;
} 
 
int main() 
{ 
  head = tree_init();
  head->node = create_node(NULL,"Start",0);
  yyparse(); 
  display_symbol();
  printf("\n\nAbstract Syntax Tree\n\n");
  printTree(head);
  return 1;
}


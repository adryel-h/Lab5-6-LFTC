%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YYDEBUG 1

#define TIP_INT 1
#define TIP_REAL 2
#define TIP_CAR 3

double stiva[20];
int sp;
extern int yylex();
extern void yyerror(char* s);
void push(double x)
{ stiva[sp++]=x; }

double pop()
{ return stiva[--sp]; }

%}

%union {
  	int l_val;
	char *p_val;
}

%token ELSE
%token IF
%token WHILE
%token INT
%token MAIN
%token FOR
%token CIN
%token COUT
%token OPCOUT
%token OPCIN
%token PR_O
%token PR_C
%token BR_O
%token BR_C
%token STRICT_LESS
%token STRICT_GREAT
%token ID
%token <p_val> CONST_INT
%token <p_val> CONST_REAL
%token <p_val> CONST_CAR
%token CONST_SIR

%token CHAR
%token REAL

%token E
%token ATRIB
%token NE
%token LE
%token GE
%token DIV
%token MOD
%token STRICT_GREAT
%token STRICT_LESS
%token AND
%token OR
%token NOT

%left '+' '-'
%left DIV MOD '*' 
%left LE GE E NE STRICT_GREAT STRICT_LESS 
%left OR
%left AND
%left NOT

%type <l_val> constanta
%%


program:        INT MAIN PR_O PR_C BR_O decllist statement_list BR_C
                ;
decllist:       declaration ';'
                | declaration ';' decllist
                ;
declaration:    type list_id
                ;
type:           INT
                | CHAR
                | REAL
                ;
list_id:        ID
                | ID ATRIB constanta 
                ;
statement_list: /* empty */
                | statement statement_list
                ;
statement:       simple_statement ';'
                | compound_statement
                ;
simple_statement: assignment
                | io_statement
                ;
compound_statement: if_statement
                    | while_statement
                    ;
assignment:     ID ATRIB expression
                ;
expression:     constanta
                | ID
                | expression '+' expression
                | expression '-' expression 
                | expression MOD expression 
                | expression '*' expression
                | expression DIV expression
                | expression LE expression
                | expression STRICT_LESS expression
                | expression STRICT_GREAT expression
                | expression GE expression
                | expression E expression
                | expression NE expression
                | expression AND expression
                | expression OR expression
                | NOT PR_O expression PR_C
                ;
oprel:          STRICT_LESS
                | LE
                | STRICT_GREAT
                | GE
                | E
                | NE
                | AND
                | OR
                ;
io_statement:  CIN OPCIN ID
               | COUT OPCOUT ID
               | COUT OPCOUT constanta
               ;
if_statement:  IF PR_O expression PR_C BR_O statement_list BR_C
               | IF PR_O expression PR_C BR_O statement_list BR_C ELSE BR_O statement_list BR_C
               ;
while_statement:   WHILE PR_O expression PR_C BR_O statement_list BR_C
                   ;
  


constanta:	CONST_INT	{
			$$ = TIP_INT;
			push(atof($1));
				}
		| CONST_REAL	{
			$$ = TIP_REAL;
			push(atof($1));
				}
		| CONST_CAR	{
			$$ = TIP_CAR;
			push((double)$1[0]);
				}
	        | CONST_SIR   
	        	{
	    		}  
		;

%%

void yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

int main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stdout,"\tO.K.\n");
}

%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(char *msg);

//================================CUSTOM DEFINED STRUCTURES=================================

typedef union id_val{
  int i;
  float f;
  double d;
  char c;
}id_val;

typedef enum id_type
{
  INT,FLOAT,DOUBLE,CHAR
}id_type;

typedef struct Identifier
{
  id_type type;
  char name[50];
  id_val x;
}identifier;


//========================================END===============================================


%}



%union {
  float f;
  double d;
  identifier id;
}

%token IDENTIFIER

%token <f> NUM
%type <f> EXPR T F

%token QUIT

%%

S : EXPR '\n'             {printf(" %f\n", $1);return 0;}
  | QUIT '\n'             {return -1;}
  | IDENTIFIER '\n'       {printf("identifier found\n");return 0;}
  ;

EXPR : EXPR '+' T     {$$ = $1 + $3;}
  | EXPR '-' T     {$$ = $1 - $3;}
  | T           {$$ = $1;}
  ;

T : T '*' F     {$$ = $1 * $3;}
  | T '/' F     {$$ = $1 / $3;}
  | F           {$$ = $1;}
  ;

F : '(' EXPR ')'   {$$ = $2;}
  | '-' F       {$$ = -$2;}
  | NUM         {$$ = $1;}
  ;

%%
void yyerror(char *msg) {
    fprintf(stderr, "%s\n", msg);
    exit(1);
}
int main() {
    while(1)
    {
      printf(">>> ");
      if(yyparse()<0)break;
    }
    printf(" bye!!\n");
    return 0;
}
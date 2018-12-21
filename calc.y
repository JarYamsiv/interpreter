%{
#include <stdio.h>
#include <stdlib.h>
#include "headers/struct_definitions.h"
extern int yylex();
void yyerror(char *msg);

//================================ERRORS================================
#define ERROR_TYPE_ERROR -66001
//===================================END================================


%}





%union {
  identifier id;
}

%token <id> IDENTIFIER CONST

%type <id> EXPR T F

%token FUNCTIONCALL

%token QUIT LEX_ERROR_TOKEN

%%

S : EXPR '\n'             {

    if($<id.type>$==TYPE_INT)printf(" %d\n", $<id.x.i>1);
    if($<id.type>$==TYPE_FLOAT)printf(" %f\n", $<id.x.f>1);
    return 0; 

    }

  | QUIT '\n'             {return -1;}

  | IDENTIFIER '\n'       {
    printf("identifier found %s\n",$<id.name>$);return 0;
    }

  | IDENTIFIER '=' EXPR '\n'  {

    if($<id.type>3==TYPE_INT){printf("%s assigned the value %d\n", $<id.name>1 , $<id.x.i>3 ); }
    if($<id.type>3==TYPE_FLOAT){printf("%s assigned the value %f\n", $<id.name>1 , $<id.x.f>3 ); }
    return 0;

    }

  | IDENTIFIER '(' ')'  '\n'      {printf("calling function %s\n",$<id.name>1);return 0;}
  ;



EXPR : EXPR '+' T     {

  if( $<id.type>1 == TYPE_INT && $<id.type>3 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1 + $<id.x.i>3; $<id.type>$ = TYPE_INT;}
  else if( $<id.type>1 == TYPE_FLOAT && $<id.type>3 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1 + $<id.x.f>3; $<id.type>$ = TYPE_FLOAT;}
  else{return ERROR_TYPE_ERROR;}

  }

  | EXPR '-' T     {

    if( $<id.type>1 == TYPE_INT && $<id.type>3 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1 - $<id.x.i>3; $<id.type>$ = TYPE_INT;}
    else if( $<id.type>1 == TYPE_FLOAT && $<id.type>3 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1 - $<id.x.f>3; $<id.type>$ = TYPE_FLOAT;}
    else{return ERROR_TYPE_ERROR;}

    }

  | T           {

    if( $<id.type>1 == TYPE_INT){$<id.x.i>$ = $<id.x.i>1; $<id.type>$ = TYPE_INT;}
    if( $<id.type>1 == TYPE_FLOAT){$<id.x.f>$ = $<id.x.f>1; $<id.type>$ = TYPE_FLOAT;}

    }

  ;

T : T '*' F     {
  if( $<id.type>1 == TYPE_INT && $<id.type>3 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1 * $<id.x.i>3; $<id.type>$ = TYPE_INT;}
  if( $<id.type>1 == TYPE_FLOAT && $<id.type>3 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1 * $<id.x.f>3; $<id.type>$ = TYPE_FLOAT;}
  else {return ERROR_TYPE_ERROR;}
  }

  | T '/' F     {
    if( $<id.type>1 == TYPE_INT && $<id.type>3 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1 / $<id.x.i>3; $<id.type>$ = TYPE_INT;}
    if( $<id.type>1 == TYPE_FLOAT && $<id.type>3 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1 / $<id.x.f>3;$<id.type>$ = TYPE_FLOAT;}
    }

  | F           {
    if( $<id.type>1 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1; $<id.type>$=TYPE_INT; }
    if( $<id.type>1 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1; $<id.type>$=TYPE_FLOAT; }
    }
  ;

F : '(' EXPR ')'   {
  if( $<id.type>2 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>2; $<id.type>$ = TYPE_INT;}
  if( $<id.type>2 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>2; $<id.type>$ = TYPE_FLOAT;}
  }

  | '-' F       {
    if( $<id.type>2 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>2; $<id.type>$ = TYPE_INT;}
    if( $<id.type>2 == TYPE_FLOAT ){$<id.x.f>$ = -$<id.x.f>2; $<id.type>$ = TYPE_FLOAT;}
    }

  | CONST         {
    if( $<id.type>1 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1; $<id.type>$ = TYPE_INT;}
    if( $<id.type>1 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1; $<id.type>$ = TYPE_FLOAT;}
    }
  ;



%%
void yyerror(char *msg) {
    fprintf(stdout, "%s\n", msg);
}
int main() {
    int current_stats;
    while(1)
    {
      printf(">>> ");
      current_stats = yyparse();

      if(current_stats<0)
      {
        switch (current_stats)
        {
          case ERROR_TYPE_ERROR:
          {
            printf("type error!!\n");
            break;
          }
        }
      }

      if(current_stats==-1)
      {
        break;
      }

    }
    printf(" bye!!\n");
    return 0;
}
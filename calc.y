%{
#include <bits/stdc++.h>

#include "headers/struct_definitions.h"
#include "lex.h"
extern int yylex();


void yyerror(const char* msg);
int yywrap();

//================================ERRORS================================
#define ERROR_TYPE_ERROR -66001
#define ERROR_UNDEFINED_IDENTIFIER -66002
//===================================END================================

//============================RETURNS===================================
#define RETURN_NEWLINE 66000
#define RETURN_IF_END 66001
//=============================END======================================

std::unordered_map<std::string,identifier> variables;


std::vector<command> code_stack;
std::vector<command> execution_stack;
int stack_trigger;
int indent_state;
int indent_level;



%}





%union {
  identifier id;
  condition_block cond_block;
}

%token <cond_block> IF WHILE FOR;
%type <cond_block> CONDITIONS CONDITION
%token AND OR NOT 
%token EQ GT LT GTE LSE NEQ
%token TRUE FALSE

%token <id> IDENTIFIER CONST

%type <id> EXPR T F

%token FUNCTIONCALL

%token QUIT LEX_ERROR_TOKEN

%%

S : '\n'               {return RETURN_NEWLINE;} 
  | '\t' S             {indent_level++;}

  |EXPR '\n'             {

    if($<id.type>1==TYPE_INT)printf(" %d\n", $<id.x.i>1);
    if($<id.type>1==TYPE_FLOAT)printf(" %f\n", $<id.x.f>1);

    
    return 0; 

    }

  | QUIT '\n'             {return -1;}


  | IDENTIFIER '=' EXPR '\n'  {

    
    identifier var;
    var.type = $<id.type>3;
    strcpy(var.name,$<id.name>3);
    var.x = $<id.x>3;
    variables[$<id.name>1] = var;

    
    return 0;

    }

  | IDENTIFIER '(' ')'  '\n'      {printf("calling function %s\n",$<id.name>1);return 0;}
  | IF '(' CONDITIONS ')'          '\n'      {
    indent_state = 1;
    command c;
    c.indent_level = indent_level;
    if($3.val==1){
      c.state = COM_IF_TRUE;
      code_stack.push_back(c);
      return 0;
      }
    else
    {
      c.state = COM_IF_FALSE;
      code_stack.push_back(c);
      return 0;
    }
    }
  ;

CONDITIONS : CONDITIONS AND CONDITION       {$$.val = $1.val && $3.val;}
            | CONDITIONS OR CONDITION       {$$.val = $1.val || $3.val;}
            | NOT CONDITION                 {$$.val = !$2.val;}
            | CONDITION                     {$$.val = $1.val;}
            ;

CONDITION : EXPR EQ EXPR  {
  id_type t1 = $<id.type>1;id_type t2 = $<id.type>3;
  if(t1==TYPE_INT&&t2==TYPE_INT)            {$$.val = ($<id.x.i>1 == $<id.x.i>3);}
  else if(t1==TYPE_FLOAT&&t2==TYPE_FLOAT)   {$$.val = (fabs($<id.x.f>1-$<id.x.f>3)<0.000000001);}
  else                                      {return ERROR_TYPE_ERROR;}
  }
          |EXPR NEQ EXPR  {
  id_type t1 = $<id.type>1;id_type t2 = $<id.type>3;
  if(t1==TYPE_INT&&t2==TYPE_INT)            {$$.val = ($<id.x.i>1 != $<id.x.i>3);}
  else if(t1==TYPE_FLOAT&&t2==TYPE_FLOAT)   {$$.val = (fabs($<id.x.f>1-$<id.x.f>3)>0.000000001);}
  else                                      {return ERROR_TYPE_ERROR;}
  }
          |EXPR GT EXPR  {
  id_type t1 = $<id.type>1;id_type t2 = $<id.type>3;
  if(t1==TYPE_INT&&t2==TYPE_INT)            {$$.val = ($<id.x.i>1 > $<id.x.i>3);}
  else if(t1==TYPE_FLOAT&&t2==TYPE_FLOAT)   {$$.val = ($<id.x.f>1 > $<id.x.f>3);}
  else                                      {return ERROR_TYPE_ERROR;}
  }
          |EXPR LT EXPR  {
  id_type t1 = $<id.type>1;id_type t2 = $<id.type>3;
  if(t1==TYPE_INT&&t2==TYPE_INT)            {$$.val = ($<id.x.i>1 < $<id.x.i>3);}
  else if(t1==TYPE_FLOAT&&t2==TYPE_FLOAT)   {$$.val = ($<id.x.f>1 < $<id.x.f>3);}
  else                                      {return ERROR_TYPE_ERROR;}
  }
          | TRUE                      {$$.val = 1;}
          | FALSE                     {$$.val = 0;}
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
  else if( $<id.type>1 == TYPE_FLOAT && $<id.type>3 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1 * $<id.x.f>3; $<id.type>$ = TYPE_FLOAT;}
  else {return ERROR_TYPE_ERROR;}
  }

  | T '/' F     {
    if( $<id.type>1 == TYPE_INT && $<id.type>3 == TYPE_INT ){$<id.x.i>$ = $<id.x.i>1 / $<id.x.i>3; $<id.type>$ = TYPE_INT;}
    else if( $<id.type>1 == TYPE_FLOAT && $<id.type>3 == TYPE_FLOAT ){$<id.x.f>$ = $<id.x.f>1 / $<id.x.f>3;$<id.type>$ = TYPE_FLOAT;}
    else {return ERROR_TYPE_ERROR;}
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

  | IDENTIFIER    {

    if(variables.find($<id.name>1) == variables.end() )
    {
      return ERROR_UNDEFINED_IDENTIFIER;
    }

    id_type t = variables[$<id.name>1].type;
    int i = variables[$<id.name>1].x.i;
    float f = variables[$<id.name>1].x.f;
    if( t == TYPE_INT ){$<id.x.i>$ = i; $<id.type>$ = TYPE_INT;}
    else  if( t == TYPE_FLOAT ){$<id.x.f>$ = f; $<id.type>$ = TYPE_FLOAT;}
    else{return ERROR_TYPE_ERROR;}
  }
  ;



%%
void yyerror(const char *msg) {
    fprintf(stdout, "%s\n", msg);
}

int yywrap()
{
  return 0;
}

void print_error(int current_stats)
{
  switch (current_stats)
        {
          case ERROR_TYPE_ERROR:
          {
            printf("type error!!\n");
            break;
          }
          case ERROR_UNDEFINED_IDENTIFIER:
          {
            printf("undefined identifier\n");
            break;
          }
        }
}

int process_return(int ret_val)
{
  switch (ret_val)
  {
    case RETURN_NEWLINE:
    {
      //printf("newline\n");
      stack_trigger = 1;
      indent_state = 0;
      break;
    }
  }
}

int read_current_code(char* code)
{
  if(!indent_state){printf(">>> ");}
  else            {printf("... ");}
  std::cin.getline( code, 511, '\n' );
  int flag_code_started=0;
  int i;
  for(i=0; code[i]!='\0'; i++ )
  {
    if(!flag_code_started)
    {
      if(code[i]=='\t')indent_level++;
      else{flag_code_started=1;}
    }
    else
    {
      if(code[i]=='\t')code[i]=' ';
    }
  }
  code[i]='\n';
  code[i+1] = '\0';


}


int main() {
    int current_stats;
    char code[512];
    stack_trigger = 0;
    indent_state = 0;
    
    while(1)
    {

      read_current_code(code);

      if(stack_trigger == 1 && !code_stack.empty())
      {
        /*
          loading to executions stack.. it will contain the truthnesds of the if statement on top
        */
        while(!code_stack.empty())
        {
          execution_stack.push_back(code_stack.back());
          code_stack.pop_back();
        }

        if(execution_stack.back().state == COM_IF_TRUE)
        {
          execution_stack.pop_back();
          char c_code[512];
          while(!execution_stack.empty())
          {
              strcpy(c_code,execution_stack.back().code);
              yy_scan_string(c_code);
              yyparse();
              execution_stack.pop_back();
          }
        }
        else{
          execution_stack.clear();
        }


      }
      stack_trigger = 0;

      if(indent_state==1&&strcmp(code,"\n")!=0)
      {
        command c;
        strcpy(c.code,code);
        c.state = COM_STATEMENT;
        c.indent_level = indent_level;
        code_stack.push_back(c);
      }
      else
      {
        yy_scan_string(code);
        current_stats = yyparse();
      }

      indent_level = 0;

      if(current_stats==-1)     {break;}
      if(current_stats<0)       {print_error(current_stats);}
      else if(current_stats>0)  {process_return(current_stats);}
      

    }
    printf(" bye!!\n");
    return 0;
}
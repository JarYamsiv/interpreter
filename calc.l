%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"  // generated via yacc -d
%}

%option noyywrap

%%
"quit"                              {return QUIT;} //this should be above identifier else it will be treated as one

[a-zA-Z]([a-zA-Z0-9_])*             {return IDENTIFIER;}

[0-9]+(\.[0-9]+)?([eE][0-9]+)?      {yylval.f = atof(yytext); return NUM;}
[-+()*/=]                           {return yytext[0];}
[\n]                                {return yytext[0];}
[ \t\f\v]                           { ; }



%%
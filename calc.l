%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>

#include "headers/struct_definitions.h" //this should be before yy.tab.h (stackoverflow qn)

#include "y.tab.h"  // generated via yacc -d

%}

%option noyywrap

%%
"quit"                              {return QUIT;} //this should be above identifier else it will be treated as one

[a-zA-Z]([a-zA-Z0-9_])*             {
    strcpy(yylval.id.name,yytext);
    return IDENTIFIER;
    }

[0-9]([0-9])*                       {
    yylval.id.type = TYPE_INT;
    yylval.id.x.i = atoi(yytext); 
    return CONST;
    }

[0-9]([0-9])*[.][0-9]([0-9])*        {
    yylval.id.type = TYPE_FLOAT;
    yylval.id.x.f = atof(yytext); 
    return CONST;
    }
['][a-zA-Z]['']                       {
    yylval.id.type = TYPE_CHAR;
    yylval.id.x.c  = yytext[1];
    return CONST;
}
[-+()*/=]                           {return yytext[0];}
[\n]                                {return yytext[0];}
[ \t\f\v]                           { ; }



%%
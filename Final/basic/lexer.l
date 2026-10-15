%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}

%%
"int"                   {return INT;}
[a-zA-Z_][a-zA-Z0-9_]*  {
                            yylval.str=strdup(yytext);
                            return ID;
                        }
[0-9]+                  {
                            yylval.str=strdup(yytext);
                            return NUM;
                        }
[=+\-*/(),;]            {return yytext[0];}
[ \t\n\r]+              ;
.                       {printf("Invalid character: %s\n",yytext); return yytext[0];}
%%

int yywrap(){
    return 1;
}
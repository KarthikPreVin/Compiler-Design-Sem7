%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}

%%
"int"                   {return INT;}
"and"                   {return AND;}
"or"                    {return OR;}

"<="|">="|"=="|"!="|"<"|">" {
                            yylval.str=strdup(yytext);
                            return RELOP;
                        }

[A-Za-z_][A-Za-z0-9_]* {
                            yylval.str=strdup(yytext);
                            return ID;
                        }

[0-9]+                  {
                            yylval.str=strdup(yytext);
                            return NUM;
                        }

[=+\-*/(),;]            {return yytext[0];}
[ \t\r\n]+              ;
.                       {fprintf(stderr,"Invalid character: %s\n",yytext);}
%%

int yywrap(){
    return 1;
}
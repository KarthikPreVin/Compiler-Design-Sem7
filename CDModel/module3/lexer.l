%option noyywrap
%{
#include "parser.tab.h"
#include<stdio.h>
#include<string.h>
%}

%%
":="                    { return ASSIGN; }
"and"                   { return AND; }
"or"                    { return OR; }

"<=" { return LE;}
">=" { return GE;}
"==" { return EQ;}
"!=" { return NE;}

[a-zA-Z_][a-zA-Z_0-9]* {
    yylval.str=strdup(yytext);
    return ID;
}
[0-9]+ {
    yylval.str=strdup(yytext);
    return NUMBER;
}
[ \t\r\n]+ ;
[()+*/<>-] {return yytext[0];}
. {return yytext[0];}

%%
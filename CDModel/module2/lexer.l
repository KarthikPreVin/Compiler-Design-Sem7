%option noyywrap
%{
#include "parser.tab.h"
%}

%%
"int" {return INT;}
"float" {return FLOAT;}
"char" {return CHAR;}

"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}

"<=" { return LE;}
">=" { return GE;}
"==" { return EQ;}
"!=" { return NE;}
"&&" { return AND;}
"||" { return OR;}

[a-zA-Z_][a-zA-Z_0-9]* {return ID;}
[0-9]+ {return NUMBER;}
[ \t\r\n]+ ;
[(){},;=!<>+*/-] {return yytext[0];}
. {return yytext[0];}

%%
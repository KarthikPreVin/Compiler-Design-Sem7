%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "y.tab.h"

/* Phase 1 : every token is listed together with its class */
static void show(const char *kind)
{
    printf("%s - %s\n", yytext, kind);
}

static void lexError(const char *msg)
{
    printf("Lexical error at line %d: %s\n", yylineno, msg);
    exit(1);
}
%}

%option noyywrap nounput noinput yylineno
%x COMMENT

DIGIT   [0-9]
LETTER  [a-zA-Z_]

%%

"//".*                  { /* single line comment */ }
"/*"                    { BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { }
<COMMENT>.              { }
<COMMENT><<EOF>>        { lexError("unterminated comment"); }

"class"                 { show("keyword");  return CLASS; }
"public"                { show("keyword");  return PUBLIC; }
"static"                { show("keyword");  return STATIC; }
"void"                  { show("keyword");  return VOID; }
"int"                   { show("keyword");  return INT; }
"if"                    { show("keyword");  return IF; }
"else"                  { show("keyword");  return ELSE; }
"while"                 { show("keyword");  return WHILE; }
"String"                { show("predefined class"); return STRINGKW; }
"main"                  { show("identifier"); return MAIN; }
"System.out.println"    { show("function call"); return PRINTLN; }

{LETTER}({LETTER}|{DIGIT})*  { show("identifier");
                               yylval.str = strdup(yytext); return ID; }

{DIGIT}+                { if (strlen(yytext) > 10 || atoll(yytext) > INT_MAX)
                              lexError("integer constant too large");
                          show("integer constant");
                          yylval.str = strdup(yytext); return NUM; }

\"[^"\n]*\"             { show("string constant");
                          yylval.str = strdup(yytext); return STR; }
\"[^"\n]*               { lexError("unterminated string"); }

"<="|">="|"=="|"!="|"<"|">"  { show("relational operator");
                               yylval.str = strdup(yytext); return RELOP; }
"**"|"^"                { show("arithmetic operator (power)"); return POW; }
"="                     { show("assignment operator"); return '='; }
[+\-*/%]                { show("arithmetic operator"); return yytext[0]; }
[(){}\[\];,]            { show("special character"); return yytext[0]; }

[ \t\r\n]+              { /* skip white space */ }
.                       { char m[40];
                          sprintf(m, "unknown character '%s'", yytext);
                          lexError(m); }

%%

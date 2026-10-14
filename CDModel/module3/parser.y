%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(const char*s);

int tempcount=0;
int nextlabel=100;

char *newtemp(){
    char buffer[32];
    snprintf(buffer,sizeof(buffer),"t%d",++tempcount);
    return strdup(buffer);
}
%}
%union{
    char *str;
}
%token <str> ID NUMBER
%token ASSIGN AND OR LE EQ GE NE

%type <str> expression term factor
%type <str> bool_expr bool_and relation relop

%start input
%%
input : assignment;
assignment : ID ASSIGN expression
{
    printf("%s=%s\n",$1,$3);
} 
|
ID ASSIGN bool_expr
{
    printf("%d: %s=%s\n",nextlabel++,$1,$3);
}
;
expression : expression '+' term
{
    char*t=newtemp();
    printf("%s=%s+%s\n",t,$1,$3);
    $$=t;
}
|
expression '-' term
{
    char*t=newtemp();
    printf("%s=%s-%s\n",t,$1,$3);
    $$=t;
}
|
term {$$=$1;}
;
term : term '*' factor
{
    char*t=newtemp();
    printf("%s=%s*%s\n",t,$1,$3);
    $$=t;
}
|
term '/' factor
{
    char*t=newtemp();
    printf("%s=%s/%s\n",t,$1,$3);
    $$=t;
}
|
factor {$$=$1;}
;
factor : '-' factor
{
    char*t=newtemp();
    printf("%s=-%s\n",t,$2);
    $$=t;
}
|
'('expression')' {$$=$2;}
|
ID {$$=$1;}
|
NUMBER {$$=$1;}
;
bool_expr : bool_expr OR bool_and
{
    char*t=newtemp();
    printf("%d: %s=%s or %s\n",nextlabel++,t,$1,$3);
    $$=t;
}
|
bool_and {$$=$1;}
;
bool_and : bool_and AND relation
{
    char*t=newtemp();
    printf("%d: %s=%s and %s\n",nextlabel++,t,$1,$3);
    $$=t;
}
|
relation {$$=$1;}
;
relation : expression relop expression
{
    char*t=newtemp();
    int base=nextlabel;
    printf("%d:if %s%s%s goto %d\n",base,$1,$2,$3,base+3);
    printf("%d:if %s=0\n",base+1,t);
    printf("%d:goto %d\n",base+2,base+4);
    printf("%d:if %s=1\n",base+3,t);
    nextlabel=base+4;
    $$=t;
}
;
relop
    : '<'  { $$ = strdup("<");  }
    | '>'  { $$ = strdup(">");  }
    | LE   { $$ = strdup("<="); }
    | GE   { $$ = strdup(">="); }
    | EQ   { $$ = strdup("=="); }
    | NE   { $$ = strdup("!="); }
;
%%
int yyerror(const char*s){
    fprintf(stderr,"Syntax error: %s\n",s);
    return 0;
}
int main(){
    return yyparse();
}



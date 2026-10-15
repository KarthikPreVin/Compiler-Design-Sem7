%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
int count=1;

char *newtemp(){
    char s[20];
    sprintf(s,"t%d",count++);
    return strdup(s);
}
%}

%union {
    char *str;
}

%token INT
%token <str> ID NUM
%type <str> expr term factor

%start input

%%
input:
      | input stmt
      ;

stmt:
      INT idlist ';'
    | ID '=' expr ';' {
          printf("%s = %s\n",$1,$3);
      }
    ;

idlist:
      ID
    | idlist ',' ID
    ;

expr:
      expr '+' term {
          char *t=newtemp();
          printf("%s = %s + %s\n",t,$1,$3);
          $$=t;
      }
    | expr '-' term {
          char *t=newtemp();
          printf("%s = %s - %s\n",t,$1,$3);
          $$=t;
      }
    | term {
          $$=$1;
      }
    ;

term:
      term '*' factor {
          char *t=newtemp();
          printf("%s = %s * %s\n",t,$1,$3);
          $$=t;
      }
    | term '/' factor {
          char *t=newtemp();
          printf("%s = %s / %s\n",t,$1,$3);
          $$=t;
      }
    | factor {
          $$=$1;
      }
    ;

factor:
      ID {
          $$=$1;
      }
    | NUM {
          $$=$1;
      }
    | '(' expr ')' {
          $$=$2;
      }
    ;
%%

int yyerror(char *s){
    fprintf(stderr,"Invalid syntax\n");
    return 0;
}

int main(){
    yyparse();
    return 0;
}
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
int labelcount=1;
int tempcount=1;

char *newtemp(){
    char s[20];
    sprintf(s,"t%d",tempcount++);
    return strdup(s);
}

int newlabel(){
    return labelcount++;
}
%}

%union {
    char *str;
}

%token INT AND OR
%token <str> ID NUM RELOP
%type <str> bool_expr bool_and relation expr term factor

%left OR
%left AND
%start input

%%
input:
      | input stmt
      ;

stmt:
      INT idlist ';'
    | ID '=' bool_expr ';' {
          printf("%s = %s\n",$1,$3);
      }
    ;

idlist:
      ID
    | idlist ',' ID
    ;

bool_expr:
      bool_expr OR bool_and {
          char *t=newtemp();
          printf("%s = %s or %s\n",t,$1,$3);
          $$=t;
      }
    | bool_and {
          $$=$1;
      }
    ;

bool_and:
      bool_and AND relation {
          char *t=newtemp();
          printf("%s = %s and %s\n",t,$1,$3);
          $$=t;
      }
    | relation {
          $$=$1;
      }
    ;

relation:
      expr RELOP expr {
          char *t=newtemp();
          int yes=newlabel();
          int end=newlabel();

          printf("if %s %s %s goto L%d\n",$1,$2,$3,yes);
          printf("%s = 0\n",t);
          printf("goto L%d\n",end);
          printf("L%d:\n",yes);
          printf("%s = 1\n",t);
          printf("L%d:\n",end);

          $$=t;
      }
    | expr {
          $$=$1;
      }
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
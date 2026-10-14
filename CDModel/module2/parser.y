%{
#include<stdio.h>
int yylex(void);
void yyerror(const char*s);
%}

%define parse.error detailed

%token ID NUMBER INT FLOAT CHAR
%token IF ELSE WHILE
%token LE EQ GE NE AND OR

%nonassoc IFX
%nonassoc ELSE

%%
input : statement_list;

statement_list : statement_list statement | statement;

statement : declaration | ID '=' expression ';' | IF '('condition')' statement | IF '('condition')' statement ELSE statement | WHILE '('condition')' statement | '{'statement_list'}';

declaration : type identifier_list ';' ;

type : INT | FLOAT | CHAR ;

identifier_list : ID | identifier_list ',' ID ;

condition : condition OR condition_and | condition_and ;

condition_and : condition_and AND condition_not | condition_not ;

condition_not : '!' condition_not | '('condition')'| expression relop expression ;

relop : '<' | '>' | LE | GE | NE | EQ ;

expression : expression '+' term | expression '-' term | term ;

term : term '*' factor | term '/' factor | factor ;

factor : '('expression')' | ID | NUMBER ;

%%

void yyerror(const char*s){
    fprintf(stderr,"Syntax error: %s\n",s);
}

int main(void){
    if(yyparse()==0){
        printf("Successfully parsed");
        return 0;
    }
    else{
        printf("Not Successfully parsed there is error");
        return 1;
    }
}


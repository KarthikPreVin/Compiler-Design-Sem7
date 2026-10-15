#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int isnum(const char *s){
    if(*s=='-' && *(s+1)) s++;
    if(!*s) return 0;

    while(*s){
        if(!isdigit((unsigned char)*s++)) return 0;
    }

    return 1;
}

void optimize(char *line){
    char dest[50],left[50],op[10],right[50];
    int a,b,result;

    int count=sscanf(line," %49[^= ] = %49s %9s %49s",
                     dest,left,op,right);

    if(count!=4) return;

    /* Constant folding */
    if(isnum(left) && isnum(right)){
        a=atoi(left);
        b=atoi(right);

        if(!strcmp(op,"+")) result=a+b;
        else if(!strcmp(op,"-")) result=a-b;
        else if(!strcmp(op,"*")) result=a*b;
        else if(!strcmp(op,"/") && b!=0 && a%b==0)
            result=a/b;
        else return;

        sprintf(line,"%s = %d",dest,result);
    }

    /* Algebraic simplification */
    else if(!strcmp(op,"+") && !strcmp(right,"0"))
        sprintf(line,"%s = %s",dest,left);
    else if(!strcmp(op,"+") && !strcmp(left,"0"))
        sprintf(line,"%s = %s",dest,right);
    else if(!strcmp(op,"-") && !strcmp(right,"0"))
        sprintf(line,"%s = %s",dest,left);
    else if(!strcmp(op,"*") && !strcmp(right,"1"))
        sprintf(line,"%s = %s",dest,left);
    else if(!strcmp(op,"*") && !strcmp(left,"1"))
        sprintf(line,"%s = %s",dest,right);
    else if(!strcmp(op,"*") &&
            (!strcmp(left,"0") || !strcmp(right,"0")))
        sprintf(line,"%s = 0",dest);
    else if(!strcmp(op,"/") && !strcmp(right,"1"))
        sprintf(line,"%s = %s",dest,left);

    /* Strength reduction */
    else if(!strcmp(op,"*") && !strcmp(right,"2"))
        sprintf(line,"%s = %s + %s",dest,left,left);
    else if(!strcmp(op,"*") && !strcmp(right,"4"))
        sprintf(line,"%s = %s << 2",dest,left);
    else if(!strcmp(op,"*") && !strcmp(right,"8"))
        sprintf(line,"%s = %s << 3",dest,left);
}

int main(){
    char line[250];

    printf("Enter TAC instructions, one per line.\n");
    printf("Enter END to finish:\n");

    while(fgets(line,sizeof(line),stdin)){
        line[strcspn(line,"\n")]='\0';

        if(!strcmp(line,"END")) break;

        if(*line){
            optimize(line);
            printf("%s\n",line);
        }
    }

    return 0;
}
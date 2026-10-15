#include <stdio.h>
#include <string.h>

int main(){
    char line[100],a[50],b[50],c[50],op[10];

    while(fgets(line,sizeof(line),stdin)){

        if(sscanf(line,"%49s = %49s %9s %49s",a,b,op,c)==4){
            printf("MOV R0, %s\n",b);

            if(strcmp(op,"+")==0) printf("ADD R0, %s\n",c);
            else if(strcmp(op,"-")==0) printf("SUB R0, %s\n",c);
            else if(strcmp(op,"*")==0) printf("MUL R0, %s\n",c);
            else if(strcmp(op,"/")==0) printf("DIV R0, %s\n",c);
            else if(strcmp(op,"<<")==0) printf("SHL R0, %s\n",c);
            else{
                printf("Invalid operator: %s\n",op);
                continue;
            }

            printf("MOV %s, R0\n",a);
            continue;
        }

        if(sscanf(line,"%49s = %49s",a,b)==2){
            printf("MOV %s, %s\n",a,b);
            continue;
        }

        printf("Invalid TAC: %s",line);
    }

    return 0;
}
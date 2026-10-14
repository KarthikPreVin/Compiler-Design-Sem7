#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(){
    char line[100],a[50],b[50],c[50],label[50],op[10];
    char*p;
    while(fgets(line,sizeof(line),stdin)){
        printf("\n");
        if(sscanf(line," if %49s %9s %49s goto %49s",a,op,b,label)==4 ||
           sscanf(line,"if %49s %9s %49s goto %49s",a,op,b,label)==4){
            printf("CMP %s,%s\n",a,b);
            if(strcmp(op,"<")==0)printf("JLT %s\n",label);
            else if(strcmp(op,"<=")==0)printf("JLE %s\n",label);
            else if(strcmp(op,">")==0)printf("JGT %s\n",label);
            else if(strcmp(op,">=")==0)printf("JGE %s\n",label);
            else if(strcmp(op,"==")==0)printf("JE %s\n",label);
            else if(strcmp(op,"!=")==0)printf("JNE %s\n",label);
            else printf("Invalid Condition\n");
            continue;
        }
        if(sscanf(line,"goto %49s",label)==1 || sscanf(line," goto %49s",label)==1 ){
            printf("JMP %s\n",label);
            continue;
        }
        p=strchr(line,':');
        if(p && (p[1]=='\0' || p[1] =='\n')){
            *p='\0';
            printf("%s:\n",line);
            continue;
        }
         if(sscanf(line," %49[^= ] = %49s %9s %49s",a,b,op,c)==4 || sscanf(line," %49[^= ]=%49s %9s %49s",a,b,op,c)==4){
            printf("MOV R0,%s\n",b);
            if(strcmp(op,"+")==0)printf("ADD R0,%s\n",c);
            else if(strcmp(op,"-")==0)printf("SUB R0,%s\n",c);
            else if(strcmp(op,"*")==0)printf("MUL R0,%s\n",c);
            else if(strcmp(op,"/")==0)printf("DIV R0,%s\n",c);
            else if(strcmp(op,"AND")==0)printf("AND R0,%s\n",c);
            else if(strcmp(op,"OR")==0)printf("OR R0,%s\n",c);
            else{
                printf("Invalid operator\n");
                continue;
            }
            printf("MOV %s,R0\n",a);
            continue;
        }
         if(sscanf(line,"%49[^= ] = %49s",a,b)==2 || sscanf(line,"%49[^= ]=%49s",a,b)==2){
            printf("MOV %s,%s\n",a,b);
            continue;
         }
         printf("Invalid TAC Given: %s\n",line);
    }
    return 0;
}
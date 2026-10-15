#include <stdio.h>
#include <string.h>

int main(){
    char line[250],dest[50],left[50],op[10],right[50];
    int target;

    while(fgets(line,sizeof(line),stdin)){
        if(sscanf(line,"if %49s %9s %49s goto L%d",
                  left,op,right,&target)==4){
            printf("CMP %s, %s\n",left,right);

            if(!strcmp(op,"<")) printf("JLT L%d\n",target);
            else if(!strcmp(op,">")) printf("JGT L%d\n",target);
            else if(!strcmp(op,"<=")) printf("JLE L%d\n",target);
            else if(!strcmp(op,">=")) printf("JGE L%d\n",target);
            else if(!strcmp(op,"==")) printf("JE L%d\n",target);
            else if(!strcmp(op,"!=")) printf("JNE L%d\n",target);

            continue;
        }

        if(sscanf(line,"goto L%d",&target)==1){
            printf("JMP L%d\n",target);
            continue;
        }

        if(sscanf(line,"L%d:",&target)==1){
            printf("L%d:\n",target);
            continue;
        }

        if(sscanf(line,"%49s = %49s %9s %49s",
                  dest,left,op,right)==4){
            if(!strcmp(op,"<") || !strcmp(op,">") ||
               !strcmp(op,"<=") || !strcmp(op,">=") ||
               !strcmp(op,"==") || !strcmp(op,"!=")){
                printf("CMP %s, %s\n",left,right);

                if(!strcmp(op,"<")) printf("SETLT R0\n");
                else if(!strcmp(op,">")) printf("SETGT R0\n");
                else if(!strcmp(op,"<=")) printf("SETLE R0\n");
                else if(!strcmp(op,">=")) printf("SETGE R0\n");
                else if(!strcmp(op,"==")) printf("SETE R0\n");
                else printf("SETNE R0\n");

                printf("MOV %s, R0\n",dest);
            }
            else{
                printf("MOV R0, %s\n",left);

                if(!strcmp(op,"+")) printf("ADD R0, %s\n",right);
                else if(!strcmp(op,"-")) printf("SUB R0, %s\n",right);
                else if(!strcmp(op,"*")) printf("MUL R0, %s\n",right);
                else if(!strcmp(op,"/")) printf("DIV R0, %s\n",right);
                else if(!strcmp(op,"and")) printf("AND R0, %s\n",right);
                else if(!strcmp(op,"or")) printf("OR R0, %s\n",right);
                else if(!strcmp(op,"<<")) printf("SHL R0, %s\n",right);

                printf("MOV %s, R0\n",dest);
            }

            continue;
        }

        if(sscanf(line,"%49s = %49s",dest,left)==2){
            printf("MOV %s, %s\n",dest,left);
            continue;
        }

        printf("Invalid TAC: %s",line);
    }

    return 0;
}
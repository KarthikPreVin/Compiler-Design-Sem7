#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char code [100][256];
int n=0;

int isnum(const char*s){
    if(*s=='-' && *(s+1)) s++;
    if(!*s) return 0;
    while(*s){
        if(!isdigit((unsigned char)*s++)) return 0;
    } 
    return 1;
}

void optimize(char*line){
    char dest[50],left[50],op[10],right[50];
    int a,b,result;
    int count=sscanf(line," %49[^= ] = %49s %9s %49s",dest,left,op,right);
    if(count!=4)return;
    if(isnum(left) && isnum(right)){
        a=atoi(left);
        b=atoi(right);
        if(!strcmp(op,"+"))result=a+b;
        else if(!strcmp(op,"-")) result=a-b;
        else if(!strcmp(op,"*")) result=a*b;
        else if(!strcmp(op,"/") && b!=0 && a%b==0)
            result=a/b;
        else return;
        sprintf(line,"%s=%d",dest,result);
    }
    else if(!strcmp(op,"+") && !strcmp(right,"0")) sprintf(line,"%s=%s",dest,left);
    else if(!strcmp(op,"+") && !strcmp(left,"0")) sprintf(line,"%s = %s",dest,right);
    else if(!strcmp(op,"-") && !strcmp(right,"0")) sprintf(line,"%s = %s",dest,left);
    else if(!strcmp(op,"*") && !strcmp(right,"1"))sprintf(line,"%s = %s",dest,left);
    else if(!strcmp(op,"*") && !strcmp(left,"1")) sprintf(line,"%s = %s",dest,right);
    else if(!strcmp(op,"*") && (!strcmp(left,"0") || !strcmp(right,"0"))) sprintf(line,"%s = 0",dest);
    else if(!strcmp(op,"/") && !strcmp(right,"1")) sprintf(line,"%s = %s",dest,left);

    else if(!strcmp(op,"*") && !strcmp(right,"2")) sprintf(line,"%s=%s+%s",dest,left,left);
    else if(!strcmp(op,"*") && !strcmp(right,"4")) sprintf(line,"%s=%s<<2",dest,left);
    else if(!strcmp(op,"*") && !strcmp(right,"8")) sprintf(line,"%s=%s<<3",dest,left);
}
void removedeadcode(){
    int used,changed;
    do{
        changed=0;
        for(int i=0;i<n;i++){
            char dest[50],rhs[200];
            int count2=sscanf(code[i]," %49[^= ] = %199[^\n]",dest,rhs);
            if(count2!=2) continue;
            if(dest[0]!='t' || !isdigit((unsigned char)dest[1]))continue;
            used=0;
            for(int j=0;j<n;j++){
                if(i==j)continue;
                char *p=strchr(code[j],'=');
                char *start=p ? p+1 : code[j];
                char *q=start;
                while((q=(strstr(q,dest)))!=NULL){
                    int before=(q==start || (!isalnum((unsigned char)q[-1])) && q[-1]!='_');
                    int after=!(isalnum((unsigned char)q[strlen(dest)]) && q[strlen(dest)]=='_');
                    if(before && after) {
                        used=1;
                        break;
                    }
                    q++;
                }
                if(used)break;
                }
                if(!used) {
                code[i][0]='\0';
                changed=1;
            }

        }

    }while(changed);
}

int main(){
    char line[250];
    printf("Enter TAC instructions, one per line.\n");
    printf("Enter END to finish:\n");
    while(fgets(line,sizeof(line),stdin)){
        line[strcspn(line,"\n")]='\0';
        if(!strcmp(line,"END"))break;
        if(*line && n<100){
            strcpy(code[n],line);
            optimize(code[n]);
            n++;
        }
    }
    removedeadcode();

    for(int i=0;i<n;i++)
        if(code[i][0])
            printf("%s\n",code[i]);

    return 0;
}
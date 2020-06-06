%{
#include <stdio.h>
#include <string.h>

char mem[100];
char buffer[1000];
%}

%union{ char * texto;}

%token <texto> palavra;
%token <texto> subitem;
%token <texto> traducao;
%token <texto> ID;

%type  <texto> TERMO;
%type  <texto> TRADUCAO;
%type  <texto> SUBITEM;
%type  <texto> L_SUBITEM;


%%

LISTA_PALAVRAS: PALAVRA                  {printf("\n");}
              | LISTA_PALAVRAS PALAVRA   {printf("\n");}
              ;
PALAVRA: TERMO TRADUCAO   {printf("%s%s", $1, $2);}  
    |    TERMO ':' TRADUCAO L_SUBITEM {printf("%s%s\n%s",$1,$3, $4);}  
    |    TERMO ':' L_SUBITEM      {printf("%s",$3);}
               ;
TRADUCAO: traducao                  {sprintf(buffer,"PT %s\n",$1);$$=strdup(buffer);}
        | TRADUCAO ',' traducao     {sprintf(buffer,"%sPT %s\n",$1,$3);$$=strdup(buffer);}
        | TRADUCAO ';' traducao     {sprintf(buffer,"%sPT %s\n",$1,$3);$$=strdup(buffer);}
        ;
L_SUBITEM: SUBITEM                  {$$ = strdup($1);}
        |  L_SUBITEM SUBITEM        {sprintf(buffer,"%s\n%s",$1,$2);$$=strdup(buffer);}
        ;
SUBITEM: subitem '-' TRADUCAO       {sprintf(buffer,"EN %s %s\n+base %s:\n%s",$1,mem,mem,$3);$$=strdup(buffer);}
    | '-' subitem TRADUCAO          {sprintf(buffer,"EN %s %s\n+base %s:\n%s",mem,$2,mem,$3);$$=strdup(buffer);}
    | subitem '-' subitem TRADUCAO  {sprintf(buffer,"EN %s %s %s\n+base %s:\n%s",$1,mem,$3,mem,$4);$$=strdup(buffer);}
    ;
TERMO: palavra      {strcpy(mem,$1); sprintf(buffer,"EN %s\n",$1);$$=strdup(buffer);}
    ;
%%

#include "lex.yy.c"

int yyerror(char *s) { 
    printf("ERRO: %s\n",s); 
    return(0); 
}

int main(){
    yyparse();
    return 0;
}
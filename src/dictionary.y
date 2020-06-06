%{
#include <stdio.h>
#include <string.h>

char mem[100];
char aux[300];
%}

%union{ char * texto;}

%token <texto> palavra;
%token <texto> subitem;
%token <texto> traducao;

%type  <texto> TERMO;
%type  <texto> TRADUCAO;
%type  <texto> SUBITEM;



%%

LISTA_PALAVRAS: PALAVRA                  {printf("\n");}
              | LISTA_PALAVRAS PALAVRA   {printf("\n");}
              ;
PALAVRA: TERMO TRADUCAO   {printf("%s%s", $1, $2);}  
    |    TERMO ':' TRADUCAO SUBITEM {printf("%s%s\n%s",$1,$3,$4);}  
    |    TERMO ':' SUBITEM      {printf("%s", $3);}
               ;
TRADUCAO: traducao                  {sprintf(aux,"PT %s\n",$1);$$=strdup(aux);}
        | TRADUCAO ',' traducao     {sprintf(aux,"%sPT %s\n",$1,$3);$$=strdup(aux);}
        | TRADUCAO ';' traducao     {sprintf(aux,"%sPT %s\n",$1,$3);$$=strdup(aux);}
        ;
SUBITEM: subitem '-' TRADUCAO       {sprintf(aux,"EN %s %s\n+base %s:\n%s",$1,mem,mem,$3);$$=strdup(aux);}
    | '-' subitem TRADUCAO          {sprintf(aux,"EN %s %s\n+base %s:\n%s",mem,$2,mem,$3);$$=strdup(aux);}
    | subitem '-' subitem TRADUCAO  {sprintf(aux,"EN %s %s %s\n+base %s:\n%s",$1,mem,$3,mem,$4);$$=strdup(aux);}
    ;
TERMO: palavra      {strcpy(mem,$1); sprintf(aux,"EN %s\n",$1);$$=strdup(aux);}
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
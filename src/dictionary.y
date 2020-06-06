%{
#include <stdio.h>
#include <string.h>

char mem[100];
char buffer[1000];

extern int yylineno;

%}

%union{ char * texto; int linha;}

%token <texto> palavra;
%token <texto> subitem;
%token <texto> traducao;
%token <texto> id;
%token SUBERROR;

%type  <texto> TERMO;
%type  <texto> TRADUCAO;
%type  <texto> SUBITEM;
%type  <texto> L_SUBITEM;


%%


DICIONARIO: SESSAO
          | DICIONARIO SESSAO
          ;

SESSAO: ID  LISTA_PALAVRAS   {printf("------------------\n");}
    ;
ID: id {printf("Seção: %s\n\n", $1);}
LISTA_PALAVRAS: PALAVRA                  {printf("\n");}
              | LISTA_PALAVRAS PALAVRA   {printf("\n");}
              ;
PALAVRA: TERMO TRADUCAO   {printf("%s%s", $1, $2);}  
    |    TERMO ':' TRADUCAO  L_SUBITEM  {printf("%s%s\n%s",$1,$3,$4);}  
    |    TERMO ':'  L_SUBITEM      {printf("%s",$3);}
    |   error PALAVRA
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
    printf("--\nErro sintático na linha %d\n--\n\n",yylineno); 
    return(0); 
}

int main(){
    yyparse();
    return 0;
}
%{
#include <stdio.h>
#include <string.h>
%}

%union{ char * texto;}

%token <texto> palavra;
%token <texto> traducao;
%type  <texto> TRADUCAO;


%%

LISTA_PALAVRAS: PALAVRA '\n'
              | LISTA_PALAVRAS PALAVRA
              ;
PALAVRA: TERMO TRADUCAO     {printf("\n");}
               ;
TRADUCAO: ITEM 
        | TRADUCAO ',' ITEM
        | TRADUCAO ';' ITEM
        ;
TERMO: palavra      {printf("EN %s\n", $1);}
    ;
ITEM: palavra    {printf("PT %s\n", $1);}
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
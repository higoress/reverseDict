%{
#include <stdio.h>
#include <string.h>

char mem[100];
%}

%union{ char * texto;}

%token <texto> palavra;
%token <texto> subitem;
%token <texto> traducao;

%type  <texto> TERMO;



%%

LISTA_PALAVRAS: PALAVRA
              | LISTA_PALAVRAS PALAVRA
              ;
PALAVRA: TERMO TRADUCAO   {printf("EN %s\n", $1);}  
    |    TERMO ':' TRADUCAO SUBITEM {printf("EN %s\n", $1);}  
    |    TERMO ':' SUBITEM
               ;
TRADUCAO: ITEM 
        | TRADUCAO ',' ITEM
        | TRADUCAO ';' ITEM
        ;
SUBITEM: TESTE '-' TRADUCAO
    ;
TERMO: palavra      {strcpy(mem,$1); $$= strdup($1);}
    ;
ITEM: traducao    {printf("PT %s\n", $1);}
    ;
TESTE: subitem    {printf("EN %s %s\n", $1, mem);}
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
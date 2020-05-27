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
PALAVRA: palavra TRADUCAO {printf("EN %s\nPT %s\n", $1, $2);}
               ;
TRADUCAO: palavra {$$ = strdup($1);};
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
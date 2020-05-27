%{
#include "y.tab.h"
%}
%option noyywrap

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()]
texto      {letra}|{simbolos}

%x DICT WORD

%%
.|\n                                ;                           /* consome tudo sem retornar até encontrar o __BEGIN__*/
__BEGIN__                           {BEGIN(DICT);}              /* inicializa o modo reconhecedor do dicionário*/
<DICT>[ \n]*/{texto}                {BEGIN(WORD);}              /* consome espaços e quebras de linha desnecessários até que encontre  o primeiro caracter contido em texto.*/
<WORD>{texto}+(" "{texto}+)*        {yylval.texto=strdup(yytext);return(palavra);} /* reconhece tokens de palavras, permitindo apenas um espaço entre as strings*/
<WORD>[ \t]                         ;                           /* consome espaços e tabulações desncessárias*/
<WORD>.|\n                          {return yytext[0];}         /* retorna todos os tokens de símbolo único, pode gerar erros de sintaxe, mas esse comportamento é desejado.*/
%%
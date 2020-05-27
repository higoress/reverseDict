%{
#include "y.tab.h"
%}
%option noyywrap

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()]
texto      {letra}|{simbolos}

%x DICT

%%
{texto}+(" "{texto}+)*         {yylval.texto=strdup(yytext);return(palavra);}
[ \t]   ;
.|\n           {return yytext[0];}
%%
%{
#include "y.tab.h"
%}
%option noyywrap

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()] 

%x DICT

%%
[a-z]+              {yylval.texto=strdup(yytext);return(palavra);}
[ \t]   ;
.|\n           {return yytext[0];}
%%

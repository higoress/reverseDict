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
.|\n    ;
__BEGIN__   {BEGIN(DICT);}
<DICT>[ \n]*/{texto}    {BEGIN(WORD);}
<WORD>{texto}+(" "{texto}+)*         {yylval.texto=strdup(yytext);return(palavra);}
<WORD>[ \t]   ;
<WORD>.|\n           {return yytext[0];}
%%
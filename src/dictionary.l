%{
#include "y.tab.h"
%}
%option noyywrap
%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()/']
texto      {letra}|{simbolos}

%x DICT WORD

%%
.|\n                                        {;}                                                 /* consome tudo sem retornar até encontrar o __BEGIN__*/
__BEGIN__                                   {BEGIN(DICT);}                                      /* inicializa o modo reconhecedor do dicionário*/
<DICT>^{letra}                              {yylval.texto=strdup(yytext);return(id);}           /* reconhece o token ID, que marca o inicio de uma sessão*/
<DICT>^{letra}{texto}+(" "{texto}+)*        {yylval.texto=strdup(yytext);return(palavra);}      /* reconhece tokens de palavras, permitindo apenas um espaço entre as strings*/
<DICT>^" "/({letra}|-)                      {BEGIN(WORD);}                                      /* quando encontra subitens com a formatação correta (2 espaços em braco no inicio da linha) inicia o modo WORD*/
<DICT>{letra}{texto}*(" "{texto}+)*         {yylval.texto=strdup(yytext);return(traducao);}     /* reconhece tokens do tipo tradução */
<DICT>[ \t\n]                               {;}                                                 /* consome espaços e tabulações desncessárias*/
<DICT>.                                     {return(yytext[0]);}                                /* retorna todos os tokens de símbolo único, pode gerar erros de sintaxe, mas esse comportamento é desejado.*/
<WORD>-                                     {return(yytext[0]);}                                /* identifica o token to tipo hífen, que faz parte da estrutura dos subitens*/
<WORD>" "                                   {;}                                                 /* consome espaços em branco únicos entre as palavras*/
<WORD>{letra}{texto}+(" "{letra}{texto}+)*  {yylval.texto=strdup(yytext);return(subitem);}      /* reconhece e retorna subitens de termos */
<WORD>[ ]{2}                                {BEGIN(DICT);}                                      /* quando encontra dois espaços em branco seguidos, volta ao comportamente normal */
<WORD>.                                     {return(yytext[0]);}                                /* retorna erros de sintaxe, mas esse comportamento é desejado*/
%%
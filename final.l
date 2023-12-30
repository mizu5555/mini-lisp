%{
#include "final.tab.h"
%}

/* Preliminary Definitions */
separator  [\t|\n|\r| ]+
letter     [a-z]
digit      [0-9]

/* Token Definitions */
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|-)*
bool_val   #[t|f]

%%

"print-num"  {return(PRINT_NUM);}
"print-bool" {return(PRINT_BOOL);}

"("        {return yytext[0];} 
")"        {return yytext[0];}

"+"        {return yytext[0];}
"-"        {return yytext[0];}
"*"        {return yytext[0];}
"/"        {return yytext[0];}
"mod"      {return MOD;}

">"        {return yytext[0];}
"<"        {return yytext[0];}
"="        {return yytext[0];}

"and"      {return AND;}
"or"       {return OR;}
"not"      {return NOT;}

"define"   {yylval.s.str =strdup(yytext);return DEFINE;}
"if"       {return IF;}

{number}    {yylval.s.ival = atoi(yytext);  yylval.s.type='n'; return NUMBER;}
{id}        {yylval.s.str = strdup(yytext); yylval.s.type='s'; return ID;} 
{bool_val}  {yylval.s.str = strdup(yytext); yylval.s.type='b'; 
             if(yytext[1] == 't'){yylval.s.ival=1;}
             else{yylval.s.ival=0;}
             return BOOL;}
{separator} {}
.           {return yytext[0];}

%%
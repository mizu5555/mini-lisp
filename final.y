%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *message);

struct stack{
		char* name;
		char type;
		int value;
	}; 
	struct stack def_var[1000];
	int i = 0;

%}

%union{
	struct{
		int ival;    //number
		char type;   //b:bool n:number
		char* str;   //id
	}s;
}

%token<s> NUMBER ID BOOL DEFINE IF MOD AND OR NOT PRINT_NUM PRINT_BOOL

%type<s> PROGRAM STMT PRINT_STMT EXP 
%type<s> NUM_OP PLUS PLUS_EXP MINUS MULTIPLY MUL_EXP DIVIDE MODULUS 
%type<s> GREATER SMALLER EQUAL EQ_EXP LOGICAL_OP AND_OP AND_EXP OR_OP OR_EXP NOT_OP
%type<s> IF_EXP TEST_EXP THEN_EXP ELSE_EXP DEF_STMT VARIABLE


%left NOT '='
%left '<' '>'
%left '+' '-'
%left '*' '/' MOD
%left AND OR
%left '(' ')'

%%
/* Program */
PROGRAM : STMT STMTS
        ;

STMTS 	: STMT STMTS
		|
        ;

STMT    : EXP
		| DEF_STMT
		| PRINT_STMT
        ;

/* Print */
PRINT_STMT : '(' PRINT_NUM EXP ')'  {printf("%d\n", $3.ival);}
		   | '(' PRINT_BOOL EXP ')' {if($3.ival==1){
                                        printf("#t\n");}
                                     else{
                                        printf("#f\n");}}
            ;

/* Expression */
EXP	    : BOOL               {$$.ival=$1.ival;$$.type=$1.type;}
		| NUMBER             {$$.ival=$1.ival;$$.type=$1.type;}
		| VARIABLE           {$$.ival=$1.ival;$$.type=$1.type;/*printf("VAR%d:%d\n", i,$1.ival);*/}
        | '(' NUM_OP ')'     {$$.ival=$2.ival;$$.type=$2.type;}
		| '(' LOGICAL_OP ')' {$$.ival=$2.ival;$$.type=$2.type;}
        //| FUNCTION         {$$.ival=$1.ival;$$.type=$1.type;}
        //| FUNCTION_CALL    {$$.ival=$1.ival;$$.type=$1.type;}
        | '(' IF_EXP ')'     {$$.ival=$2.ival;$$.type=$2.type;}
        ;

/* Numeric operation */

NUM_OP  : PLUS               {$$.ival=$1.ival;$$.type=$1.type;}
		| MINUS              {$$.ival=$1.ival;$$.type=$1.type;}
		| MULTIPLY           {$$.ival=$1.ival;$$.type=$1.type;}
		| DIVIDE             {$$.ival=$1.ival;$$.type=$1.type;}
		| MODULUS            {$$.ival=$1.ival;$$.type=$1.type;}
		| GREATER            {$$.ival=$1.ival;$$.type=$1.type;}
		| SMALLER            {$$.ival=$1.ival;$$.type=$1.type;}
		| EQUAL              {$$.ival=$1.ival;$$.type=$1.type;}
;
PLUS    : '+' EXP PLUS_EXP  {if($2.type!=$3.type){yyerror("type error");return 0;}
                             $$.ival=$2.ival+$3.ival;$$.type=$2.type;}
        ;
PLUS_EXP: EXP PLUS_EXP      {if($1.type!=$2.type){yyerror("type error");return 0;}
                             $$.ival=$1.ival+$2.ival;$$.type=$1.type;}
		| EXP               {$$.ival=$1.ival;$$.type=$1.type;}
        ;
MINUS   : '-' EXP EXP       {if($2.type!=$3.type){yyerror("type error");return 0;}
                             $$.ival=$2.ival-$3.ival;$$.type=$2.type;
                             /*printf("MINUS: %d-%d\n", $2.ival,$3.ival);*/}
        ;
MULTIPLY: '*' EXP MUL_EXP   {if($2.type!=$3.type){yyerror("type error");return 0;}
                             $$.ival=$2.ival*$3.ival;$$.type=$2.type;}
        ;
MUL_EXP : EXP MUL_EXP       {if($1.type!=$2.type){yyerror("type error");return 0;}
                             $$.ival=$1.ival*$2.ival;$$.type=$1.type;}
		| EXP               {$$.ival=$1.ival;$$.type=$1.type;}
        ;
DIVIDE  : '/' EXP EXP       {if($2.type!=$3.type){yyerror("type error");return 0;}
                             $$.ival=$2.ival/$3.ival;$$.type=$2.type;}
        ;
MODULUS : MOD EXP EXP       {if($2.type!=$3.type){yyerror("type error");return 0;}
                             $$.ival=$2.ival%$3.ival;$$.type=$2.type;}
        ;
GREATER : '>' EXP EXP       {if($2.type!=$3.type){yyerror("type error");return 0;}
                             if($2.ival>$3.ival){$$.ival=1;}
							 else{$$.ival=0;}$$.type=$2.type;}
        ;
SMALLER : '<' EXP EXP       {if($2.type!=$3.type){yyerror("type error");return 0;}
                             if($2.ival<$3.ival){$$.ival=1;}
							 else{$$.ival=0;}$$.type=$2.type;}
        ;
EQUAL   : '=' EXP EQ_EXP    {if($2.type!=$3.type){yyerror("type error");return 0;}
                             if($2.ival==$3.ival){$$.ival=1;}
							 else{$$.ival=0;}
                             $$.type=$2.type;}
        ;

/* Logic operation */

EQ_EXP  : EXP EQ_EXP                    {if($2.type!=$1.type){yyerror("type error");return 0;}
                                         if($1.ival==$2.ival){$$.ival=$1.ival;}
					                     else{$$.ival=0;}$$.type=$1.type;}
		| EXP                           {$$.ival=$1.ival;$$.type=$1.type;}
        ;
LOGICAL_OP : AND_OP                     {}
           | OR_OP                      {}    
		   | NOT_OP                     {}
           ;
AND_OP  :  AND EXP AND_EXP              {if($2.type!=$3.type){yyerror("type error");return 0;}
                                         if($2.ival&$3.ival){$$.ival=1;}
                                         else{$$.ival=0;}$$.type=$2.type;}
        ;
AND_EXP : EXP AND_EXP                   {if($1.ival&$2.ival){$$.ival=1;}
                                         else{$$.ival=0;}$$.type=$1.type;}
        | EXP                           {if(!$1.ival){$$.ival=0;}
                                         else{$$.ival=1;}$$.type=$1.type;}
        ;
OR_OP   : OR EXP OR_EXP                 {if($2.type!=$3.type){yyerror("type error");return 0;}
                                         if($2.ival|$3.ival){$$.ival=1;}
                                         else{$$.ival=0;}$$.type=$2.type;}
        ;
OR_EXP  : EXP OR_EXP                    {if($1.ival|$2.ival){$$.ival=1;}
                                         else{$$.ival=0;}}
	    | EXP                           {if(!$1.ival){$$.ival=0;}
                                         else{$$.ival=1;}$$.type=$1.type;}
        ;
NOT_OP  : NOT EXP                       {if($2.type!='b'){yyerror("type error");return 0;}
                                         if($2.ival){$$.ival=0;}
                                         else{$$.ival=1;}$$.type=$2.type;}
        ;

/* Define statement */
/* Define a variable named id whose value is EXP. */
/* 用一個陣列實作堆疊，把變數(ID)跟對應的值(EXP)存入，並把EXP傳回給DEF_STMT */
DEF_STMT : '(' DEFINE ID EXP ')'        {def_var[i].name=$3.str; 
                                         def_var[i].value=$4.ival; 
                                         def_var[i].type=$4.type; 
                                         i++; 
                                         $$.ival=$4.ival;$$.type=$4.type;}
         ;
VARIABLE : ID                           {
                                            // 堆疊頂端下方
                                            int j = i-1;
                                            // 往下找到對應ID的變數
                                            while (j >= 0 && strcmp(def_var[j].name, $1.str) != 0) {j--;}
                                            if (j >= 0) {
                                                $$.ival=def_var[j].value;
                                                $$.type=def_var[j].type;
                                            } 
                                            else {
                                                yyerror("Variable not found");
                                            }
                                        };
         ;

/* Function */
/* FUN-EXP defines a function. When a function is called, bind FUN-IDsto PARAMs,
just like the define statement. If an id has been defined outside this function,
prefer the definition inside the FUN-EXP. The variable definitions inside a
function should not affect the outer scope. A FUN-CALL returns the evaluated
result of FUN-BODY Note that variables used in FUN-BODY should be bound to
PARAMs. */

/* If statement */
/* When TEST-EXP is true, returns THEN-EXP. Otherwise, returns ELSE-EXP. */
IF_EXP   : IF TEST_EXP THEN_EXP ELSE_EXP {if(!$2.ival){$$.ival=$4.ival;}
                                          else{$$.ival=$3.ival;}
                                          $$.type=$2.type;}
         ;
TEST_EXP : EXP                           {$$.ival=$1.ival;$$.type=$1.type;}
         ;
THEN_EXP : EXP                           {$$.ival=$1.ival;$$.type=$1.type;}
         ;
ELSE_EXP : EXP                           {$$.ival=$1.ival;$$.type=$1.type;}
         ;
%%

void yyerror (const char *message)
{
	printf("syntax error");
}

int main(int argc, char** argv)
{
    yyparse();
    return 0;
}

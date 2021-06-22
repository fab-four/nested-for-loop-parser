%{
#include <stdio.h>
#include <stdlib.h>
int yyerror();
int yylex();
extern FILE *yyin;
extern FILE *yyout;
%}


%token ID NUM FOR LE GE EQ NE OR AND CONTINUE BREAK RETURN DATATYPE
%right '='
%left  OR AND
%left  LE GE EQ NE LT GT
%left '+' '-'
%left '*' '/'
%left '!' '%'
%left TRUE FALSE


%%
   
S           : FOR_STMNT {printf("Accepted \n"); return 0;}

FOR_STMNT       : FOR '(' EXPR_LIST ';' CONDITIONAL_EXPR ';' EXPR_LIST ')' BODY
            ;
                       
BODY  	   :  '{' BODY '}'
           |  STMNT_LIST
           ;

STMNT_LIST : STMNT_LIST ';' STMNT
            |  STMNT
            ;

STMNT : BREAK
    |   CONTINUE
    |   RETURN
    |   EXPR_LIST ';'
    |   DECL
    ;

EXPR      : ID '=' EXPR
          | EXPR '+' EXPR
          | EXPR '-' EXPR 
          | EXPR '*' EXPR 
          | EXPR '/' EXPR 
        //   | EXPR '&' EXPR 
        //   | EXPR '|' EXPR 
        //   | EXPR '~' EXPR 
        //   | EXPR '^' EXPR 
        //   | ID '+' '+' 
        //   | ID '-' '-' 
        //   | '+' '+' ID 
        //   | '-' '-' ID 
          | EXPR '%' EXPR 
          | ID 
        //   | E2
          |
          ;

EXPR_LIST : EXPR_LIST ',' EXPR
            | EXPR
            ;

VAR_LIST : VAR_LIST ',' VAR
            |   VAR
            ;

VAR :  ID '=' EXPR
        |   ID
        ;

DECL        : DATATYPE VAR_LIST ';'
            ;
   
CONDITIONAL_EXPR : 
            // EXPR LT EXPR
            // | EXPR GT EXPR
            ;

// E2       : 
        // |EXPR LT EXPR
//          | EXPR GT EXPR
//          | EXPR LE EXPR
//          | EXPR GE EXPR
//          | EXPR EQ EXPR
//          | EXPR NE EXPR
//          | EXPR OR EXPR
//          | EXPR AND EXPR
//          | NUM
//          | TRUE
//          | FALSE
        //  |
        //  ;   
%%


int yyerror(char const *s)
{
    printf("\nyyerror  %s\n",s);
    exit(1) ;
}

int main(int argc,char **argv) {
    yyin = fopen(argv[argc-1],"r");
    yyparse();
    yyout = fopen("commi.txt", "w");  
    return 1;
} 

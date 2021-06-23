%{
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE *yyin;
    int yyerror();
    int yylex();
%}


%token    ID INT FOR RELATIONAL_OP OR AND CONTINUE BREAK RETURN DATATYPE TRUE FALSE PLUS_PLUS MINUS_MINUS STRING FLOAT COMPOUND_OP
%right    COMPOUND_OP
%right    '='
%left     OR
%left     AND
%left     '|'
%left     '^'
%left     '&'
%left     RELATIONAL_OP
%left     LEFT_SHIFT RIGHT_SHIFT
%left     '+' '-'
%left     '*' '/' '%'
%left     '!' '~'
%nonassoc UMINUS


%%

S           :  FOR_STMNT {printf("Valid Syntax\n"); return 0;}

FOR_STMNT   :  FOR  '(' EXPR_LIST ';' EXPR_LIST ';' EXPR_LIST ')' BODY
            ;

BODY        :  '{' BODY '}'
            |  STMNT_LIST
            |
            ;

STMNT_LIST  : STMNT_LIST ';' STMNT
            |  STMNT
            ;

STMNT       : BREAK
            |   CONTINUE
            |   RETURN
            |   EXPR_LIST ';'
            |   DECL
            ;

ASSIGN      : ID '=' EXPR
            | ID COMPOUND_OP EXPR
            | ID
            ;

EXPR        : EXPR '+' EXPR
            | EXPR '-' EXPR
            | EXPR '*' EXPR
            | EXPR '/' EXPR
            | EXPR '%' EXPR
            | EXPR '&' EXPR
            | EXPR '|' EXPR
            | EXPR '~' EXPR
            | EXPR '^' EXPR
            | EXPR LEFT_SHIFT EXPR
            | EXPR RIGHT_SHIFT EXPR
            | EXPR RELATIONAL_OP EXPR
            | EXPR OR EXPR
            | EXPR AND EXPR
            | ID PLUS_PLUS
            | ID MINUS_MINUS
            | PLUS_PLUS ID
            | MINUS_MINUS ID
            | '-' EXPR %prec UMINUS
            | '(' EXPR ')'
            | '!' EXPR
            | INT
            | FLOAT
            | TRUE
            | FALSE
            | STRING
            ;

EXPR_LIST   : EXPR_LIST ',' EXPR
            | EXPR
            | EXPR_LIST ',' ASSIGN
            | ASSIGN
            ;


INIT        : ID '=' EXPR
            | ID
            ;

VAR_LIST    : VAR_LIST ',' INIT
            | INIT
            ;

DECL        : DATATYPE VAR_LIST ';'
            ;

%%


int yyerror(char const *s) {
    printf("%s\n",s);
    return 1;
}

int main(int argc,char **argv) {
    if (argc < 2) {
        printf("File name not given as command line argument\n");
        return 1;
    }
    printf("File found\n");
    yyin = fopen(argv[argc-1],"r");
    yyparse();
    return 0;
}

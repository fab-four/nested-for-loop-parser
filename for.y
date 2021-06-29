%{
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE *yyin;
    int yyerror();
    int yylex();
%}


%token    ID INT FOR RELATIONAL_OP OR AND CONTINUE BREAK RETURN DATATYPE TRUE FALSE PLUS_PLUS MINUS_MINUS STRING FLOAT COMPOUND_OP RIGHT_SHIFT LEFT_SHIFT
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


%%

start       :  FOR_STMNT {printf("Valid Syntax\n"); return 0;}

FOR_STMNT   :  FOR  '(' STMNT STMNT EXPR_LIST ')' STMNT
            |  FOR  '(' STMNT STMNT ')' STMNT
            ;

COMPOUND_STMNT :  '{' STMNT_LIST  '}'
               | '{' '}'
            ;

EXPR_STMNT : EXPR_LIST ';'
           | ';'
           ;

STMNT_LIST  : STMNT_LIST STMNT
            |  STMNT
            ;

STMNT       : BREAK ';'
            | CONTINUE ';'
            | RETURN ';'
            | RETURN EXPR ';'
            | EXPR_LIST ';'
            | DECL ';'
            | FOR_STMNT
            | COMPOUND_STMNT
            | EXPR_STMNT
            ;

ASSIGN      : ID '=' EXPR
            | ID COMPOUND_OP EXPR
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
            | '-' EXPR
            | '(' EXPR ')'
            | '!' EXPR
            | INT
            | FLOAT
            | TRUE
            | FALSE
            | STRING
            | ID
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

DECL        : DATATYPE VAR_LIST
            ;

%%


int yyerror(char const *s) {
    printf("%s\n", s);
    return 1;
}

int main(int argc,char **argv) {
    if (argc < 2) {
        printf("File name not given as command line argument\n");
        return 1;
    }
    #ifdef YYDEBUG
        yydebug = 1;
    #endif
    printf("File found: %s\n", argv[argc - 1]);
    yyin = fopen(argv[argc - 1], "r");
    yyparse();
    return 0;
}

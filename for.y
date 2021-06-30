%{
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE *yyin;
    int yyerror();
    int yylex();

    /*
        Line 24 declares all the tokens that are used in the grammar
        Lines 25-36 specify the associative and precedence rules for the operators (specified according to the C++ standard)
        The rules are declared according to the precedence level of operators. For example, "*" has higher precendence than "+".
        Similarly, "||" (OR) has higher precedence than compound operators (COMPOUND_OP).
        
        The section between the first and second %% (lines 39-139) defines the rules necessary to parse the C++ statements,
        specifically the "for" iteration statement (both, range-based and otherwise), according to the C++ syntax.
        Not all syntactic elements and variations are covered, of course, with notable exceptions including attribute- and 
        declaration-specifiers. 

    */

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

start          :  STMNT_LIST { printf("Valid Syntax\n"); return 0; }

FOR_STMNT      :  FOR '(' FOR_INIT_STMNT CONDITION ';' EXPR_LIST ')' STMNT
               |  FOR '(' FOR_INIT_STMNT CONDITION ';' ')' STMNT
               |  FOR '(' FOR_RANGE_DECL ':' EXPR ')' STMNT
               ;

FOR_INIT_STMNT :  EXPR_STMNT
               |  DECL
               ;

FOR_RANGE_DECL :  DATATYPE ID
               ;

STMNT_LIST     :  STMNT_LIST STMNT
               |  STMNT
               ;

STMNT          :  DECL
               |  FOR_STMNT
               |  EXPR_STMNT
               |  COMPOUND_STMNT
               |  JUMP_STMNT
               ;

COMPOUND_STMNT :  '{' STMNT_LIST '}'
               |  '{' '}'
               ;

EXPR_STMNT     :  EXPR_LIST ';'
               |  ';'
               ;

JUMP_STMNT     :  BREAK ';'
               |  CONTINUE ';'
               |  RETURN ';'
               |  RETURN EXPR ';'
               ;

ASSIGN_STMNT   :  ID '=' EXPR
               |  ID COMPOUND_OP EXPR
               ;

CONDITION      :  EXPR
               |  ID '=' ASSIGN_STMNT
               |
               ;

EXPR           :  EXPR '+' EXPR
               |  EXPR '-' EXPR
               |  EXPR '*' EXPR
               |  EXPR '/' EXPR
               |  EXPR '%' EXPR
               |  EXPR '&' EXPR
               |  EXPR '|' EXPR
               |  EXPR '~' EXPR
               |  EXPR '^' EXPR
               |  EXPR LEFT_SHIFT EXPR
               |  EXPR RIGHT_SHIFT EXPR
               |  EXPR RELATIONAL_OP EXPR
               |  EXPR OR EXPR
               |  EXPR AND EXPR
               |  ID PLUS_PLUS
               |  ID MINUS_MINUS
               |  PLUS_PLUS ID
               |  MINUS_MINUS ID
               |  '-' EXPR
               |  '(' EXPR ')'
               |  '!' EXPR
               |  INT
               |  FLOAT
               |  TRUE
               |  FALSE
               |  STRING
               |  ID
               ;

EXPR_LIST      :  EXPR_LIST ',' EXPR
               |  EXPR
               |  EXPR_LIST ',' ASSIGN_STMNT
               |  ASSIGN_STMNT
               ;

INITIALIZER    :  '=' EXPR
               |  '(' EXPR_LIST ')'
               ;

INIT_DECL      :  ID INITIALIZER
               |  ID
               ;

INIT_DECL_LIST :  INIT_DECL_LIST ',' INIT_DECL
               |  INIT_DECL
               ;

DECL           :  DATATYPE INIT_DECL_LIST ';'
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
    yyin = fopen(argv[argc - 1], "r");
    if (!yyin) {
        printf("Could not open %s\n", argv[argc - 1]);
        return 1;
    }
    yyparse();
    return 0;
}

%{
    #include <stdio.h> 
    #include "y.tab.h"
    int yyerror(const char*);
%}
alphabet [A-Za-z_]
digit [0-9]
multiComment "/*"([^*]*[*]+)([^*/][^*]*[*]+)*"/"
singleComment  "//".*
relational_op [">"|"<"|"<="|">="|"=="|"!="]
compound_op ["+="|"-="|"/="|"*="|"%="|">>="|"<<="|"&="|"^="|"|="]
%%

{multiComment}|{singleComment}               ;
bool|int|short|long|char|float|double|string return DATATYPE;
for                                          return FOR;
continue                                     return CONTINUE;
break                                        return BREAK;
return                                       return RETURN;
true                                         return TRUE;
false                                        return FALSE;
("0b"|"0x"|"0B"|"0X"){digit}+                return INT;
{alphabet}({alphabet}|{digit})*              return ID;
\"((\\\")|[^"])*\"                           return STRING;
{relational_op}                              return RELATIONAL_OP;
"||"                                         return OR;
"&&"                                         return AND;
"<<"                                         return LEFT_SHIFT;
">>"                                         return RIGHT_SHIFT;
"++"                                         return PLUS_PLUS;
"--"                                         return MINUS_MINUS;
{compound_op}                                return COMPOUND_OP;
-[0-9]+\.[0-9]+                              return FLOAT;
\+?[0-9]+\.[0-9]+                            return FLOAT;
{digit}+("++"|"--")|("++"|"--"){digit}+      yyerror("lvalue is required as operand");
[\t\n\ ]                                     ;
.                                            return *yytext; 

%%


int yywrap()
{
    return 1;
}

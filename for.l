%{
    #include <stdio.h> 
	#include "y.tab.h"
    int yyerror(const char*);
%}
alpha [A-Za-z_]
digit [0-9]
multiComment "/*"([^*]*[*]+)([^*/][^*]*[*]+)*"/"
singleComment  "//".*
%%

[\t\n\ ]               ;
{multiComment}|{singleComment} ;
bool|int|short|long|char|float|double|string return DATATYPE;
for                         return FOR;
continue                    return CONTINUE;
break                       return BREAK;
return                      return RETURN;
true                        return TRUE;
false                       return FALSE;
{digit}+                    return NUM;
{alpha}({alpha}|{digit})*   return ID;
"<"                         return LT;
">"                         return GT;
"<="                        return LE; 
">="                        return GE;
"=="                        return EQ;
"!="                        return NE;
"||"                        return OR;
"&&"                        return AND;
{digit}+("++"|"--")|("++"|"--"){digit}+ yyerror("lvalue is required as operand");
.                           return *yytext; 

%%


int yywrap()
{
    return 1;
}

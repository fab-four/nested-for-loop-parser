%{

    #include <stdio.h> 
	#include "y.tab.h"
%}
Knostar [^*]*
Nostarfwd [^*/]
Pstar [\*]+
alpha [A-Za-z_]
digit [0-9]
%%

[\t\n\ ]               ;
"/*"{Knostar}{Pstar}({Nostarfwd}{Knostar}{Pstar})*"/" ;
"//".* ;
for                         return FOR;
continue                    return CON;
break                       return BREAK;
{digit}+                    return NUM;
{alpha}({alpha}|{digit})*   return ID;
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

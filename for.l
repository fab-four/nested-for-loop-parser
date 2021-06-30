%{
    #include <stdio.h>
    #include "y.tab.h"
    int yyerror(const char*);

    /*
        INPUT   : A filename (specified as a command-line argument to the executable)
        
        PROCESS : The lexer ignores all whitespace, single-line and multi-line comments, and all C++ keywords except
                "for", "continue", "break", "return", "true", "false" and those that have been used to return the token DATATYPE.

                For "auto", "void", "bool", "int", "short", "long", "char", "float", "double" and "string", the lexer returns the token DATATYPE.
                For "for", "continue", "break", "return", "true" and "false", the lexer returns FOR, CONTINUE, BREAK, RETURN, TRUE and FALSE respectively.
                For a valid identifer name in C++, ID is returned.
                For string, integer, float and double literals, INT, STRING and FLOAT is returned respectively.
                For relational operators, ">", "<", "<=", etc., RELATIONAL_OP is returned.
                For compound operators, "+=", "-=", "/=", "*=", etc. COMPOUND_OP is returned.
                For operators, "||", "&&", "<<", ">>", "++" and "--", tokens OR, AND, LEFT_SHIFT, RIGHT_SHIFT, PLUS_PLUS and MINUS_MINUS, are returned respectively.
                If the operand of a post- or pre-increment and decrement operator is an interger literal, 
                yyerror() is called to print the error message and terminate.
                Every other character is passed as is to the parser.

        OUTPUT  : "Valid Syntax", if the file contains valid C++ code subject to the grammar specified in ".y" file.
                "syntax Error", otherwise.
    */
%}

%%

[\t\n\ ]                             |      /* white-space */
"/*"([^*]*[*]+)([^*/][^*]*[*]+)*"/"  |      /* multi-line comments */
"//".*                               |      /* single-line comments */
alignas                              |
alignof                              |
and                                  |
and_eq                               |
asm                                  |
atomic_cancel                        |
atomic_commit                        |
atomic_noexcept                      |
bitand                               |
bitor                                |
case                                 |
catch                                |
char8_t                              |
char16_t                             |
char32_t                             |
class                                |
compl                                |
concept                              |
const                                |
consteval                            |
constexpr                            |
constint                             |
const_cast                           |
co_await                             |
co_return                            |
co_yield                             |
decltype                             |
default                              |
delete                               |
do                                   |
dynamic_cast                         |
else                                 |
enum                                 |
explicit                             |
export                               |
extern                               |
friend                               |
goto                                 |
if                                   |
inline                               |
mutable                              |
namespace                            |
new                                  |
noexcept                             |
not                                  |
not_eq                               |
nullptr                              |
operator                             |
or                                   |
or_eq                                |
private                              |
protected                            |
public                               |
reflexpr                             |
register                             |
reinterpret_cast                     |
requires                             |
signed                               |
sizeof                               |
static                               |
static_assert                        |
static_cast                          |
struct                               |
switch                               |
synchronized                         |
template                             |
this                                 |
thread_local                         |
throw                                |
try                                  |
typedef                              |
typeid                               |
typename                             |
union                                |
unsigned                             |
using                                |
virtual                              |
volatile                             |
wchar_t                              |
while                                |
xor                                  |
xor_eq                                                      ;
auto|void|bool|int|short|long|char|float|double|string      return DATATYPE;
for                                                         return FOR;
continue                                                    return CONTINUE;
break                                                       return BREAK;
return                                                      return RETURN;
true                                                        return TRUE;
false                                                       return FALSE;
("0b"|"0x"|"0B"|"0X")?[0-9]+                                return INT;
[A-Za-z_]([A-Za-z_]|[0-9])*                                 return ID;
\"((\\\")|[^"])*\"                                          return STRING;
(">"|"<"|"<="|">="|"=="|"!=")                               return RELATIONAL_OP;
("+="|"-="|"/="|"*="|"%="|">>="|"<<="|"&="|"^="|"|=")       return COMPOUND_OP;
"||"                                                        return OR;
"&&"                                                        return AND;
"<<"                                                        return LEFT_SHIFT;
">>"                                                        return RIGHT_SHIFT;
"++"                                                        return PLUS_PLUS;
"--"                                                        return MINUS_MINUS;
[\+\-]?[0-9]+\.[0-9]+                                       return FLOAT;
[0-9]+("++"|"--")|("++"|"--")[0-9]+                         yyerror("lvalue is required as operand");
.                                                           return *yytext;

%%

int yywrap() {
    return 1;
}

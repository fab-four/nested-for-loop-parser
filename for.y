%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern FILE *yyout;
%}


%token ID NUM FOR LE GE EQ NE OR AND  CON BREAK 
%right '='
%left  OR AND
%left  LE GE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%left '!' '%'


%%
   
S           : ST {printf("Accepted \n"); exit(0);}

ST          : FOR '(' E ';' E2 ';' E ')' DEF
            | FOR '(' ';'  ';' ')' DEF
            | FOR '(' E ';'  ';' ')' DEF
            | FOR '(' ';'E2  ';' ')' DEF
            | FOR '(' ';'  ';' E ')' DEF
            ;
            

DEF    	   :'{' '}'
           | '{' BODY '}'
           | E ';'
           | ST
           | ID ID ';'
           |';'
           ;
           
BODY  	   : BODY ST
           | BODY E  ';'     
           | ST
           | E ';'
           | BREAK ';'
           | CON ';'   
           | ID ID ';'
           |';'   
           | BODY BREAK ';'
           | BODY CON ';'   
           ;
       
E         : ID '=' E
          |ID ID '=' E
          | E '+' E
          | E '-' E 
          | E '*' E 
          | E '/' E 
          | E '+' '+' 
          | E '-' '-' 
          | '+' '+' E 
          | '-' '-' E 
          | E '%' E 
          | ID 
          | E2
          ;

   
E2       : E'<'E
         | E'>'E
         | E LE E
         | E GE E
         | E EQ E
         | E NE E
         | E OR E
         | E AND E
         |NUM
         ;   
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

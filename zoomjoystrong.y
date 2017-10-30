%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "zoomjoystrong.h"

	int yyerror(char* s);
	int yylex();
%}

%start program

%union 	{
			int iVal;
			int fVal;
		}
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR 
%token INT
%token FLOAT
%type<iVal> INT
%type<fVal> FLOAT

%%
program:		statement_list END END_STATEMENT
		;
statement_list:	statement
			  |	statement statement_list
			  ;
statement:		point
		 |		line
		 | 		circle
		 |		rectangle
		 |		set_color
		 ;
point:			POINT INT INT END_STATEMENT
				{ 	if($2 >= 0 && $3 >= 0 &&
						$2 <= WIDTH && $3 <= HEIGHT)
						{ point($2, $3); }
					else 
						{ printf("point %i, %i", $2, $3);yyerror("Out of bounds"); }
				}
line:			LINE INT INT INT INT END_STATEMENT
				{	if($2 >= 0 && $3 >= 0 &&
						$2 <= WIDTH && $3 <= HEIGHT &&
						$4 >= 0 && $5 >= 0 &&
						$4 <= WIDTH && $5 <= HEIGHT)
						{ line($2, $3, $4, $5); }
					else 
						{ printf("line %i, %i, %i, %i", $2, $3, $4, $5);yyerror("Out of bounds"); }
				}
circle:			CIRCLE INT INT INT END_STATEMENT
				{ 	if($2 - $4 >= 0 && $3 - $4 >= 0 &&
						$2 + $4 <= WIDTH && $3 + $4 <= HEIGHT)
						{ circle($2, $3, $4); }
					else 
						{ printf("circle %i, %i, %i", $2, $3, $4);yyerror("Out of bounds"); }
				}
rectangle:		RECTANGLE INT INT INT INT END_STATEMENT
				{	if($2 >= 0 && $3 >= 0 &&
						$2 <= WIDTH && $3 <= HEIGHT &&
						$2 + $4 <= WIDTH && $3 + $5 <= HEIGHT)
						{ rectangle($2, $3, $4, $5); }
					else 
						{ printf("rectangle %i, %i, %i, %i", $2, $3, $4, $5);yyerror("Out of bounds"); }	
				}
set_color:		SET_COLOR INT INT INT END_STATEMENT
				{ 	if($2 >= 0 && $2 <= 255 &&
						$3 >= 0 && $3 <= 255 &&
						$4 >= 0 && $4 <= 255) 
						{ set_color($2, $3, $4); }
					else
						{ printf("set_color %i, %i, %i", $2, $3, $4);yyerror("Invalid color"); }
				}
%%

int main(int argc, char** argv) {
	setup();
	yyparse();
	finish();
	return 0;
}

int yywrap() {
	return 1;
}

int yyerror(char* s) {
	return fprintf(stderr, "%s\n", s);
}

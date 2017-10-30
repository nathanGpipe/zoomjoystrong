%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "zoomjoystrong.tab.h"
	
	void yyerror(char*);
	int fileno(FILE *stream);
%}

%option no yywrap

%%
end					{ return END; }
;					{ return END_STATEMENT; }
point				{ return POINT; }
line				{ return LINE; }
circle				{ return CIRCLE; }
rectangle			{ return RECTANGLE; }
set_color			{ return SET_COLOR; }
[0-9]+				{
						yylval.iVal = atoi(yytext);
						return INT;
					}
[0-9]*\.[0-9]+		{
						yylval.fVal = atof(yytext);
						return FLOAT;
					}
[\t]|" "|[\n]			;
.					{
						printf("%s\n", yytext);
						yyerror("invalid character");
					}

%%

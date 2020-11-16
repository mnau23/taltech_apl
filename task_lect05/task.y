%{
	#include "stdio.h"
	extern int yylineno;
	extern FILE *yyin;
	extern int yylex();
	void yyerror(const char *s);
%}

%error-verbose

%token AND AS BETWEEN CONCAT FROM GEQ ID IN IS LEQ LIKE NOT NUL NUM OR SELECT STR STRVAL WHERE

%%

prog	: 
	    | prog stmt
	    ;

stmt	: SELECT cols FROM ID ';'					{ printf("\nLine %d OK.\n", yylineno); }
		| SELECT cols AS alias FROM ID ';'			{ printf("\nLine %d OK.\n", yylineno); }
		| SELECT cols FROM ID WHERE where ';'		{ printf("\nLine %d OK.\n", yylineno); }
	    | error ';'				    				{ yyerrok; }
	    ;

cols	: col
		| cols ',' col
		| cols ',' oper
		;

oper	: NUM '*' '(' ID '+' NUM ')'
		;

alias	: ID ',' ID ID
		;

where	: comparison
		| ID LEQ ID
		| ID BETWEEN numbers
		| ID IN '(' data ')'
		| ID IS NUL
		| ID GEQ NUM AND comparison
		| ID GEQ NUM OR comparison
		| ID NOT IN '(' data ')'
		| ID NOT BETWEEN numbers
		| ID IS NOT NUL
		;

comparison	: ID '=' STRVAL
			;

numbers	: NUM AND NUM
		;

data 	: STRVAL ',' STRVAL ',' STRVAL
		| NUM ',' NUM ',' NUM
		;

col		: '*'	
		| ID
		| ID STR ',' ID '*' NUM STR
		| CONCAT STRVAL CONCAT ID AS STR
		;

%%

int main(int argc, char *argv[]) {
	if(argc < 2)
		return -1;
	yyin = fopen(argv[1], "r");
	if(yyin)
		yyparse();
	fclose(yyin);
	return 0;
}

void yyerror(const char *s) {
	printf("\nError at line %d\n", yylineno);
	printf("%s\n", s);
}

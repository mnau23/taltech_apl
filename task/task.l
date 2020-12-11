%top{
	#include "stdio.h"
	#include "string.h"

	int breakc, casec, constc, continuec, doc, doublec, elsec, forc, ifc, intc, numc, switchc, varc, whilec = 0;
}

%option case-insensitive
%option noyywrap

%%

[a-zA-Z]+	 { if(strcmp(yytext, "break")==0) breakc++;
			   if(strcmp(yytext, "case")==0) casec++;
			   if(strcmp(yytext, "const")==0) constc++;
			   if(strcmp(yytext, "continue")==0) continuec++;
			   if(strcmp(yytext, "do")==0) doc++;
			   if(strcmp(yytext, "double")==0) doublec++;
			   if(strcmp(yytext, "else")==0) elsec++;
			   if(strcmp(yytext, "for")==0) forc++;
			   if(strcmp(yytext, "if")==0) ifc++;
			   if(strcmp(yytext, "int")==0) intc++;
			   if(strcmp(yytext, "switch")==0) switchc++;
			   if(strcmp(yytext, "while")==0) whilec++;
			 }
[0-9]+		 { numc++; }
[a-zA-Z0-9]+ { varc++; }
.			;

%%

// lines 35-36-56 to open automatically a file and read it
// to be removed if you want to do it manually
int main() {
	extern FILE *yyin, *yyout;
	yyin = fopen("data.txt", "r");
	yylex();

	printf("\nKeyword recognition in a text file.\n");
	printf("Break: %d\n", breakc);
	printf("Case: %d\n", casec);
	printf("Const: %d\n", constc);
	printf("Continue: %d\n", continuec);
	printf("Do: %d\n", doc);
	printf("Double: %d\n", doublec);
	printf("Else: %d\n", elsec);
	printf("For: %d\n", forc);
	printf("If: %d\n", ifc);
	printf("Int: %d\n", intc);
	printf("Switch: %d\n", switchc);
	printf("While: %d\n", whilec);
	printf("\nThere are also:\n");
	printf("Numbers: %d\n", numc);
	printf("Variables: %d\n", varc);

	fclose(yyin);
	return 0;
}

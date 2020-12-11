%top{
    #include "pic.h"
    #include "pic.tab.h"
    #include "stdlib.h"
    #include "stdio.h"
}

%option noyywrap
%option yylineno
%option case-insensitive

%%

"=>"			{ return ASSIGN; }
"LD"[0-7]		{ yylval.var = findVar(yytext); return LD; }
"SW"[0-7]		{ yylval.var = findVar(yytext); return SW; }
"R"             { yylval.var = findVar(yytext); return RED; }
"G"             { yylval.var = findVar(yytext); return GREEN; }
"B"             { yylval.var = findVar(yytext); return BLUE; }
"0"			    { yylval.val = atoi(yytext); return ZERO;}
"1"			    { yylval.val = atoi(yytext); return ONE;}
[0-9]+		    { yylval.val = atoi(yytext); return NUM;}
;			    { return *yytext; }
.			    { ; }
\n			    { ; }

%%

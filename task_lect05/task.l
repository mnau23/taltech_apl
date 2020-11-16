%top{
    #include "task.tab.h"
}

%option noyywrap
%option warn
%option case-insensitive
%option yylineno

%x DQUOTE SQUOTE

%%

"AND"	              	{ return AND; }
"AS"	            	{ return AS; }
"BETWEEN"	            { return BETWEEN; }
"FROM"	            	{ return FROM; }
"IN"	            	{ return IN; }
"IS"		            { return IS; }
"LIKE"	        	    { return LIKE; }
"NOT"		            { return NOT; }
"NULL"		            { return NUL; }
"OR"	        	    { return OR; }
"SELECT"	            { return SELECT; }
"WHERE"	        	    { return WHERE; }
"||"                    { return CONCAT; }
"<="                    { return LEQ; }
">="                    { return GEQ; }
[A-Z]+		            { return ID; }
[0-9]+                  { return NUM; }
\'			            { BEGIN(SQUOTE); }
<SQUOTE>[^\']+		    { return STRVAL; }
<SQUOTE>\'	            { BEGIN(INITIAL); }
\"			            { BEGIN(DQUOTE); }
<DQUOTE>[^\"]+		    { return STR; }
<DQUOTE>\"		        { BEGIN(INITIAL); }
[;,\+\-\*/()=<>]        { return *yytext; }
\-\-.*\n	            ;   // ignore comments
\n		                ;   // ignore new line
\t		                ;   // ignore tab
" "		                ;   // ignore space

%%

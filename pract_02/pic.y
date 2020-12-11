%{
	#include "pic.h"
	#include "stdio.h"
	#include "stdlib.h"
	#include "stdarg.h"
	#include "string.h"
	
	extern int yylex(void);
	extern int yylineno;
	extern FILE *yyin;
	void yyerror(const char *);

	t_node *constToNode(int val);
	t_node *opToNode(int type, int n, ...);
	t_node *block(t_node *a, t_node *b);

	int varCount;
	t_varNode **variables;
	t_node *varToNode(t_varNode *var);

	int labelcount;
	t_node *root;
	void translate(FILE *f, t_node *p);
%}

%union{
	int val;
	t_varNode *var;
	t_node *node;
}

%error-verbose
%token ASSIGN
%token <val> NUM ONE ZERO
%token <var> VAR LD SW RED GREEN BLUE

%type <node> stmt program 

%%

program	: stmt					{ root = $$ = $1; }
		| program stmt			{ root = $$ = block($1, $2); }
		;

stmt	: ONE ASSIGN LD ';'				{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ZERO ASSIGN LD ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ONE ASSIGN RED ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ZERO ASSIGN RED ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ONE ASSIGN GREEN ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ZERO ASSIGN GREEN ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ONE ASSIGN BLUE ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| ZERO ASSIGN BLUE ';'			{ $$ = opToNode(ASSIGN, 2, constToNode($1), varToNode($3)); }
		| SW ASSIGN LD ';'				{ $$ = opToNode(ASSIGN, 2, varToNode($1), varToNode($3)); }
		;

%%

t_varNode *newVar(char *name, char *port, unsigned int mask) {
	t_varNode *v = malloc(sizeof(t_varNode));
	v->name = name;
	varCount++;
	v->port = port;
	v->mask = mask;
	v->accessed = 0;
	v->inOut = 0;	// input = 0; output = 1;
	variables = realloc(variables, varCount * sizeof(void*));
	variables[varCount - 1] = v;
	return v;
}

t_varNode *findVar(char *name) {
	int i;
	for(i = 0; i < varCount; i++)
		if(strcasecmp(variables[i]->name, name) == 0){
			variables[i]->accessed++;
			return variables[i];
		}	
	return NULL;	// flex won't be allowed to generate new variables
}

void yyerror(const char *s) {
	printf("Error at line %d: %s\n", yylineno, s);
}

t_node *constToNode(int val) {
	t_node *p = malloc(sizeof(t_node));
	p->type = tConst;
	p->value = val;
	return p;
}

t_node *opToNode(int type, int n, ...) {
	va_list args;
	t_node *p = malloc(sizeof(t_node));
	p->type = tOp;
	p->optype = type;
	p->n = n;
	p->children = malloc(n * sizeof(void*));
	int i;
	va_start(args, n);
	for(i = 0; i < n; i++)
		p->children[i] = va_arg(args, t_node*);
	va_end(args);
	return p;
}

t_node *block(t_node *a, t_node *b) {
	if(a == NULL && b != NULL)
		return b;
	if(a != NULL && b == NULL)
		return a;
	if(a == NULL && b == NULL)
		return NULL;
	if(a->type == tBlock) {
		a->n++;
		a->children = realloc(a->children, a->n * sizeof(void*));
		a->children[a->n - 1] = b;
		return a;
	}else {
		t_node *p = malloc(sizeof(t_node));
		p->type = tBlock;
		p->n = 2;
		p->children = malloc(2 * sizeof(void*));		
		p->children[0] = a;
		p->children[1] = b;
		return p;
	}
}

t_node *varToNode(t_varNode *var) {
	t_node *p = malloc(sizeof(t_node));
	p->type = tVar;
	p->var = var;
	return p;
}

void label(FILE *f, int a) {
		fprintf(f, ".lbl%d:\n", a);
}

void go(FILE *f, int a) {
		fprintf(f, "\tj\t.lbl%d\n", a);
		fprintf(f, "\tnop\n");
}

void writeVarConst(FILE *f, t_varNode *v, int k) {
	if(v == NULL) {
		printf("Variable missing!\n");
		return;
	}	
	fprintf(f, "\t\n");
	fprintf(f, "\t# assign to variable %s\n", v->name);
	fprintf(f, "\tlui\t$2,%%hi(LAT%s%s)\n", v->port, k == 1 ? "SET" : "CLR");
	fprintf(f, "\tli\t$3,0x%x\n", v->mask);
	fprintf(f, "\tsw\t$3,%%lo(LAT%s%s)($2)\n", v->port, k == 1 ? "SET" : "CLR");
}

// read the value of switch from PORTx then AND it with mask.
void readVarConst(FILE *f, t_varNode *v, int k) {
	if(v == NULL) {
		printf("Variable missing!\n");
		return;
	}
	fprintf(f, "\t\n");
	fprintf(f, "\t# read from variable %s\n", v->name);
}

void translate(FILE *f, t_node *p) {
	int i;
	switch(p->type) {
		case tOp:
			switch(p->optype) {
				case ASSIGN:
					if(p->children[0]->type == tConst)
						writeVarConst(f, p->children[1]->var, p->children[0]->value);
					break;
			}
			break;
		case tBlock: 
			for(i = 0; i < p->n; i++)
				translate(f, p->children[i]);
			break;
	}	
}

void init(FILE *f) {	// init board
	fprintf(f, "\t.global main\n");
	fprintf(f, "\t.text\n");
	fprintf(f, "\t.ent main\n");
	fprintf(f, "main:\n");
}

void conclude(FILE *f) {
	// this is endless loop at end of program
	int a = labelcount++;
	label(f, a);
	go(f, a);
	// end this
	
	fprintf(f, "\t\n");
	fprintf(f, "\t.end\tmain\n");
	fprintf(f, "\t\n");
	fprintf(f, "\t.section\t.config_BFC02FFC, code, keep, address(0xBFC02FFC) \n");
	fprintf(f, "\t.word\t0x7FFFFFFB \n");
	fprintf(f, "\t.section\t.config_BFC02FF8, code, keep, address(0xBFC02FF8)\n");
	fprintf(f, "\t.word\t0xFF74FD5B \n");
	fprintf(f, "\t.section\t.config_BFC02FF4, code, keep, address(0xBFC02FF4) \n");
	fprintf(f, "\t.word\t0xFFF8FFD9 \n");
	fprintf(f, "\t.section\t.config_BFC02FF0, code, keep, address(0xBFC02FF0) \n");
	fprintf(f, "\t.word\t0xCFFFFFFF\n");
}

// cover all 8 leds, RGB and switches
void createVars() {
	newVar("LD0", "A", 0x1);
	newVar("LD1", "A", 0x2);
	newVar("LD2", "A", 0x4);
	newVar("LD3", "A", 0x8);
	newVar("LD4", "A", 0x10);
	newVar("LD5", "A", 0x20);
	newVar("LD6", "A", 0x40);
	newVar("LD7", "A", 0x80);
	newVar("R", "D", 0x4);
	newVar("G", "D", 0x1000);
	newVar("B", "D", 0x8);
	newVar("SW0", "F", 0x8);
	newVar("SW1", "F", 0x20);
	newVar("SW2", "F", 0x10);
	newVar("SW3", "D", 0x10000);
	newVar("SW4", "D", 0x8000);
	newVar("SW5", "B", 0x800);
	newVar("SW6", "B", 0x400);
	newVar("SW7", "B", 0x200);
}

void initVars(FILE *f) {
	fprintf(f, "\t# configure PORTA as digital\n");	
	fprintf(f, "\tlui\t$2,%%hi(ANSELA)\n");
	fprintf(f, "\tsw\t$0,%%lo(ANSELA)($2)\n");
	int i;
	for(i = 0; i < varCount; i++)
		if(variables[i]->accessed) {
			fprintf(f, "\t\n");
			fprintf(f, "\t# initialize variable %s\n", variables[i]->name);
			fprintf(f, "\tlui\t$2,%%hi(TRIS%sCLR)\n", variables[i]->port);
			fprintf(f, "\tli\t$3,0x%x\n", variables[i]->mask);
			fprintf(f, "\tsw\t$3,%%lo(TRIS%sCLR)($2)\n", variables[i]->port);
		}
}

void printNode(t_node *p, int level) {
	if(p == NULL) {
		printf("%*c NULL\n", level, ' ');
		return;
	}
	int i;
	switch(p->type) {
		case tConst: 	printf("%*c const: %d\n", level, ' ', p->value); break;
		case tVar: 	if(p->var == NULL)
				printf("%*c var(NULL)\n", level, ' ');
			else
				printf("%*c var(%s): ? \n", level, ' ', p->var->name); break;
		case tOp: 	printf("%*c op: %d(%c)\n", level, ' ', p->optype, p->optype);
			for(i = 0; i < p->n; i++)
				printNode(p->children[i], level + 4);
			break;
		case tBlock: printf("%*c block\n", level, ' ');
			for(i = 0; i < p->n; i++)
				printNode(p->children[i], level + 4);
			break;
	}
}

// add eternal loop that encompasses the user program excluding initializations
void eternLoop(FILE *f) {
	// this is endless loop at end of program
	int a = labelcount++;
	label(f, a);
	translate(f, root);
	go(f, a);
	// end this
}

int main(int argc, char *argv[]) {
	if(argc < 2){
		printf("Nothing to compile.\n");
		return 0;
	}
	yyin = fopen(argv[1], "r");
	if(yyin == NULL){
		printf("Could not open file %s\n", argv[1]);
		return -1;
	}

	labelcount = 1;
	
	varCount = 0;
	variables = NULL;
	createVars();
	
	root = NULL;
	yyparse();
	fclose(yyin);
	
	printNode(root, 0);
	
	FILE *f = NULL;
	if(argc > 2)
		f = fopen(argv[2], "w");
	if(f == NULL)
		f = fopen("prog.s", "w");
	init(f);
	initVars(f);
	eternLoop(f);
	// translate(f, root);
	conclude(f);
	fclose(f);
	return 0;
}

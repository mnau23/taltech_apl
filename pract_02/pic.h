typedef struct _varNode{
	char *name;
	char *port; // address of port
	unsigned int mask; //bitmask of port
	int accessed;
} t_varNode;

typedef enum {tConst, tVar, tOp, tBlock} t_nodeType;

typedef struct _node{
	t_nodeType type;
	t_varNode *var; //tVar
	int value; //tConst
	int optype; //tOp
	int n; //tOp number of operands
	struct _node **children; //tOp operands
} t_node;

t_varNode *findVar(char *name);

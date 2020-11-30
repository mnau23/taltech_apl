grammar json;

json_file : value EOF;

value : obj # object
      | arr # array
      | STRING # string
      | NUMBER # number
      | 'true' # true
      | 'false' # false
      | 'null' # null
      ;

obj : '{' member (',' member)* '}'
    | '{' '}'
    ;

member : STRING ':' value;

arr : '[' value (',' value)* ']'
    | '[' ']'
    ;

// TOKENS
// strings
STRING : '"' (ESC | CODEPOINT)* '"'
       ;

// escape characters
fragment ESC : '\\' (["\\/bfnrt] | UNIC)
             ;

// unicode characters
fragment UNIC : 'u' HEX HEX HEX HEX
              ;

// hexadecimals
fragment HEX : [0-9a-fA-F]
             ;

// controls characters
fragment CODEPOINT : ~["\\\u0000-\u001F]
                   ;

// numbers
NUMBER : '-'? INT ('.' [0-9]+)? EXP?
       ;

// integers
fragment INT : '0' | [1-9] [0-9]*
             ;

// exponentials
fragment EXP : [Ee] [+\-]? INT
             ;

// white spaces
WS : [ \t\n\r]+ -> skip;

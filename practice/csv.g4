grammar csv;

csv_file : hdr row+ EOF;
hdr : row;
row : field ( ',' field)+ '\r'? '\n';
field : NUMBER # number
      | STRING # string
      |        # empty
      ;

// TOKENS
STRING : '"' ('""' | ~'"')* '"';   // two double quotes is an escaped double quote, ~ means NOT
NUMBER : [0-9]+;
WS : [ \n\t\r]+ -> skip;    // white spaces

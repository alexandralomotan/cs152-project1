grammar FeatherweightJavaScript;


@header { package edu.sjsu.fwjs.parser; }

// Reserved words
IF        : 'if' ;  //
ELSE      : 'else' ;  //
WHILE     : 'while' ;
FUNCTION  : 'function' ;
VAR       : 'var' ;
PRINT     : 'print' ;

// Literals
BOOL      : 'true' | 'false' ;
INT       : [1-9][0-9]* | '0' ;  //
NULL      : 'null' ;

// Symbols
// '*', '/', '+', '-', '%' are the usual mathematical operations.
MUL       : '*' ;  //
DIV       : '/' ;  //
ADD       : '+' ;
SUB       : '-' ;
MOD       : '%' ;

// '>', '<', '>=', '<=', '==' are the usual equality comparisons.
GREATER   : '>' ;
LESSER    : '<' ;
GREATER_EQ: '>=' ;
LESSER_EQ : '<=' ;
EQ_EQ     : '==' ;

SEPARATOR : ';' ;  //

// Identifiers
FIRST_CHAR  : [a-zA-Z_] ;
CHAR        : [a-zA-Z0-9_] ;
VARIABLE    : FIRST_CHAR CHAR* ;

// Whitespace and comments
NEWLINE   : '\r'? '\n' -> skip ;  //
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;
LINE_COMMENT  : '//' ~[\n\r]* -> skip ;  //
WS            : [ \t]+ -> skip ; // ignore whitespace  //


// ***Paring rules ***

/** The start rule */
prog: stat+ ;  //

stat: expr SEPARATOR                                    # bareExpr  //
    | IF '(' expr ')' block ELSE block                  # ifThenElse  //
    | IF '(' expr ')' block                             # ifThen  //
    | WHILE '(' expr ')' block                          # while
    | PRINT block                                       # print
    | SEPARATOR                                         # empty 
    ;

expr: expr op=( '*' | '/' | '%' ) expr                  # MulDivMod  //
    | expr op=( '+' | '-' ) expr                        # AddSub
    | expr op=( LESSER | LESSER_EQ | GREATER | GREATER_EQ | EQ_EQ ) expr   # comparisons 
    | expr FUNCTION expr block                          # functionDecl
    | VARIABLE expr                                     # functionAppl
    | VAR VARIABLE '=' expr                             # varDecl
    | VARIABLE '=' expr                                 # assignmentStat
    | VARIABLE                                          # varReference   
    | INT                                               # int  //
    | BOOL                                              # bool
    | NULL                                              # null 
    | '(' expr ')'                                      # parens  //
    ;

block: '{' stat* '}'                                    # fullBlock  //
     | stat                                             # simpBlock  //
     ;


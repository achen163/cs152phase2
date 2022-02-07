    /* cs152-miniL phase2 */
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *msg);
%}

%union{
  /* put your types here */
  int numToken;
  char* stringToken;
}

%error-verbose
%locations
%start Program_Start

%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCALS
%token END_LOCALS
%token BEGIN_BODY
%token END_BODY
%token INTEGER
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token BEGINLOOP
%token ENDLOOP
%token CONTINUE
%token BREAK
%token READ
%token WRITE
%right NOT
%token TRUE
%token FALSE
%token RETURN
%left SUB
%left ADD
%left MULT
%left DIV
%left MOD
%left EQ
%left NEQ
%left LT
%left GT
%left LTE
%left GTE
%token SEMICOLON
%token COLON
%token COMMA
%left L_PAREN
%left R_PAREN
%left L_SQUARE_BRACKET
%left R_SQUARE_BRACKET
%right ASSIGN
%token <numToken> NUMBER
%token <stringToken> IDENT


/* %start program */
%%

/* %write your rules here */

Program_Start: Functions {
  printf("Program_Start -> Functions\n");
};
  
Functions: %empty {
  printf("Functions -> epsilon\n");
   } |
  Function Functions {
    printf("Function -> Function Functions\n");
  };

Function: FUNCTION IDENT SEMICOLON BEGIN_PARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY {
  printf("Function -> FUNCTION IDENT SEMICOLON BEGINPARAMS Declarations END_PARAMS BEGIN_LOCALS Declarations END_LOCALS BEGIN_BODY Statements END_BODY\n");
};

Declarations: %empty {
  printf("Declarations -> epsilon\n");
   } | 
   Declaration SEMICOLON Declarations {
     printf("Declarations -> Declaration SEMICOLON Declarations\n");
   };

Declaration: Identifiers COLON INTEGER {
  printf("Declaration -> IDENT COLON INTEGER\n");
} |
Identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER{
  printf("Declaration -> IDENT COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");
};

Identifiers: Ident {
  printf("Identifiers -> Ident\n");
}

Ident: IDENT{
  printf("Idents -> IDENT %s\n", $1);
};

Statements: %empty {
  printf("Statements -> epsilon\n");
} |
Statement SEMICOLON Statements {
  printf("Statements-> Statement SEMICOLON Statements\n");
};

Statement: Var ASSIGN Expression {
  printf("Statement -> Var ASSIGN Expression\n");
} |
IF BoolExp THEN Statements ENDIF {
  printf("Statemtn -> IF BoolExp THEN Statements ENDIF\n");
} |
IF BoolExp THEN Statements ELSE Statements ENDIF {
  printf("Statement -> IF BoolExp THEN Statements ELSE Statements ENDIF\n");
} |
WHILE BoolExp BEGINLOOP Statements ENDLOOP{
  printf("Statement -> WHILE BoolExp Statements ENDLOOP\n");
} |
DO BEGINLOOP Statements ENDLOOP WHILE BoolExp{
  printf("Statement -> DO BEGINLOOP Statements ENDLOOP WHILE BoolExp\n");
} |
READ Var {
  printf("Statement -> READ Var\n");
} | 
WRITE Var {
  printf("Statement -> WRITE Var\n");
} |
CONTINUE {
  printf("Statement -> CONTINUE\n");
} |
RETURN Expression {
  printf("Statement -> RETURN Expression\n");
};

BoolExp : Expression Comparison Expression {
  printf("BoolExp -> Expression Comparison Expression\n");
} |
NOT BoolExp {
  printf("BoolExp -> NOT BoolExp\n");
};


Comparison: EQ {
  printf("Comparison -> EQ\n");
} |
NEQ {
  printf("Comparison -> NEQ\n");
} |
LT {
  printf("Comparison -> LT\n");
} |
GT {
  printf("Comparison -> GT\n");
} |
LTE {
  printf("Comparison -> LTE\n");  
} |
GTE {
  printf("Comparison -> GTE\n");
};

Expression: MultiplicativeExpr {
  printf("Expression -> MultiplicativeExpr\n");
} |
MultiplicativeExpr ADD Expression {
  printf("MultiplicativeExpr ADD Expression\n");
} |
MultiplicativeExpr SUB Expression {
  printf("MultiplicativeExpr SUB Expression\n");
};

Expressions:  %empty {
  printf("Expressions -> epsilon\n");
   } |
   Expression{
     printf("Expressions-> Expression\n");
   } |
   Expression COMMA Expressions {
     printf("Expressions -> Expression COMMA Expressions\n");
   } ;

MultiplicativeExpr: Term {
  printf("MultiplicativeExpr -> Term\n");
} |
Term MULT MultiplicativeExpr {
  printf("MultiplicativeExpr -> Term MULT MultiplicativeExpr\n");
} |
Term DIV MultiplicativeExpr {
  printf("MultiplicativeExpr -> Term DIV MultiplicativeExpr\n");
} |
Term MOD MultiplicativeExpr {
  printf("MultiplicativeExpr -> Term MOD MultiplicativeExpr\n");
};

Term: Var {
  printf("Term -> Var\n");
} |
NUMBER {
  printf("Term -> NUMBER %d\n", $1);
} |
L_PAREN Expression R_PAREN {
  printf("Term -> L_PAREN Expression R_PAREN\n");
} |
Ident L_PAREN Expressions R_PAREN {
  printf("Term -> IDENT L_PAREN Expressions R_PAREN\n");
} 

Var : IDENT {
  printf("Var -> IDENT\n");
} |
IDENT L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {
  printf ("Var -> IDENT L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");
}

%%
int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    extern int currLine;
    extern int currPosition;
    printf("ERROR at Line %d, position %d: %s\n", currLine, currPosition, msg);
}
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern FILE *yyin;
extern FILE *token_output;
ASTNode *root = NULL;


void yyerror(char *msg, ...);
%}

%union {
    int integer;
    char *string;
    struct ASTNode *ast;
}

%token VOID INT
%token ELSE IF RETURN 
%token WHILE
%token ADD SUB MUL DIV
%token LT LTE GT GTE EQ NEQ
%token ASSIGN
%token SEMI COMMA
%token ROUND_OPEN ROUND_CLOSE SQUARE_OPEN SQUARE_CLOSE CURLY_OPEN CURLY_CLOSE
%token ID NUM

%type <ast> program declaration var_declaration expression_stmt expression additive_expression term call arg_list
%type <string> ID
%type <integer> NUM
%type <type> INT VOID 

%%

program:
    /* empty */ { root = NULL; }
  | program declaration { 
      if (root == NULL) root = $2; 
      else add_child(root, $2); 
    }
  ;

declaration:
    var_declaration { $$ = $1; }
  | expression_stmt { $$ = $1; }
  ;

var_declaration:
    INT ID SEMI {
      $$ = create_ast_node(VAR_DECL, NULL, NULL);
      $$->name = strdup($2);
      $$->type = VAR_DECL;
    }
  | INT ID ASSIGN expression SEMI {
      $$ = create_ast_node(VAR_DECL, $4, NULL);
      $$->name = strdup($2);
      $$->type = VAR_DECL;
    }
  ;

expression_stmt:
    expression SEMI { $$ = $1; }
  ;

expression:
    ID ASSIGN expression {
      ASTNode *var_node = create_leaf_node(VAR_NAME, strdup($1), 0);
      $$ = create_ast_node(E_ASSIGN, var_node, $3);
    }
  | additive_expression { $$ = $1; }
  | call { $$ = $1; }
  ;

additive_expression:
    additive_expression ADD term {
      $$ = create_ast_node(BE_ADD, $1, $3);
    }
  | additive_expression SUB term {
      $$ = create_ast_node(BE_SUB, $1, $3);
    }
  | term { $$ = $1; }
  ;

term:
    ID { $$ = create_leaf_node(VAR_NAME, strdup($1), 0); }
  | NUM { $$ = create_leaf_node(K_NUM, NULL, $1); }
  ;

call:
    ID ROUND_OPEN arg_list ROUND_CLOSE {
      $$ = create_ast_node(K_CALL, NULL, NULL);
      $$->name = strdup($1);
      for (int i = 0; i < $3->child_count; i++) {
          add_child($$, $3->children[i]);
      }
      free($3->children);
      free($3);
    }
  ;

arg_list:
    /* empty */ {
      $$ = create_ast_node(COMPOUND, NULL, NULL);  // empty argument list as compound node with no children
    }
  | arg_list COMMA expression {
      $$ = $1;
      add_child($$, $3);
    }
  | expression {
      $$ = create_ast_node(COMPOUND, NULL, NULL);
      add_child($$, $1);
    }
  ;

%%

int main() {
    yyin = fopen("../parser_text.cm", "r");
    token_output = fopen("tokens.txt", "w");

    if (!yyin) {
        perror("Cannot open parser_text.cm");
        return 1;
    }

    if (!token_output) {
        perror("Cannot open tokens.txt");
        return 1;
    }

    if (yyparse() == 0) {
        printf("Parsing successful.\n");
    } else {
        printf("Parsing failed.\n");
    }

    fclose(yyin);
    fclose(token_output);
    return 0;
}

void yyerror(char *msg, ...) {
    va_list args;
    va_start(args, msg);
    vfprintf(stderr, msg, args);
    va_end(args);
}
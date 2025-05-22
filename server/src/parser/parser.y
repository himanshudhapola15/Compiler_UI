  %{
  #include "ast.h"
  #include <string.h>
  extern int yylex();
  void yyerror(char* err, ...);
  ASTNode *root = NULL;
  extern FILE *yyin;
  extern FILE *tokenFile;
  %}

  %union { 
    int integer; 
    char *string; 
    struct ASTNode *ast;
    int type; 
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
    yyin = fopen("parser_text.cm", "r");
    tokenFile = fopen("tokens.txt", "w");

    if (!yyin) {
        perror("INPUT FILE NOT FOUND");
        return 1;
    }

    if (yyparse() == 0) {
        printf("Parsing succeeded\n");
        if (root) print_ast(root, 0);
    } else {
        printf("Parsing failed\n");
    }

    fclose(yyin);
    fclose(tokenFile);
    return 0;
}

  void yyerror(char *s, ...) {
      fprintf(stderr, "Parse error: %s\n", s);
  }

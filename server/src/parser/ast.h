#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>

typedef enum {
  // binary operators like <= , >=
  BE_LT,
  BE_LTE,
  BE_GT,
  BE_GTE,
  BE_EQ,
  BE_NEQ,
  BE_ADD,
  BE_SUB,
  BE_MUL,
  BE_DIV,
  K_NUM,
  K_CALL,
  E_ASSIGN,
  VAR_NAME,
  ARRAY_ACCESS,
  NODE_RETURN,
  NODE_WHILE,
  IF_THEN,
  COMPOUND,
  PARAM,
  FUNCTION,
  VAR_DECL
} ASTNodeType;

typedef struct ASTNode {
  ASTNodeType type;
  char *name;
  int value;
  struct ASTNode *left;
  struct ASTNode *right;
  struct ASTNode **children;
  int child_count;
} ASTNode;

ASTNode *create_ast_node(ASTNodeType type, ASTNode *left, ASTNode *right);
ASTNode *create_leaf_node(ASTNodeType type, char *name, int value);
void add_child(ASTNode *parent, ASTNode *child);
void print_ast(ASTNode *root, int level);
char *get_node_type_name(ASTNodeType type);

#endif // !AST_H

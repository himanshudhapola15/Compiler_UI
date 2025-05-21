#include "ast.h"
#include <stdlib.h>

ASTNode *create_ast_node(ASTNodeType type, ASTNode *left, ASTNode *right) {
  ASTNode *node = malloc(sizeof(ASTNode));
  node->type = type;
  node->name = NULL;
  node->value = 0;
  node->left = left;
  node->right = right;
  node->children = NULL;
  node->child_count = 0;
  return node;
}

ASTNode *create_leaf_node(ASTNodeType type, char *name, int value) {
  ASTNode *temp = malloc(sizeof(ASTNode));
  temp->type = type;
  temp->name = name;
  temp->value = value;
  temp->left = NULL;
  temp->right = NULL;
  temp->child_count = 0;
  temp->children = NULL;
  return temp;
}

void add_child(ASTNode *parent, ASTNode *child) {
  parent->children =
      realloc(parent->children, sizeof(ASTNode *) * (parent->child_count + 1));
  parent->children[parent->child_count++] = child;
}

char *get_node_type_name(ASTNodeType type) {
  switch (type) {
  case BE_LT:
    return "BE_LT";
  case BE_LTE:
    return "BE_LTE";
  case BE_GT:
    return "BE_GT";
  case BE_GTE:
    return "BE_GTE";
  case BE_EQ:
    return "BE_EQ";
  case BE_NEQ:
    return "BE_NEQ";
  case BE_ADD:
    return "BE_ADD";
  case BE_SUB:
    return "BE_SUB";
  case BE_MUL:
    return "BE_MUL";
  case BE_DIV:
    return "BE_DIV";
  case K_NUM:
    return "K_NUM";
  case K_CALL:
    return "K_CALL";
  case E_ASSIGN:
    return "E_ASSIGN";
  case VAR_NAME:
    return "VAR_NAME";
  case ARRAY_ACCESS:
    return "ARRAY_ACCESS";
  case NODE_RETURN:
    return "NODE_RETURN";
  case NODE_WHILE:
    return "NODE_WHILE";
  case IF_THEN:
    return "IF_THEN";
  case COMPOUND:
    return "COMPOUND";
  case PARAM:
    return "PARAM";
  case FUNCTION:
    return "FUNCTION";
  case VAR_DECL:
    return "VAR_DECL";
  default:
    return "UNKNOWN";
  }
}

void print_ast(ASTNode *node, int level) {
  if (!node)
    return;
  // indentatino of the level
  for (int i = 0; i < level; i++)
    printf("  ");
  printf("Node Type: %s", get_node_type_name(node->type));
  if (node->name)
    printf(", Name: %s", node->name);
  printf(", Value: %d\n", node->value);
  if (node->left)
    print_ast(node->left, level + 1);
  if (node->right)
    print_ast(node->right, level + 1);
  for (int i = 0; i < node->child_count; i++) {
    print_ast(node->children[i], level + 1);
  }
}

void free_ast(ASTNode *root) {
  if (!root)
    return;
  if (root->name)
    free(root->name);
  if (root->left)
    free_ast(root->left);
  if (root->right)
    free_ast(root->right);
  for (int i = 0; i < root->child_count; i++) {
    free_ast(root->children[i]);
  }
  free(root->children);
  free(root);
}

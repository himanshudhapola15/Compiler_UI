#include "ast.h"

int main() {
  ASTNode *num1 = create_leaf_node(K_NUM, NULL, 5);
  ASTNode *num2 = create_leaf_node(K_NUM, NULL, 3);
  ASTNode *add = create_ast_node(BE_ADD, num1, num2);
  print_ast(add, 0);
  return 0;
}

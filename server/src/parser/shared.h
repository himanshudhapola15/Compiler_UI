#ifndef SHARED_H
#define SHARED_H

typedef struct ASTNode
{
    int type;
    char *name;
    int value;
    int child_count;
    struct ASTNode **children;
} ASTNode;

enum NodeType
{
    VAR_DECL,
    VAR_NAME,
    E_ASSIGN,
    BE_ADD,
    BE_SUB,
    K_NUM,
    K_CALL,
    COMPOUND
};

ASTNode *create_ast_node(int type, ASTNode *left, ASTNode *right);
ASTNode *create_leaf_node(int type, const char *name, int value);
void add_child(ASTNode *parent, ASTNode *child);

#endif

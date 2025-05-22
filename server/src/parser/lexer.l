%option noyywrap noinput nounput yylineno

%{
#include "ast.h"              // Include ASTNode definition first
#include "parser.tab.h"       // Include after ast.h
#include <stdio.h>
FILE *tokenFile;
int yylex();
%}

%%

"else"          { fprintf(tokenFile, "ELSE\n"); return ELSE; }
"if"            { fprintf(tokenFile, "IF\n"); return IF; }
"int"           { fprintf(tokenFile, "INT\n"); return INT; }
"return"        { fprintf(tokenFile, "RETURN\n"); return RETURN; }
"void"          { fprintf(tokenFile, "VOID\n"); return VOID; }
"while"         { fprintf(tokenFile, "WHILE\n"); return WHILE; }

"+"             { fprintf(tokenFile, "ADD\n"); return ADD; }
"-"             { fprintf(tokenFile, "SUB\n"); return SUB; }
"*"             { fprintf(tokenFile, "MUL\n"); return MUL; }
"/"             { fprintf(tokenFile, "DIV\n"); return DIV; }

"<="            { fprintf(tokenFile, "LTE\n"); return LTE; }
"<"             { fprintf(tokenFile, "LT\n"); return LT; }
">="            { fprintf(tokenFile, "GTE\n"); return GTE; }
">"             { fprintf(tokenFile, "GT\n"); return GT; }
"=="            { fprintf(tokenFile, "EQ\n"); return EQ; }
"!="            { fprintf(tokenFile, "NEQ\n"); return NEQ; }
"="             { fprintf(tokenFile, "ASSIGN\n"); return ASSIGN; }

";"             { fprintf(tokenFile, "SEMI\n"); return SEMI; }
","             { fprintf(tokenFile, "COMMA\n"); return COMMA; }

"("             { fprintf(tokenFile, "ROUND_OPEN\n"); return ROUND_OPEN; }
")"             { fprintf(tokenFile, "ROUND_CLOSE\n"); return ROUND_CLOSE; }
"["             { fprintf(tokenFile, "SQUARE_OPEN\n"); return SQUARE_OPEN; }
"]"             { fprintf(tokenFile, "SQUARE_CLOSE\n"); return SQUARE_CLOSE; }
"{"             { fprintf(tokenFile, "CURLY_OPEN\n"); return CURLY_OPEN; }
"}"             { fprintf(tokenFile, "CURLY_CLOSE\n"); return CURLY_CLOSE; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.string = strdup(yytext); fprintf(tokenFile, "ID(%s)\n", yytext); return ID; }
[0-9]+                  { yylval.integer = atoi(yytext); fprintf(tokenFile, "NUM(%s)\n", yytext); return NUM; }

[ \t\r]+                { /* skip whitespace */ }
"\n"                    { ++yylineno; }

"//".*                  { /* skip comment */ }
.                       { fprintf(stderr, "Unknown character: %c\n", yytext[0]); }

%%

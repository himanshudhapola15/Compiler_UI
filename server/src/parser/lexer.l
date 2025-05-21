%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yylineno = 1;
FILE *token_output;

extern YYSTYPE yylval;

%}

%option noyywrap nounput noinput yylineno

%%

"else"          { fprintf(token_output, "ELSE\n"); return ELSE; }
"if"            { fprintf(token_output, "IF\n"); return IF; }
"int"           { fprintf(token_output, "INT\n"); return INT; }
"return"        { fprintf(token_output, "RETURN\n"); return RETURN; }
"void"          { fprintf(token_output, "VOID\n"); return VOID; }
"while"         { fprintf(token_output, "WHILE\n"); return WHILE; }

"+"             { fprintf(token_output, "ADD\n"); return ADD; }
"-"             { fprintf(token_output, "SUB\n"); return SUB; }
"*"             { fprintf(token_output, "MUL\n"); return MUL; }
"/"             { fprintf(token_output, "DIV\n"); return DIV; }

"<="            { fprintf(token_output, "LTE\n"); return LTE; }
"<"             { fprintf(token_output, "LT\n"); return LT; }
">="            { fprintf(token_output, "GTE\n"); return GTE; }
">"             { fprintf(token_output, "GT\n"); return GT; }
"=="            { fprintf(token_output, "EQ\n"); return EQ; }
"!="            { fprintf(token_output, "NEQ\n"); return NEQ; }

"="             { fprintf(token_output, "ASSIGN\n"); return ASSIGN; }

";"             { fprintf(token_output, "SEMI\n"); return SEMI; }
","             { fprintf(token_output, "COMMA\n"); return COMMA; }
"("             { fprintf(token_output, "ROUND_OPEN\n"); return ROUND_OPEN; }
")"             { fprintf(token_output, "ROUND_CLOSE\n"); return ROUND_CLOSE; }
"["             { fprintf(token_output, "SQUARE_OPEN\n"); return SQUARE_OPEN; }
"]"             { fprintf(token_output, "SQUARE_CLOSE\n"); return SQUARE_CLOSE; }
"{"             { fprintf(token_output, "CURLY_OPEN\n"); return CURLY_OPEN; }
"}"             { fprintf(token_output, "CURLY_CLOSE\n"); return CURLY_CLOSE; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.string = strdup(yytext);
    fprintf(token_output, "ID:%s\n", yytext);
    return ID;
}

[0-9]+ {
    yylval.integer = atoi(yytext);
    fprintf(token_output, "NUM:%s\n", yytext);
    return NUM;
}

[ \t\r]+        ; // ignore spaces/tabs
"//".*          ; // ignore single-line comments
\n              { yylineno++; }

.               { fprintf(token_output, "UNKNOWN:%c\n", yytext[0]); }

%%

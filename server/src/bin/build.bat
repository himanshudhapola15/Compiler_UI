@REM @echo off
@REM bison -d parser.y         
@REM flex lexer.l               
@REM gcc parser.tab.c lex.yy.c ast.c -o runtestparser -lfl  
@REM runtestparser             


@echo off
cd /d D:\Compiler-Frontend\server\src\parser

bison -d parser.y
flex lexer.l
gcc parser.tab.c lex.yy.c ast.c -o ../bin/runtestparser.exe -lfl

cd /d D:\Compiler-Frontend\server\src\bin
runtestparser.exe


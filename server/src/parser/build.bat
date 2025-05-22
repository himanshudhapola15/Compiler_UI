@echo off
setlocal

REM Move to the directory of the script
cd /d %~dp0

echo Running Bison...
C:\winflexbison\bison.exe -d parser.y
if errorlevel 1 (
    echo Error: Bison failed.
    exit /b 1
)

echo Running Flex...
C:\winflexbison\flex.exe lexer.l
if errorlevel 1 (
    echo Error: Flex failed.
    exit /b 1
)

echo Compiling with GCC...
gcc parser.tab.c lex.yy.c ast.c -o runtestparser.exe
if errorlevel 1 (
    echo Error: Compilation failed.
    exit /b 1
)

echo Running parser...
runtestparser.exe < parser_text.cm > output.txt
type output.txt

if errorlevel 1 (
    echo Error: Parser execution failed.
    exit /b 1
)

echo Done. tokens.txt should be generated.
endlocal

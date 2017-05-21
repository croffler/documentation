@echo off

echo Compiling navbar generator
rd target /S /Q
md target
javac src/iedoc/parser/* -d target

echo Running navbar generator
java -cp target xapdoc.parser.MenuTree %~dp0

bison -d trabalho.y
flex trabalho.l 
gcc -o trabalho trabalho.tab.c lex.yy.c
./trabalho teste.txt
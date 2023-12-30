#!/bin/bash
set -e

bison -d -o final.tab.c final.y
gcc -c -g -I. final.tab.c
lex -o lex.yy.c final.l
gcc -c -g -I. lex.yy.c
gcc -o final final.tab.o lex.yy.o -ll 
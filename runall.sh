#!/bin/bash
lex sspascal_v2.lxi
bison -d sspascal.y
gcc -Wall -g lex.yy.c sspascal.tab.c -o rezultat
CFLAGS= -lfl -o
DEBUGFLAGS = -Wall
LEX=compilMK.lex
OBJ=y.tab.c lex.yy.o
YACC=compilMK.yacc
BIN=analyseurProjet
LBIN=analyseurLex

.PHONY: all fcheck


all:
	@yacc -d $(YACC)
	@lex $(LEX)
	@gcc -c lex.yy.c
	@gcc $(OBJ) $(CFLAGS) $(BIN)
	./$(BIN) < fichier.md

t:
	lex tmp.lex
	@gcc -c lex.yy.c
	@gcc lex.yy.o $(CFLAGS) $(BIN)
	./$(BIN) < fichier.md

clean:
	rm $(OBJ) $(BIN)  lex.yy.c y.tab.h
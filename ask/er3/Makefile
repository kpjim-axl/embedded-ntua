.PHONY: clean dist-clean
CC=gcc

exec: string.o changed.o
	$(CC) -o exec $^

string.o: string.s
	$(CC) -o string.o -c $<

changed.o: changed.c
	$(CC) -o $@ -c $<

testing: string_manipulation.c exec
	$(CC) -o $@ string_manipulation.c

clean:
	$(RM) *.o testing *_out

dist-clean: clean
	$(RM) exec

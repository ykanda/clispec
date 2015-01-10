SRC = clispec.scm
OBJ = $(SRC:%.scm=%.o)
BIN = clispec

all: $(OBJ)
		csc -o $(BIN) $(OBJ)

test:
		./$(BIN) -s spec.scm 2>&1

clean:
	rm $(OBJ)
	rm $(BIN)

.scm.o:
	csc -c $<

.SUFFIXES : .scm .o 
.PHONEY : clean
.PHONEY : test

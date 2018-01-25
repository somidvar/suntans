SUNTANSHOME1=$(dir $(patsubst %/,%,$(CURDIR)))
SUNTANSHOME=$(SUNTANSHOME1)main
include $(SUNTANSHOME)/Makefile.in

ifneq ($(MPIHOME),)
  CC = $(MPIHOME)/bin/mpicc
  MPIDEF = 
  MPIINC = -I$(MPIHOME)
else
  CC = gcc
  MPIDEF = -DNOMPI
  MPIINC = 
endif

OPTFLAGS = -O2

ifneq ($(PARMETISHOME),)
  PARMETISINC = -I$(PARMETISHOME)/ParMETISLib
endif

ifneq ($(NETCDF4HOME),)
  NETCDFINC = -I$(NETCDF4HOME)/include
else
  NETCDFINC = 
endif
LD = $(CC) 
CFLAGS = 
MATHLIB = -lm

EXEC = iwaves
OBJS = 
SUN = $(SUNTANSHOME)/sun
datadir = data
INCLUDES = -I$(SUNTANSHOME) $(MPIINC) $(PARMETISINC) $(NETCDFINC)
DEFS = $(MPIDEF)
NUMPROCS = 15

all:	data

test:	data
	sh $(EXEC).sh $(NUMPROCS)

data:	$(SUN)

.c.o:	
	$(LD) -c $(INCLUDES) $(DEFS) $*.c

$(SUN):	initialization.o boundaries.o state.o sources.o
	cp initialization.o boundaries.o state.o sources.o $(SUNTANSHOME)
	make -C $(SUNTANSHOME)

debug:	data
	mkdir $(datadir)
	cp rundata/* $(datadir)
	$(MPIHOME)/bin/mpirun -np $(NUMPROCS) xterm -e gdb -command=gdbcommands $(SUN)

valgrind: data
	mkdir $(datadir)
	cp rundata/* $(datadir)
	$(MPIHOME)/bin/mpirun -np $(NUMPROCS) ./$(SUN) -g -vv --datadir=$(datadir)
	$(MPIHOME)/bin/mpirun -np $(NUMPROCS) valgrind --tool=memcheck --leak-check=yes ./$(SUN) -s -vvv --datadir=$(datadir)

clean:
	rm -f *.o
	rm -f IW-10001.e*
	rm -f IW-10001.o*
	rm -f *.pbs*

clobber: clean
	rm -rf *~ \#*\# PI* $(EXEC) gmon.out data rundata/*~

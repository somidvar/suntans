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

ifneq ($(PARMETISHOME),)
  PARMETISINC = -I$(PARMETISHOME)/ParMETISLib
endif
ifneq ($(NETCDF4HOME),)
  NETCDFINCLUDE=-I$(NETCDF4HOME)/include
  NETCDFDEF = -DUSENETCDF
else
  ifeq ($(filter $(MAKECMDGOALS),clean clobber),)
    $(error Error: This test case will not run if NETCDF4HOME is empty in ../../main/Makefile.in)
  endif
  NETCDFLIBDIR = 
  NETCDFINCLUDE = 
  NETCDFLD = 
  NETCDFSRC=
endif

LD = $(CC) 
CFLAGS = -std=gnu89
MATHLIB = -lm

EXEC = cylinder
OBJS = 
SUN = $(SUNTANSHOME)/sun
INCLUDES = -I$(SUNTANSHOME) $(MPIINC) $(PARMETISINC)
DEFS = $(MPIDEF)
NUMPROCS = 1

all:	data

test:   data
	sh $(EXEC).sh $(NUMPROCS)

debug:	data
	/opt/intel/openmpi/bin/mpirun -np $(NUMPROCS) xterm -e gdb $(SUN)
data:	$(SUN)

.c.o:	
	$(LD) $(CFLAGS) -c $(INCLUDES) $(DEFS) $*.c

$(SUN):	initialization.o boundaries.o state.o sources.o
	cp initialization.o boundaries.o state.o sources.o $(SUNTANSHOME)
	make -C $(SUNTANSHOME)

plot:
	cp -r $(SUNTANSHOME)/cmaps .
	$(SUNTANSHOME)/sunplot -np $(NUMPROCS) --datadir=data


clean:
	rm -f *.o
	rm -f log*.pbs.scm.out
	rm -f IW-*.e*
	rm -f IW-*.o*
	rm -f $(SUNTANSHOME)/*.o

clobber: clean
	rm -rf *~ \#*\# PI* $(EXEC) gmon.out data rundata/*~

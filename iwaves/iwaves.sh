#!/bin/sh
########################################################################
#
# Shell script to run a suntans test case.
#
########################################################################

module load mvapich2/2.1/gcc/4.4.7
module load hdf5/1.8.6/gcc/4.4.7
module load netcdf/4.1.3-v4/gcc/4.4.7

SUNTANSHOME=$(pwd)
SUNTANSHOME=$(echo ${SUNTANSHOME%/*}/main)
SUN=$SUNTANSHOME/sun
SUNPLOT=$SUNTANSHOME/sunplot

. $SUNTANSHOME/Makefile.in

maindatadir=rundata
datadir=data

NUMPROCS=$1

if [ -z "$MPIHOME" ] ; then
    EXEC=$SUN
else
    EXEC="$MPIHOME/bin/mpirun -np $NUMPROCS $SUN"
fi

if [ ! -d $datadir ] ; then
    cp -r $maindatadir $datadir
    echo Creating grid...
    if [ -z "$TRIANGLEHOME" ] ; then
	echo No triangle libraries installed.  
	echo Copying points.dat, cells.dat, and edges.dat from $maindatadir to $datadir
	$EXEC -g --datadir=$datadir
    else
	$EXEC -t -g --datadir=$datadir
    fi
else
    cp $maindatadir/suntans.dat $datadir/.
fi

echo Running suntans...
$EXEC -s -vv --datadir=$datadir


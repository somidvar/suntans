#!/bin/sh
########################################################################
#
# Shell script to run a suntans test case.
#
########################################################################

# SUNTANSHOME=/Users/fringer/suntans-periodic/main
SUNTANSHOME=../../main
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
    cp sources.c $datadir/.
    cp initialization.c $datadir/.
    echo Creating grid...
    $EXEC -g --datadir=$datadir
else
    cp $maindatadir/suntans.dat $datadir/.
    cp sources.c $datadir/.
    cp initialization.c $datadir/.
fi

echo Running suntans...
$EXEC -s -vv --datadir=$datadir


#!/bin/sh
########################################################################
#
# Shell script to run a suntans test case.
#
########################################################################


ml MVAPICH2/2.2-GCC-5.4.0-2.26
ml SUNTANS/20180305-foss-2016b
ml HDF5/1.8.7-foss-2016b
ml netCDF/4.1.3-foss-2016b-v4
ml gmvolf/2016b

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
    $EXEC -g -vvv --datadir=$datadir
else
    cp $maindatadir/suntans.dat $datadir/.
fi

echo Running suntans...
$EXEC -s -vv --datadir=$datadir


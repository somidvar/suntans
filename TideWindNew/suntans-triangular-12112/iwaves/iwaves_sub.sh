#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=IW-12112
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --time=30:00:00
#SBATCH --mem=25G
##SBATCH --mail-user=omidvar@uga.edu
##SBATCH --mail-type=BEGIN,END
#SBATCH --output=IW%j.out
#SBATCH --error=IW%j.err

ml load gmvolf/2018b
ml load SUNTANS/20180305-gmvolf-2018b
NUMPROCS=$SLURM_NTASKS


SUNTANSHOME=$(pwd)
SUNTANSHOME=$(echo ${SUNTANSHOME%/*}/main)
SUN=$SUNTANSHOME/sun
SUNPLOT=$SUNTANSHOME/sunplot
. $SUNTANSHOME/Makefile.in
maindatadir=rundata
datadir=data

make clobber
make data

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
$EXEC -s -vv --datadir=$datadir> IW${SLURM_JOB_ID}.out


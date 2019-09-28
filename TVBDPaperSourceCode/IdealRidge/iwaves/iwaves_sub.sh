#PBS -S /bin/bash
#PBS -q aquari_q
#PBS -N IdealRidge
#PBS -l nodes=3:ppn=48:aquarinode
#PBS -l walltime=400:00:00
#PBS -l mem=100gb
#PBS -M omidvar@uga.edu 
#PBS -m f

cd $PBS_O_WORKDIR

ml SUNTANS/20180305-gmvolf-2016b

echo
echo "Job ID: $PBS_JOBID"
echo "Queue:  $PBS_QUEUE"
echo "Cores:  $PBS_NP"
echo "Nodes:  $(cat $PBS_NODEFILE | sort -u | tr '\n' ' ')"
echo "mpirun: $(which mpirun)"
echo

SUNTANSHOME=$(pwd)
SUNTANSHOME=$(echo ${SUNTANSHOME%/*}/main)
SUN=$SUNTANSHOME/sun
SUNPLOT=$SUNTANSHOME/sunplot
. $SUNTANSHOME/Makefile.in
maindatadir=rundata
datadir=data
NUMPROCS=$MOAB_PROCCOUNT

make clobber

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
	$EXEC -g -v --datadir=$datadir
    fi
else
    cp $maindatadir/suntans.dat $datadir/.
fi
echo Running suntans...
$EXEC -s -vv --datadir=$datadir > log_${PBS_JOBID}.out

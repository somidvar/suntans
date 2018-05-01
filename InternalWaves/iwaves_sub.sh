#PBS -S /bin/bash
#PBS -q batch
#PBS -N IW-10001
#PBS -l nodes=1:ppn=48:aquarinode
#PBS -l walltime=15:00:00
#PBS -l mem=100gb
#PBS -M omidvar@uga.edu 
#PBS -m ae

cd $PBS_O_WORKDIR
module load mvapich2/2.1/gcc/4.4.7
module load hdf5/1.8.6/gcc/4.4.7
module load netcdf/4.1.3-v4/gcc/4.4.7
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

EXEC="$(which mpirun) -np 15 $SUN"

if [ ! -d $datadir ] ; then
    cp -r $maindatadir $datadir
    echo  "Creating grid..."
    $EXEC -g -vvv --datadir=$datadir
else
    cp $maindatadir/suntans.dat $datadir/.
fi

echo "Running suntans..."
$EXEC -s -vv --datadir=$datadir > log_${PBS_JOBID}.out

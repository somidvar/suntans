#PBS -S /bin/bash
#PBS -q aquari_q
#PBS -N IW-10001
#PBS -l nodes=1:ppn=48:aquarinode
#PBS -l walltime=24:00:00
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

make clobber
make data

. $SUNTANSHOME/Makefile.in

maindatadir=rundata
datadir=data

EXEC="$(which mpirun) -np 24 $SUN"

if [ ! -d $datadir ] ; then
    cp -r $maindatadir $datadir
    echo  "Creating grid..."
    $EXEC -g -vvv --datadir=$datadir
else
    cp $maindatadir/suntans.dat $datadir/.
fi

echo "Running suntans..."
$EXEC -s -vv --datadir=$datadir > log_${PBS_JOBID}.out

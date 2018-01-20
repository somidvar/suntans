#PBS -S /bin/bash
#PBS -q batch
#PBS -N MATLABJob10093
#PBS -l nodes=1:ppn=24:aquarinode
#PBS -l walltime=10:00:00
#PBS -l mem=200gb
#PBS -M omidvar@uga.edu 
#PBS -m e

cd $PBS_O_WORKDIR

module load matlab/R2016b

echo
echo "Job ID: $PBS_JOBID"
echo "Queue:  $PBS_QUEUE"
echo "Cores:  $PBS_NP"
echo "Nodes:  $(cat $PBS_NODEFILE | sort -u | tr '\n' ' ')"
echo "mpirun: $(which mpirun)"
echo

matlab -nodisplay </lustre1/omidvar/work-directory_0801/MatlabFiles/MainSingle10093.m> matlab_${PBS_JOBID}.out
#!/bin/bash


if [ ! -e .passed_mpi_master_worker ] ;
then
   echo Must pass \`make test\` before queuing
   exit 1 
fi



# yea, uhh we not letting you submit multiple bench
running=$(squeue -u ${USER} | egrep "run_numint.*[R|PD]")
if [ -n "${running}" ] ;
then
    echo "------------------------------------"
    echo ${USER} has this job in the queue or running 
    squeue | grep ${USER}
    echo
    echo please delete this job or wait for it to complete
    exit 1
fi

# import params
source ../params.sh


for NP in ${NODES} ;
do 
   for P in ${PS} ;
   do
       NPP=$(expr ${NP} \* ${P})
       if [ "$NPP" -le 32 ] ;
       then
         sbatch --partition=Centaurus --time=00:20:00 --nodes=${NP} --ntasks-per-node=${P} run_numint.sh
       fi
   done
done 


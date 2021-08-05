#!/bin/bash

#SBATCH --ntasks=32
#SBATCH -t 00-03:00:00


echo "Scrpt Start"

echo "Core Number:"
nproc --all

pwd
ls

echo "load MatLab"
module load matlab/R2020a


matlab -nodisplay -nosplash -nodesktop -r "run('./experiment_R1_undirected.m');exit;" | tail -n +11


echo "Scrpt End"
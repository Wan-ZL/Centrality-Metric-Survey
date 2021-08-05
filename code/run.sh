#!/bin/bash  

module load matlab

echo "Matlab loaded"

matlab -nodisplay -nodesktop -r "run experiment_R6_undirected.m, exit"

exit $?
#!/bin/bash

#$ -N my_simulation             # Specify job name
#$ -j y                         # Merge standard output and standard error
#$ -l h_rt=01:00:00             # Request 1 hour of runtime
#$ -l h_vmem=1G                 # Request 1 GB of virtual memory per slot
#$ -t 1-25                      # Specify the task range for the array job

# load requisite modules
module load R/4.3.1

# Calculate parameter setting for this task via scheduler's $SGE_TASK_ID
parameter_value=$SGE_TASK_ID

# Run the simulation with the specific parameter value
Rscript run_sim.R $param
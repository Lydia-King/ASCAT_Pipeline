#!/bin/bash 

rfile=$1
shift
#module load singularity
#singularity exec de_libra $rfile $* 
Rscript $rfile $*

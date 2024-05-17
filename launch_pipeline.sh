#!/bin/bash
#SBATCH --partition=componc_cpu,componc_gpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=8GB
#SBATCH --job-name=nanoseqtest
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm%j_snkmk.out


## activate nf-core conda environment
source /home/preskaa/miniconda3/bin/activate nf-core

## load modules
module load singularity/3.7.1
module load java/20.0.1
## example samplesheet
## technical replicates get merged ...
samplesheet=${HOME}/nanoseq/resources/samplesheet.csv
## specify path to out directory
outdir=/data1/shahs3/users/preskaa/APS022_Archive/240516_nanoseq_test

nextflow run apsteinberg/nanoseq \
  -c ${PWD}/conf/iris.config \
  -profile singularity,slurm \
  --input ${samplesheet} \
  --outdir ${outdir} \
  -params-file nf-params.json


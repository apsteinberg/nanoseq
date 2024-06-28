#!/bin/bash
#SBATCH --partition=componc_cpu,componc_gpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=8GB
#SBATCH --job-name=061
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=preskaa@mskcc.org
#SBATCH --output=slurm%j_TCDO-SAR-061.out


## activate nf-core conda environment
source /home/preskaa/miniconda3/bin/activate nf-core

## load modules
module load singularity/3.7.1
module load java/20.0.1
## example samplesheet
## technical replicates get merged ...
samplesheet=${HOME}/nanoseq/resources/TCDO-SAR-061_samplesheet.csv
## specify path to out directory
outdir=/data1/shahs3/users/preskaa/APS022.1_Archive/nanoseq

## reference genome for chopper (if sample is PDX)
mouse_refgenome=/data1/shahs3/isabl_data_lake/assemblies/WGS-MM10/mouse/mm10_build38_mouse.fasta

## last two flags trigger chopper to differentiate mouse from human reads for PDX samples
## these flags should not be used for human samples
cd ${outdir}

nextflow run apsteinberg/nanoseq \
  -c ${HOME}/nanoseq/conf/iris.config \
  -profile singularity,slurm \
  --input ${samplesheet} \
  --outdir ${outdir} \
  -work-dir ${outdir}/work \
  -params-file ${HOME}/nanoseq/nf-params.json


#nextflow run apsteinberg/nanoseq -resume 6c03bf60-99ea-41cd-a949-c30986899f14


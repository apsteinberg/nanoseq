#!/bin/bash
#SBATCH --partition=componc_cpu,componc_gpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=20:00:00
#SBATCH --mem=40GB
#SBATCH --job-name=seqtk
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=preskaa@mskcc.org
#SBATCH --output=slurm%j_seqtk.out


## activate nf-core conda environment
source /home/preskaa/miniconda3/bin/activate base

## example samplesheet
## technical replicates get merged ...
samplesheet=${HOME}/nanoseq/resources/samplesheet.csv
## specify path to out directory
outdir=/data1/shahs3/users/preskaa/APS022_Archive/240516_nanoseq_test
fastqdir=${outdir}/test_fastq

mkdir -p ${fastqdir}

input_fastq=/data1/shahs3/isabl_data_lake/experiments/08/05/20805/data/SHAH_H003459_T01_01_TR01_283158a9b4928462_TCDO-SAR-033-PDX-A_R1_001.fastq.gz
output_fastq=${fastqdir}/TCDO-SAR-033-PDX.downsampled.fastq.gz
seqtk sample -s100 ${input_fastq} 0.01 | gzip > ${output_fastq}

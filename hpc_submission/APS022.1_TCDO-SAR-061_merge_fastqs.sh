#!/bin/bash
#SBATCH --partition=componc_cpu,componc_gpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=100GB
#SBATCH --job-name=061merge
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=preskaa@mskcc.org
#SBATCH --output=slurm%j_merge_061.out

archive=/data1/shahs3/users/preskaa/fastqs/ont_rna/TCDO-SAR-061
out_dir=${archive}/merged
cd ${archive}
mkdir -p ${out_dir}
## combine fastqs ...
cat ${archive}/*.fastq.gz > ${out_dir}/TCDO-SAR-061.merged.fastq.gz**


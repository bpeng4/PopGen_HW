#!/bin/bash -l
#SBATCH --time=168:00:00          # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=5G       # Maximum memory required per CPU (in megabytes)
#SBATCH --partition=benson,batch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH -D /work/agro932/bpeng4/PopGen_HW
#SBATCH -o /work/agro932/bpeng4/PopGen_HW/slurm-script/align-stdout-%j.txt
#SBATCH -e /work/agro932/bpeng4/PopGen_HW/slurm-script/align-stderr-%j.txt
#SBATCH -J Bwa_align
#SBATCH --mail-user=bpeng4@huskers.unl.edu
#SBATCH --mail-type=END #email if ends
#SBATCH --mail-type=FAIL #email if fails
set -e
set -u

module load bwa samtools
cd /work/agro932/bpeng4/PopGen_HW/largedata

# Align reads to the reference genome
#for i in 56 58 63 68 69 86 87 88 89 90; do
#bwa mem chr1.fasta SRR111191${i}_1.fastq SRR111191${i}_2.fastq | samtools view -bSh - > SRR111191${i}.bam
#done

# Sort BAM files
for i in *.bam; do
samtools sort "$i" -o "sorted_$i"
done

# Index the sorted BAM files
for i in sorted_*.bam; do
samtools index "$i"
done

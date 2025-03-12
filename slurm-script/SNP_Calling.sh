#!/bin/bash -l
#SBATCH -D /work/agro932/bpeng4/PopGen_HW/
#SBATCH -o /work/agro932/bpeng4/PopGen_HW/slurm-log/stdout-%A_%a.txt
#SBATCH -e /work/agro932/bpeng4/PopGen_HW/slurm-log/stderr-%A_%a.txt
#SBATCH -J SNP_calling
#SBATCH -t 168:00:00
#SBATCH --array=56,58,63,68,69,86,87,88,89,90  # Define an array job with specific task IDs
#SBATCH --mem-per-cpu=5G
#SBATCH --partition=benson,batch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36


set -e
set -u

# Load required modules
module load samtools bcftools

# Change to the working directory
cd /work/agro932/bpeng4/PopGen_HW/largedata

# Define sample ID from the SLURM array index
SAMPLE_ID=$SLURM_ARRAY_TASK_ID

# Step 1: Index the sorted BAM file (if not already indexed)
if [ ! -f sorted_SRR111191${SAMPLE_ID}.bam.bai ]; then
    samtools index sorted_SRR111191${SAMPLE_ID}.bam    
fi

# Step 2: Generate mpileup file
bcftools mpileup -f chr1.fasta sorted_SRR111191${SAMPLE_ID}.bam > sorted_SRR111191${SAMPLE_ID}.mpileup

# Step 3: Call SNPs
bcftools call -m --ploidy 1 -Ob -o SRR111191${SAMPLE_ID}.bcf sorted_SRR111191${SAMPLE_ID}.mpileup

# Step 4: Index the VCF file
bcftools index SRR111191${SAMPLE_ID}.bcf

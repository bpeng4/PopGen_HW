#!/bin/bash -l
#SBATCH -D /work/agro932/bpeng4/PopGen_HW/
#SBATCH -o /work/agro932/bpeng4/PopGen_HW/slurm-log/stdout-%A_%a.txt
#SBATCH -e /work/agro932/bpeng4/PopGen_HW/slurm-log/stderr-%A_%a.txt
#SBATCH -J Theta_Calculation
#SBATCH -t 168:00:00
#SBATCH --mem-per-cpu=5G       
#SBATCH --partition=benson,batch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36


set -e
set -u

# Step1: Index Your Reference Genome

module load samtools/1.20 angsd/0.937
cd /work/agro932/bpeng4/PopGen_HW/largedata
samtools faidx chr1.fasta


# Step 2: Prepare BAM File List

ls sorted_SRR11119156.bam sorted_SRR11119158.bam sorted_SRR11119163.bam sorted_SRR11119168.bam sorted_SRR11119169.bam  > bam_teosinte_list.txt
ls sorted_SRR11119186.bam sorted_SRR11119187.bam sorted_SRR11119188.bam sorted_SRR11119189.bam sorted_SRR11119190.bam  > bam_landrace_list.txt


# Step 3: Generate Site Frequency Spectrum (SFS)

angsd -bam bam_teosinte_list.txt  -doMaf 1 -doMajorMinor 1 -uniqueOnly 1 -minMapQ 30 -minQ 20 -minInd 5 -doSaf 1 -anc chr1.fasta -GL 2 -out teosinte -P 4
angsd -bam bam_landrace_list.txt  -doMaf 1 -doMajorMinor 1 -uniqueOnly 1 -minMapQ 30 -minQ 20 -minInd 5 -doSaf 1 -anc chr1.fasta -GL 2 -out landrace -P 4


# Step 4a: Estimate the SFS from SAF index
realSFS teosinte.saf.idx -P 4 > teosinte.sfs
realSFS landrace.saf.idx -P 4 > landrace.sfs

# Step 4b: Compute theta using the SFS
realSFS saf2theta teosinte.saf.idx -outname teosinte -sfs teosinte.sfs -fold 1 -P 4
realSFS saf2theta landrace.saf.idx -outname landrace -sfs landrace.sfs -fold 1 -P 4


# Step 5: Extract theta estimates using a 5 kb window size with a 1 kb step size.

thetaStat do_stat teosinte.thetas.idx -win 5000 -step 1000 -outnames teosinte.thetasWindow5kb_1kb
thetaStat do_stat landrace.thetas.idx -win 5000 -step 1000 -outnames landrace.thetasWindow5kb_1kb
cp teosinte.thetasWindow5kb_1kb.pestPG /work/agro932/bpeng4/PopGen_HW/cache/
cp landrace.thetasWindow5kb_1kb.pestPG /work/agro932/bpeng4/PopGen_HW/cache/







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

#Set working directory
cd /work/agro932/bpeng4/PopGen_HW/largedata

module load bcftools

#Merge all bcf files
bcftools merge -Ob -o merged.bcf SRR11119156.bcf SRR11119158.bcf SRR11119163.bcf SRR11119168.bcf SRR11119169.bcf SRR11119186.bcf SRR11119187.bcf SRR11119188.bcf SRR11119189.bcf SRR11119190.bcf
bcftools index merged.bcf

# Filter for Biallelic SNPs
bcftools view -m2 -M2 -v snps -Ob -o merged_biallelic_snps.bcf merged.bcf

# get a summary of the VCF file
bcftools stats  merged_biallelic_snps.bcf > vcf_summary.txt


# Convert VCF to Tab-Delimited Format

bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%DP[\t%GT]\n' merged_biallelic_snps.bcf > snp_calls.txt

# Convert VCF to PLINK format

module load plink/1.90
plink --bcf merged_biallelic_snps.bcf --allow-extra-chr --make-bed --out merged_variants

# move merged files to a new folder
mkdir -p merged
mv merged_varaints* merged/

# get the missing data and maf PCA
plink --bfile merged_variants --allow-extra-chr --missing --freq --pca 20 --out merged_variants

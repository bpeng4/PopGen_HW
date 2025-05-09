# Experimental Design and Methods

## Plant Materials and DNA Sequencing

In this paper, 17 lines of landrances and 20 lines of teosinte(Z.mays
ssp. parviglumis) were selected. DNA extraction was done for landrances
and teosinte at their thrid leaf stage. The the whole-genome
sequencing(WGS) and WGBS were done for the extracted DNA samples.
Fourtheen lines of modern maize WGBS data was included in the data also.

## Sequencing Data Analysis

The WGS sequencing data was matched to the B73 reference genome(AGPv4)
by BWA-mem. Then the duplicated reads were removed by Picard toools and
the SNP calling was performed by Genome Analysis Toolkit’s(GATK, version
4.1). PseudoRef, a software, was used to improve the WGBS mapping rate
and decrease the mapping bias. Then, Bowtie2 was used to map reads to
each corrected pseudo-reference genome and then only the unique mapped
reads were kept. Bismark methylation extractor was used to select reads
with more than three mapped reads.

## Genome scanning to detect selective signals

We called SNPs using our WGS data and performed genome scanning for
selective signals using XP-CLR method81. In the XP-CLR analysis, we used
a 50 kb sliding window and a 5 kb step size. To ensure comparability of
the composite likelihood score in each window, we fixed the number
assayed in each window to 200 SNPs.

# Own Words:

17 lines of landrances(domesticated population) and 20 lines of
teosinte(wild population) were used in this study. For homework, 5 lines
from landrance and 5 lines from teosinte were selected

Here are the information for genome size and sequencing methods for each
line:

-   GSM4321851: Landrace\_WGS\_PI-628514; Zea mays;
    OTHER(Accession:SRX7756161): ILLUMINA(Illumina HiSeq 2000); 24.5
    bases
-   GSM4321850: Landrace\_WGS\_PI-628503; Zea mays;
    OTHER(Accession:SRX7756160): ILLUMINA(Illumina HiSeq 2000); 24.3
    bases
-   GSM4321849: Landrace\_WGS\_PI-620860; Zea mays;
    OTHER(Accession:SRX7756159): ILLUMINA(Illumina HiSeq 2000); 24.2
    bases
-   GSM4321848: Landrace\_WGS\_PI-620859; Zea mays;
    OTHER(Accession:SRX7756158): ILLUMINA(Illumina HiSeq 2000); 24.6
    bases
-   GSM4321847: Landrace\_WGS\_PI-620856; Zea mays;
    OTHER(Accession:SRX7756157): ILLUMINA(Illumina HiSeq 2000); 24.4
    bases
-   GSM4321830: Teosinte\_WGS\_JRIAL2P; Zea mays;
    OTHER(Accession:SRX7756204): ILLUMINA(Illumina HiSeq 2000); 73.1
    bases
-   GSM4321829: Teosinte\_WGS\_JRIAL2O; Zea mays;
    OTHER(Accession:SRX7756203): ILLUMINA(Illumina HiSeq 2000); 72.8
    bases
-   GSM4321824: Teosinte\_WGS\_JRIAL2J; Zea mays;
    OTHER(Accession:SRX7756198): ILLUMINA(Illumina HiSeq 2000); 73.6
    bases
-   GSM4321819: Teosinte\_WGS\_JRIAL2E; Zea mays;
    OTHER(Accession:SRX7756193): ILLUMINA(Illumina HiSeq 2000); 72.3
    bases
-   GSM4321817: Teosinte\_WGS\_JRIAL2C; Zea mays;
    OTHER(Accession:SRX7756191): ILLUMINA(Illumina HiSeq 2000); 74 bases

Here are the information for the reference genome and gene annotation
files:

## Code to download data to HCC

### Creat an anaconda environment and install sra tools

    cd /home/agro932/bpeng4/
    ml anaconda
    conda create -n homework1 numpy=1.17       
    conda activate homework1 
    conda install -c bioconda aspera-cli

### Change to work directory

    cd /work/agro932/bpeng4/HW1

### Creat a list of SRR numbers

    cat > srr_list_hw1.txt <<EOF
    SRR11119156
    SRR11119158
    SRR11119163
    SRR11119168
    SRR11119169
    SRR11119186
    SRR11119187
    SRR11119188
    SRR11119189
    SRR11119190
    EOF

### Loop With No Size Limit

    while read SRR; do
        prefetch --max-size 0 $SRR  # Remove file size limit for all SRR numbers
    done < srr_list_hw1.txt

### Download SRA files amd Extract Them

    while read SRR; do
        fastq-dump --split-files --gzip $SRR
    done < srr_list_hw1.txt

### Data and Data Processing Log Avaliable on HCC

    cd /work/agro932/bpeng4/PopGen_HW/largedata
    cd /work/agro932/bpeng4/PopGen_HW/log

### Unzip files

    for file in *.gz; do
        gunzip -c "$file" > "${file%.gz}"
    done

### Download B73 V5 SRA files and Extract it

    wget https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0.fa.gz
    gunzip Zm-B73-REFERENCE-NAM-5.0.fa.gz

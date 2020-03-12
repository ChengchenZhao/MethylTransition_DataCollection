hisat2_index=/mnt/Storage/home/zhaochengchen/Data/hg19/hg19
refseq_gtf=/mnt/Storage/home/zhaochengchen/Data/hg19/hg19_refSeq_symbol.gtf
refseq_bed=/mnt/Storage/home/zhaochengchen/Data/hg19/hg19.refseq.bed

data_path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE71318_hgICMTE_RNAseq
log_path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE71318_hgICMTE_RNAseq/log

ICM_1=SRR2130120
ICM_2=SRR2130121
ICM_3=SRR2130122
TE_1=SRR2130123
TE_2=SRR2130124
TE_3=SRR2130125

for sample in ICM_1 ICM_2 ICM_3 TE_1 TE_2 TE_3
do
	cd ~/Work/1.scMethylome/data/GSE71318_hgICMTE_RNAseq/
	mkdir ${sample}
	cd ${sample}
	cutadapt -q 30 -m 30 -g AAGCAGTGGTATCAACGCAGAGTACATGGG -G AAGCAGTGGTATCAACGCAGAGTACATGGG -a "A{100}" -a "T{100}" -A "A{100}" -A "T{100}" -o ${sample}_1.fastq.gz -p ${sample}_2.fastq.gz ../${!sample}_1.fastq.gz ../${!sample}_2.fastq.gz
	nohup hisat2 -p 15 --dta -x ${hisat2_index} -1 ${sample}_1.fastq.gz -2 ${sample}_2.fastq.gz -S ${sample}.align.sam > ${sample}.align.log 2>&1
	nohup samtools sort -@ 15 -o ${sample}.bam ${sample}.align.sam > ${sample}.sam_sort.log 2>&1
	nohup stringtie -e -B -p 15 -G ${refseq_gtf} -o ${sample}.gtf ${sample}.bam > ${sample}.stringtie.log 2>&1

	rm ${sample}.align.sam
done


###################################################################################################
#####################################   1.read distribution   #####################################
###################################################################################################
for sample in ICM_1 ICM_2 ICM_3 TE_1 TE_2 TE_3
do
	cd ~/Work/1.scMethylome/data/GSE71318_hgICMTE_RNAseq/
	read_distribution.py -i ${sample}/${sample}.bam -r ${refseq_bed} > ${log_path}/${sample}.readsDistribution
	echo ${sample}
done

###################################################################################################
#############################   2.1 get mapping infomation               ##########################
#############################   2.2 get read distribution infomation     ##########################
#############################   2.3 gene_expression_matrix               ##########################
#############################   2.4 create gtf_file_path.txt             ##########################
###################################################################################################
python RNA_seq_preprocessing.py

python /mnt/Storage/home/zhaochengchen/bin/RemoveDuplicateGenes.py merge_fpkm.txt GSE71318_hgICMTEFPKM.txt

###################################################################################################
#####################################   2.gene_count_matrix   #####################################
###################################################################################################
gtf_file_path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE71318_hgICMTE_RNAseq/gtf_file_path.txt
path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE71318_hgICMTE_RNAseq

python ~/bin/prepDE.py -i ${gtf_file_path} -g ${path}/gene_count.txt -t ${path}/transcript_count.txt > count_convertion.log 2>&1

sed -i "s/,/\t/g" ${path}/gene_count.txt
sed -i "s/,/\t/g" ${path}/transcript_count.txt

mv ${path}/gene_count.txt ${path}/GSE71318_hgICMTECounts.txt

###################################################################################################
#####################################     3.DEG detection     #####################################
###################################################################################################

# DESeq2
cd DESeq2
Rscript DESeq2.r


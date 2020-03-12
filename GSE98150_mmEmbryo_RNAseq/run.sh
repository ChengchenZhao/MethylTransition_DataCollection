hisat2_index=/mnt/Storage/home/zhaochengchen/Data/mm9/mm9
refseq_gtf=/mnt/Storage/home/zhaochengchen/Data/mm9/mm9_refSeqsymbol_new.gtf
refseq_bed=/mnt/Storage/home/zhaochengchen/Data/mm9/mm9.refseq.bed

data_path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE98150_mmEmbryo_RNAseq
log_path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE98150_mmEmbryo_RNAseq/log

ICM_1=SRR5479533
ICM_2=SRR5479534
ICM_3=SRR5479535
ICM_4=SRR5479536
TE_1=SRR5479537
TE_2=SRR5479538
TE_3=SRR5479539
TE_4=SRR5479540

for sample in ICM_1 ICM_2 ICM_3 ICM_4 TE_1 TE_2 TE_3 TE_4
do
	cd ~/Work/1.scMethylome/data/GSE98150_mmEmbryo_RNAseq/
	mkdir ${sample}
	cd ${sample}
	# cutadapt -q 30 -m 30 -g AAGCAGTGGTATCAACGCAGAGTACATGGG -G AAGCAGTGGTATCAACGCAGAGTACATGGG -a "A{100}" -a "T{100}" -A "A{100}" -A "T{100}" -o ${!sample}/${sample}_1.fastq.gz -p ${!sample}/${sample}_2.fastq.gz ${!sample}/${!sample}_1.clean.fq.gz ${!sample}/${!sample}_2.clean.fq.gz
	# cutadapt -q 30 -m 30 -g AAGCAGTGGTATCAACGCAGAGTACATGGG -a "A{100}" -a "T{100}" -o ${sample}_cut.fastq ${!sample}.fastq
	# nohup hisat2 -p 10 --dta -x ${hisat2_index} -U ${sample}_cut.fastq -S ${sample}.align.sam > ${sample}.align.log 2>&1

	nohup hisat2 -p 15 --dta -x ${hisat2_index} -1 ../${!sample}_1.fastq -2 ../${!sample}_2.fastq -S ${sample}.align.sam > ${sample}.align.log 2>&1
	nohup samtools sort -@ 15 -o ${sample}.bam ${sample}.align.sam > ${sample}.sam_sort.log 2>&1
	nohup stringtie -e -B -p 15 -G ${refseq_gtf} -o ${sample}.gtf ${sample}.bam > ${sample}.stringtie.log 2>&1

	gzip ../${!sample}_*.fastq
	# rm ${sample}_cut.fastq
	rm ${sample}.align.sam
done


###################################################################################################
#####################################   1.read distribution   #####################################
###################################################################################################
for sample in ICM_1 ICM_2 ICM_3 ICM_4 TE_1 TE_2 TE_3 TE_4
do
	cd ~/Work/1.scMethylome/data/GSE98150_mmEmbryo_RNAseq/
	read_distribution.py -i ${sample}/${sample}.bam -r ${refseq_bed} > ${log_path}/${sample}.readsDistribution &
	echo ${sample}
done

###################################################################################################
#############################   2.1 get mapping infomation               ##########################
#############################   2.2 get read distribution infomation     ##########################
#############################   2.3 gene_expression_matrix               ##########################
#############################   2.4 create gtf_file_path.txt             ##########################
###################################################################################################
python RNA_seq_preprocessing.py

python /mnt/Storage/home/zhaochengchen/bin/RemoveDuplicateGenes.py merge_fpkm.txt GSE98150_mmEmbryoFPKM.txt

###################################################################################################
#####################################   2.gene_count_matrix   #####################################
###################################################################################################
gtf_file_path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE98150_mmEmbryo_RNAseq/gtf_file_path.txt
path=/mnt/Storage/home/zhaochengchen/Work/1.scMethylome/data/GSE98150_mmEmbryo_RNAseq

python ~/bin/prepDE.py -i ${gtf_file_path} -g ${path}/gene_count.txt -t ${path}/transcript_count.txt > count_convertion.log 2>&1

sed -i "s/,/\t/g" ${path}/gene_count.txt
sed -i "s/,/\t/g" ${path}/transcript_count.txt

mv ${path}/gene_count.txt ${path}/GSE98150_mmEmbryoCounts.txt

###################################################################################################
#####################################     3.DEG detection     #####################################
###################################################################################################


for sample in ICM_1 ICM_2 ICM_3 ICM_4 TE_1 TE_2 TE_3 TE_4
do
	samtools view ${sample}/${sample}.bam | gfold count -ann /mnt/Storage/home/zhaochengchen/Data/mm9/mm9_refSeq_symbol.gtf -tag stdin -o ${sample}/${sample}.read_cnt
	mv ${sample}.read_cnt ${sample}/${sample}.read_cnt
done

mkdir GFOLD
cd GFOLD
gfold diff -s1 ../ICM_1/ICM_1,../ICM_2/ICM_2,../ICM_3/ICM_3,../ICM_4/ICM_4 -s2 ../TE_1/TE_1,../TE_2/TE_2,../TE_3/TE_3,../TE_4/TE_4 -suf .read_cnt -o ICM_TE.diff

mkdir cutoff_0.3
mkdir cutoff_0.58
mkdir cutoff_1.2
for sample in ICM_TE
do
	awk -v "OFS=\t" '{if ($3 >= 0.3) print $1}' ${sample}.diff  > cutoff_0.3/${sample}_up.deg
	awk -v "OFS=\t" '{if ($3 <= -0.3) print $1}' ${sample}.diff  > cutoff_0.3/${sample}_dn.deg
	awk -v "OFS=\t" '{if ($3 > -0.3 && $3 < 0.3) print $1}' ${sample}.diff  > cutoff_0.3/${sample}_no.deg
	grep -v "#" cutoff_0.3/${sample}_up.deg > cutoff_0.3/${sample}_up.geneSymbol
	grep -v "#" cutoff_0.3/${sample}_dn.deg > cutoff_0.3/${sample}_dn.geneSymbol
	grep -v "#" cutoff_0.3/${sample}_no.deg > cutoff_0.3/${sample}_no.geneSymbol
	wc -l cutoff_0.3/${sample}_up.geneSymbol
	wc -l cutoff_0.3/${sample}_dn.geneSymbol
	wc -l cutoff_0.3/${sample}_no.geneSymbol

	awk -v "OFS=\t" '{if ($3 >= 0.58) print $1}' ${sample}.diff  > cutoff_0.58/${sample}_up.deg
	awk -v "OFS=\t" '{if ($3 <= -0.58) print $1}' ${sample}.diff  > cutoff_0.58/${sample}_dn.deg
	awk -v "OFS=\t" '{if ($3 > -0.58 && $3 < 0.58) print $1}' ${sample}.diff  > cutoff_0.58/${sample}_no.deg
	grep -v "#" cutoff_0.58/${sample}_up.deg > cutoff_0.58/${sample}_up.geneSymbol
	grep -v "#" cutoff_0.58/${sample}_dn.deg > cutoff_0.58/${sample}_dn.geneSymbol
	grep -v "#" cutoff_0.58/${sample}_no.deg > cutoff_0.58/${sample}_no.geneSymbol
	wc -l cutoff_0.58/${sample}_up.geneSymbol
	wc -l cutoff_0.58/${sample}_dn.geneSymbol
	wc -l cutoff_0.58/${sample}_no.geneSymbol

	awk -v "OFS=\t" '{if ($5 >= 1.2) print $1}' ${sample}.diff  > cutoff_1.2/${sample}_up.deg
	awk -v "OFS=\t" '{if ($5 <= -1.2) print $1}' ${sample}.diff  > cutoff_1.2/${sample}_dn.deg
	awk -v "OFS=\t" '{if ($5 > -1.2 && $5 < 1.2) print $1}' ${sample}.diff  > cutoff_1.2/${sample}_no.deg
	grep -v "#" cutoff_1.2/${sample}_up.deg > cutoff_1.2/${sample}_up.geneSymbol
	grep -v "#" cutoff_1.2/${sample}_dn.deg > cutoff_1.2/${sample}_dn.geneSymbol
	grep -v "#" cutoff_1.2/${sample}_no.deg > cutoff_1.2/${sample}_no.geneSymbol
	wc -l cutoff_1.2/${sample}_up.geneSymbol
	wc -l cutoff_1.2/${sample}_dn.geneSymbol
	wc -l cutoff_1.2/${sample}_no.geneSymbol
done

rm */*.deg



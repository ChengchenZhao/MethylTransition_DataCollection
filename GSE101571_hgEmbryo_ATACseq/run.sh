# PCGA.py -t GSE101571_4cell_3pn_peaks.bed -n hg_4cell_3pn --op down --symbol -g ~/Data/hg19/hg19.refGene
# PCGA.py -t GSE101571_8cell_2pn_peaks.bed -n hg_8cell_2pn --op down --symbol -g ~/Data/hg19/hg19.refGene
# PCGA.py -t GSE101571_8cell_3pn_peaks.bed -n hg_8cell_3pn --op down --symbol -g ~/Data/hg19/hg19.refGene

###############################################################################################
######################################     1.mapping     ######################################
###############################################################################################
hg19_index=~/Data/hg19/hg19
hg19_len=~/Data/hg19/hg19.len

gunzip *.gz
# cat SRR5837324_1.fastq SRR5837325_1.fastq > hg_C4_1_ATAC_1.fastq
# cat SRR5837326_1.fastq SRR5837327_1.fastq SRR5837328_1.fastq > hg_C4_2_ATAC_1.fastq
cat SRR5837329_1.fastq SRR5837330_1.fastq > hg_C8_1_ATAC_1.fastq
cat SRR5837331_1.fastq SRR5837332_1.fastq > hg_C8_2_ATAC_1.fastq
cat SRR5837333_1.fastq SRR5837334_1.fastq > hg_C8_3_ATAC_1.fastq
cat SRR5837335_1.fastq SRR5837336_1.fastq > hg_C8_4_ATAC_1.fastq
# cat SRR5837324_2.fastq SRR5837325_2.fastq > hg_C4_1_ATAC_2.fastq
# cat SRR5837326_2.fastq SRR5837327_2.fastq SRR5837328_2.fastq > hg_C4_2_ATAC_2.fastq
cat SRR5837329_2.fastq SRR5837330_2.fastq > hg_C8_1_ATAC_2.fastq
cat SRR5837331_2.fastq SRR5837332_2.fastq > hg_C8_2_ATAC_2.fastq
cat SRR5837333_2.fastq SRR5837334_2.fastq > hg_C8_3_ATAC_2.fastq
cat SRR5837335_2.fastq SRR5837336_2.fastq > hg_C8_4_ATAC_2.fastq
# rm SRR*.fastq

# for sample in hg_C4_1_ATAC hg_C4_2_ATAC hg_C8_1_ATAC hg_C8_2_ATAC hg_C8_3_ATAC hg_C8_4_ATAC
for sample in hg_C8_1_ATAC hg_C8_2_ATAC hg_C8_3_ATAC hg_C8_4_ATAC
do 
	mkdir ${sample}
	bowtie2 -q -p 15 -x ${hg19_index} -1 ${sample}_1.fastq -2 ${sample}_2.fastq -S ${sample}/${sample}.sam
	gzip ${sample}_1.fastq
	gzip ${sample}_2.fastq
	samtools view -@ 15 -bt ${hg19_len} ${sample}/${sample}.sam -o ${sample}/${sample}.bam

	samtools view -H ${sample}/${sample}.bam > ${sample}/${sample}_filtered.sam 
	samtools view -f 0x2 ${sample}/${sample}.bam | awk 'NR % 2 == 1{mapq=$5;forward=$0} NR % 2 == 0{if($5>=30 && mapq>=30 && substr($3,1,3)=="chr" && $3!="chrM") print forward"\n"$0}' >> ${sample}/${sample}_filtered.sam
	samtools view -bS ${sample}/${sample}_filtered.sam > ${sample}/${sample}_filtered.bam
	rm ${sample}/${sample}.sam ${sample}/${sample}_filtered.sam 
	bamToBed -bedpe -i ${sample}/${sample}_filtered.bam | awk '{print $1"\t"$2"\t"$6}' | sort -k1,1 -k2,2n | uniq > ${sample}/${sample}_fragments.bed 
	awk 'BEGIN{srand(1007)} {if(rand()<0.5) print $1"\t"$2"\t"$2+50; else if($3-50<0) print $1"\t0\t"$3; else print $1"\t"$3-50"\t"$3}' ${sample}/${sample}_fragments.bed | awk '{if($2<0) print $1"\t0\t"$3; else print $0}' | sort -k1,1 -k2,2g > ${sample}/${sample}_reads.bed 
	genomeCoverageBed -bga -i ${sample}/${sample}_reads.bed -g ${hg19_len} > ${sample}/${sample}_reads.bdg 
	bedClip ${sample}/${sample}_reads.bdg ${hg19_len} ${sample}/${sample}_reads_clip.bdg
	bedSort ${sample}/${sample}_reads_clip.bdg ${sample}/${sample}_reads.bdg.tep
	bedGraphToBigWig ${sample}/${sample}_reads.bdg.tep ${hg19_len} ${sample}/${sample}.bw
	rm ${sample}/${sample}_reads.bdg 
	rm ${sample}/${sample}_reads.bdg.tep 
	rm ${sample}/${sample}_reads_clip.bdg
done

#######################################################################################################
#######################################     2.PromoterSignal     ######################################
#######################################################################################################
hg_promoter=/mnt/Storage/home/zhaochengchen/Data/hg19/hg19.refseq.Promoter
# for sample in hg_C4_1_ATAC hg_C4_2_ATAC hg_C8_1_ATAC hg_C8_2_ATAC hg_C8_3_ATAC hg_C8_4_ATAC
for sample in hg_C8_1_ATAC hg_C8_2_ATAC hg_C8_3_ATAC hg_C8_4_ATAC
do
	python /mnt/Storage/home/zhaochengchen/bin/BwSignal.py ${sample}/${sample}.bw ${hg_promoter} ${sample}.PromoterSignal.tmp
	cut -f 5,7 ${sample}.PromoterSignal.tmp > ${sample}.PromoterSignal.tmp2
	python /mnt/Storage/home/zhaochengchen/bin/GeneSymbolUniq.py ${sample}.PromoterSignal.tmp2 GSE101571_hg${sample}.ATAC.PromoterSignal 0
	rm ${sample}.PromoterSignal.tmp
	rm ${sample}.PromoterSignal.tmp2
done
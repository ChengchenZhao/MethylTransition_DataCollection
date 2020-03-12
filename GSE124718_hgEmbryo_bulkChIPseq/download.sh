wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543856/suppl/GSM3543856%5Fhs%5F4cell%5F2PN%5FH3K4me3%5Frep1%2EbedGraph%2Egz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543857/suppl/GSM3543857%5Fhs%5F4cell%5F2PN%5FH3K4me3%5Frep2%2EbedGraph%2Egz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543858/suppl/GSM3543858%5Fhs%5F4cell%5F3PN%5FH3K4me3%5Frep1%2EbedGraph%2Egz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543859/suppl/GSM3543859%5Fhs%5F4cell%5F3PN%5FH3K27me3%5Frep1%2EbedGraph%2Egz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543860/suppl/GSM3543860%5Fhs%5F8cell%5F2PN%5FH3K4me3%5Frep1%2EbedGraph%2Egz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543861/suppl/GSM3543861%5Fhs%5F8cell%5F2PN%5FH3K4me3%5Frep2%2EbedGraph%2Egz
wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM3543nnn/GSM3543862/suppl/GSM3543862%5Fhs%5F8cell%5F2PN%5FH3K27me3%5Frep1%2EbedGraph%2Egz

gunzip *.gz

bedGraphToBigWig GSM3543856_hs_4cell_2PN_H3K4me3_rep1.bedGraph ~/Data/hg19/hg19.len hg_4C_2PN_H3K4me3_r1.bw
bedGraphToBigWig GSM3543857_hs_4cell_2PN_H3K4me3_rep2.bedGraph ~/Data/hg19/hg19.len hg_4C_2PN_H3K4me3_r2.bw
bedGraphToBigWig GSM3543858_hs_4cell_3PN_H3K4me3_rep1.bedGraph ~/Data/hg19/hg19.len hg_4C_3PN_H3K4me3_r1.bw
bedGraphToBigWig GSM3543859_hs_4cell_3PN_H3K27me3_rep1.bedGraph ~/Data/hg19/hg19.len hg_4C_3PN_H3K27me3_r1.bw
bedGraphToBigWig GSM3543860_hs_8cell_2PN_H3K4me3_rep1.bedGraph ~/Data/hg19/hg19.len hg_8C_2PN_H3K4me3_r1.bw
bedGraphToBigWig GSM3543861_hs_8cell_2PN_H3K4me3_rep2.bedGraph ~/Data/hg19/hg19.len hg_8C_2PN_H3K4me3_r2.bw
bedGraphToBigWig GSM3543862_hs_8cell_2PN_H3K27me3_rep1.bedGraph ~/Data/hg19/hg19.len hg_8C_2PN_H3K27me3_r1.bw


# PromoterSignal Calculation
hg_promoter=/mnt/Storage/home/zhaochengchen/Data/hg19/hg19.refseq.Promoter
# for sample in hg_8C_2PN_H3K4me3_r1 hg_8C_2PN_H3K4me3_r2 hg_8C_2PN_H3K27me3_r1
for sample in hg_4C_3PN_H3K4me3_r1 hg_4C_3PN_H3K27me3_r1
do 
	python /mnt/Storage/home/zhaochengchen/bin/BwSignal.py ${sample}.bw ${hg_promoter} ${sample}.PromoterSignal.tmp
	cut -f 5,7 ${sample}.PromoterSignal.tmp > ${sample}.PromoterSignal.tmp2
	python /mnt/Storage/home/zhaochengchen/bin/GeneSymbolUniq.py ${sample}.PromoterSignal.tmp2 ${sample}.PromoterSignal 0
	rm ${sample}.PromoterSignal.tmp
	rm ${sample}.PromoterSignal.tmp2
done
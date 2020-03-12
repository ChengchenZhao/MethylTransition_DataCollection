cp /mnt/Storage/home/wangchenfei/Projects/MouseDevelopment/Data/expression/Embryo_gene_output.txt .

# https://www.ebi.ac.uk/ena/data/view/PRJNA384287

prefetch SRR5479533
prefetch SRR5479534
prefetch SRR5479535
prefetch SRR5479536
prefetch SRR5479537
prefetch SRR5479538
prefetch SRR5479539
prefetch SRR5479540

mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479533.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479534.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479535.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479536.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479537.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479538.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479539.sra .
mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR5479540.sra .

fastq-dump --split-files SRR5479533.sra
fastq-dump --split-files SRR5479534.sra
fastq-dump --split-files SRR5479535.sra
fastq-dump --split-files SRR5479536.sra
fastq-dump --split-files SRR5479537.sra
fastq-dump --split-files SRR5479538.sra
fastq-dump --split-files SRR5479539.sra
fastq-dump --split-files SRR5479540.sra
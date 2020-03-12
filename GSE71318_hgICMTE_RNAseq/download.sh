
# https://www.ebi.ac.uk/ena/data/view/PRJNA291062

# python3.6 /mnt/Storage/home/zhaochengchen/bin/FromWW/gen_download_from_ebi.py PRJNA291062.txt download_code.sh
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/000/SRR2130120/SRR2130120_1.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/000/SRR2130120/SRR2130120_2.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/001/SRR2130121/SRR2130121_1.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/001/SRR2130121/SRR2130121_2.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/002/SRR2130122/SRR2130122_1.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/002/SRR2130122/SRR2130122_2.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/003/SRR2130123/SRR2130123_1.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/003/SRR2130123/SRR2130123_2.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/004/SRR2130124/SRR2130124_1.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/004/SRR2130124/SRR2130124_2.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/005/SRR2130125/SRR2130125_1.fastq.gz .
~/.aspera/connect/bin/ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR213/005/SRR2130125/SRR2130125_2.fastq.gz .

# prefetch SRR2130120
# prefetch SRR2130121
# prefetch SRR2130122
# prefetch SRR2130123
# prefetch SRR2130124
# prefetch SRR2130125

# mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR2130120.sra .
# mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR2130121.sra .
# mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR2130122.sra .
# mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR2130123.sra .
# mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR2130124.sra .
# mv /mnt/Storage/home/zhaochengchen/ncbi/public/sra/SRR2130125.sra .

# fastq-dump --split-files SRR2130120.sra
# fastq-dump --split-files SRR2130121.sra
# fastq-dump --split-files SRR2130122.sra
# fastq-dump --split-files SRR2130123.sra
# fastq-dump --split-files SRR2130124.sra
# fastq-dump --split-files SRR2130125.sra

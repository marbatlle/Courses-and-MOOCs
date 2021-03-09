echo "*** INITIATING Pipeline ***"

echo " INITIATING Sample Files Downloads "
bash scripts/download.sh data/urls data
echo " Sample Files Downloads COMPLETED "

echo " INITIATING Contaminants File Download "
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes
echo " Contaminants File Download COMPLETED"

echo "INITIATING Contaminant File Indexing"
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx


echo "INITIATING Samples Merge"
mkdir -p out/merged
for sid in $(ls data/*.fastq.gz | cut -d"-" -f1 | sed "s:data/::" | sort | uniq) 
do
 if [ ! -f out/merged/${sid}.fastq.gz ]
 then
    bash scripts/merge_fastqs.sh data out/merged $sid
    echo "Samples Merge for $sid COMPLETED"
 else
    echo "PROCESS EXITED. Sample $sid merging OUTPUT ALREADY EXISTS"
 fi
done

echo "INITIATING Samples Trimming"
mkdir -p out/trimmed
mkdir -p log/cutadapt
for sid in $(ls out/merged/*.fastq.gz | cut -d"." -f1 | sed "s:out/merged/::")
do
 if [ ! -f ./log/cutadapt/${sid}.log ]
 then
    cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed -o out/trimmed/${sid}.trimmed.fastq.gz out/merged/${sid}.fastq.gz > log/cutadapt/${sid}.log
    echo "Samples $sid Trimming COMPLETED"
 else
    echo "PROCESS EXITED. Sample $sid trimming OUTPUT ALREADY EXISTS"
 fi
done

echo "INITIATING STAR"
mkdir -p out/star
for fname in out/trimmed/*.fastq.gz
do
sid=$(basename "$fname" .trimmed.fastq.gz)
 if [ ! -f out/star/${sid}/Log.final.out ]
 then
    mkdir -p out/star/$sid
    STAR --runThreadN 4 --genomeDir res/contaminants_idx --outReadsUnmapped Fastx --readFilesIn out/trimmed/${sid}.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/${sid}/
    echo "STAR COMPLETED"
 else
    echo "PROCESS EXITED. Sample $fname STAR OUTPUT ALREADY EXISTS"
 fi
done 

echo "INITIATING Pipeline Log"
touch log.out
for file in $(ls log/cutadapt/)
do
    sid=$(basename "$file" .log)
    echo "***  $sid ***: $(date -u)" >> log.out
    echo "*** Cutadapt Log" >> log.out
    grep "Reads with adapters:" log/cutadapt/${sid}.log >> log.out
    grep "Total basepairs processed:" log/cutadapt/${sid}.log >> log.out
    grep "Total written (filtered):" log/cutadapt/${sid}.log >> log.out
    echo "***Star Log" >> log.out
    grep "Uniquely mapped reads %" out/star/${sid}/Log.final.out >> log.out
    grep "% of reads mapped to multiple loci" out/star/${sid}/Log.final.out >> log.out
    grep "% of reads mapped to too many loci" out/star/${sid}/Log.final.out >> log.out
    echo " Pipeline Log COMPLETED for $file"
done

echo "*** Pipeline COMPLETED ***"
# The STAR command is provided for you. You should replace the parts surrounded by "<>" and uncomment it.
mkdir -p $2
if [ ! -f $2/genomeParameters.txt ]
then
   STAR --runThreadN 4 --runMode genomeGenerate --genomeDir $2 --genomeFastaFiles $1 --genomeSAindexNbases 9
   echo "Contaminant File Indexing COMPLETED"
else
   echo "PROCESS EXITED. Contaminant file Indexing OUTPUT ALREADY EXISTS"
fi
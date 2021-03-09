
# $1 = input, url or file?
# $2 = location save output
# $3 = yes or nothing unzip

sample_name=$(basename "$1")
if [[ "$1" == https* ]] 
then
    wget -P $2 $1 -nc
else 
    wget -i $1 -P $2 -nc
fi
if [ "$3" == "yes" ]
then
    yes y | gunzip -k $2/$sample_name
fi

# extract language statistics
## input $1 is the part index for multiprocessing, e.g. 01, 02, etc
## input $2 is the version of Common Crawl, e.g. CC-MAIN-2018-30
## useful output will be saved in $outputdir/1/stats/langstats.0.gz

input="/home/ubuntu/common_crawl/wet/$2/url_list_pt_$1.txt"
if [ ! -d "/home/ubuntu/common_crawl/data/$2/language_info/pt_$1" ]
then
    mkdir -p /home/ubuntu/common_crawl/data/$2/language_info/pt_$1
fi

while IFS= read -r line
do
outputdir=/home/ubuntu/common_crawl/data/$2/language_info/pt_$1/${line##*/}
outputdir=${outputdir%%.*}
if [ ! -d $outputdir ]
then
    echo $line | /home/ubuntu/extractor/build/mono --icompression gzip --ocompression none --workers 1 --output $outputdir --print_stats --curl;
    
    # remove the plain text output to save storage
    rm -f $outputdir/1/*.out;
fi
done < $input


for i in {01..32}
do filelist=$(ls -lrt /home/ubuntu/common_crawl/data/language_info/pt_$i/ | tail)
lastfile=${filelist##* }
rm -r /home/ubuntu/common_crawl/data/language_info/pt_$i/$lastfile
echo "deleted "$lastfile
done

# Select Candidate Domains Referring to Common Crawl

### Download from Common Crawl

Common Crawl releases a new version of web archive database every one or two months. Their data location can be found here: https://commoncrawl.org/the-data/get-started/. For each version, several formats of data are provided. Our project started from WET files which only include extracted plain text.
For the first step, please select a version of Common Crawl and download the WET path list file `wet.paths.gz`.

### Split the Path List
This step can be skipped if you don't plan on doing multiprocessing for extracting language statistics. We splitted the path list into 32 parts.
```bash
python3 /home/ubuntu/common_crawl/src/process_wet_path_list.py
```

### Extract Language Statistics
Our sample code below runs 32 processes at the same time. The first input "$i" is the part index for multiprocessing, e.g. 01, 02, etc. The second input is the version of Common Crawl.
``` bash
for i in {01..32}
do
/home/ubuntu/common_crawl/src/extractor_lang_index_version.sh $i "CC-MAIN-2018-30" &
done
```

### Resume Extraction
The extraction usually lasts for quite a long time, so sometimes it might get interrupted. In this case, before resuming the extraction, please delete the last created file so that it can start again from the right place.
```bash
bash /home/ubuntu/common_crawl/src/delete_last_file.sh
```

### Organize Language Statistics
This step combines language statistics from every splits together, and that includes combining information from duplicated domains. The input is the total number of splits.
```bash
python3 /home/ubuntu/common_crawl/src/organize_langstats.py 32
```

### Choose Domains
We selected top 50000 domains from all the domains in Common Crawl. We asked the domain to contain more than 20000 bytes in Japanese, and used 1.22 as the golden language ratio between Japanese and English. Of course, all the numbers mentioned above can be changed by modifying the source code.
```bash
python3 /home/ubuntu/common_crawl/src/choose_domains.py
```

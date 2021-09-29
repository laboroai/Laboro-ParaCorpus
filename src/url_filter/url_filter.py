# simple rule-based url filter

import os
import re

# read in your concatenated output from each domain
laborov4_clean = open('/home/ubuntu/data/para_corpus/Laboro_ParaCorpus_v4_clean.txt').readlines()

ja_ids = [r'[^.]jp', r'[^.]ja', 'japanese', '/j/', '=j']
en_ids = ['en', 'english', r'[^.]uk', r'[^.]us', '/e/', '=e']

# output the corpus cleaned by the rule-based url filter
with open('/home/ubuntu/data/para_corpus/Laboro_ParaCorpus_v4_rulebased_url_clean.txt','w') as output:
    for line in laborov4_clean:
        en_url, ja_url, _, _, _, _ = line.strip().split('\t')

        found_ja_id = False
        found_en_id = False

        for en_id in en_ids:
            if re.search(en_id, en_url):
                found_en_id = True
                break

        for ja_id in ja_ids:
            if re.search(ja_id, ja_url):
                found_ja_id = True
                break

        if not (found_en_id or found_ja_id):
            continue

        en_nums = re.findall(r'[0-9]+', en_url)
        ja_nums = re.findall(r'[0-9]+', ja_url)
        if en_nums!=ja_nums:
            continue
            
        output.write(line)


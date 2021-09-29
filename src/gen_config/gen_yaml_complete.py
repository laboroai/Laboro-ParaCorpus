import os
import json

def gen_post_yaml(index,domain):
    folder_name = f'cc_1830_{index}'
    
    post_conf = f'''
bitextor: /home/ubuntu/bitextor

lang1: en
lang2: ja

dic: /home/ubuntu/Laboro-ParaCorpus/data/dic/en-ja.dic

permanentDir: /home/ubuntu/data/results/{folder_name}/permanent/bitextor-output
dataDir: /home/ubuntu/data/results/{folder_name}/permanent/data
transientDir: /home/ubuntu/data/results/{folder_name}/transient

wordTokenizers: {{
'ja': '/usr/bin/mecab -d /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd -O wakati',
'default': '/home/ubuntu/bitextor/preprocess/moses/tokenizer/tokenizer.perl -q -b -a -l en'
}}

sentenceSplitters: {{
'ja': '/home/ubuntu/Laboro-ParaCorpus/src/bitextor/split-sentences-ja.perl -b -k -p /home/ubuntu/Laboro-ParaCorpus/src/bitextor/ -l ja',
'default': '/home/ubuntu/bitextor/preprocess/moses/ems/support/split-sentences.perl -q -b -k -l en'
}}


hosts: ["{domain}"]
crawler: creepy
crawlTimeLimit: 0s
crawlSizeLimit: 1G
crawlTld: false
crawlerNumThreads: 1
crawlerConnectionTimeout: 10
onlyConcat: false

boilerpipeCleaning: true
parser: "extractcontent"

onlyPreprocessing: false

langId: cld2
ftfy: false
cleanHTML: false

bicleaner: /home/ubuntu/Laboro-ParaCorpus/data/bicleaner_model/bicleaner_model_1/en-ja.yaml
bicleanerThreshold: 0.5
'''
    
    return post_conf

if __name__=='__main__':
    index_domain = json.load(open('/home/ubuntu/Laboro-ParaCorpus/data/domain_list/domain_list.json'))
    
    if not os.path.exists(f'/home/ubuntu/data/post_conf/'):
        os.makedirs(f'/home/ubuntu/data/post_conf/')
    for index,domain in index_domain.items():
        open(f'/home/ubuntu/data/post_conf/cc_1830_{index}.yaml','w').write(gen_post_yaml(index,domain))

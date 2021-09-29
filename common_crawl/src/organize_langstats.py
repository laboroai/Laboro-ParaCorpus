import gzip
import os
import argparse
import json
from tqdm import tqdm


def add_info(domain,info,web_dict):
    if domain not in web_dict:
        web_dict[domain] = {'en':int(info['en']),'ja':int(info['ja'])}
    else:
        web_dict[domain]['en'] += int(info['en'])
        web_dict[domain]['ja'] += int(info['ja'])


if __name__=='__main__':
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('totalpt', type=int, help='total number of splits')
    args = parser.parse_args()

    totalpt = args.totalpt
    langstats_dir = '/home/ubuntu/common_crawl/data/CC-MAIN-2018-30/langstats/'

    # within one split, put language stat from every CC WET file together
    for pt in range(totalpt):
        domain_bytes_dic = {}
        cc_dir = f'/home/ubuntu/common_crawl/data/CC-MAIN-2018-30/language_info/pt_{str(pt).zfill(2)}'
        for cc in tqdm(os.listdir(cc_dir)):
            langstats_path = os.path.join(cc_dir,cc,'1','stats','langstats.0.gz')
            langstats = gzip.open(langstats_path).readlines()
            for line in langstats:
                if len(line.strip().split())!=3:
                    continue

                domain,lang,byte = line.strip().split()
                domain = domain.decode("utf-8")
                lang = lang.decode("utf-8")
                byte = byte.decode("utf-8")

                if lang not in ['en','ja']:
                    continue

                byte = int(byte)
                if domain in domain_bytes_dic:
                    domain_bytes_dic[domain][lang] += byte
                else:
                    domain_bytes_dic[domain] = {}
                    domain_bytes_dic[domain]['ja'] = 0
                    domain_bytes_dic[domain]['en'] = 0
                    domain_bytes_dic[domain][lang] += byte

        output_path = os.path.join(langstats_dir, f'pt_{str(pt).zfill(2)}.json')
        if not os.path.exists(os.path.dirname(output_path)):
            os.makedirs(os.path.dirname(output_path))
        json.dump(domain_bytes_dic,open(output_path,'w'))

    # put language stat from every split together, categorized by initials
    websites_digits = {}
    websites_a_g = {}
    websites_h_n = {}
    websites_o_t = {}
    websites_u_z = {}
    websites_others = {}

    for n in tqdm(range(1,33)):
        stat_name = os.path.join(langstats_dir, f'pt_{str(n).zfill(2)}.json')
        stat = json.load(open(stat_name))
        
        for domain in stat:
            info = stat[domain]
            if domain[0] in '0123456789':
                add_info(domain,info,websites_digits)
            elif domain[0] in 'abcdefg':
                add_info(domain,info,websites_a_g)
            elif domain[0] in 'hijklmn':
                add_info(domain,info,websites_h_n)
            if domain[0] in 'opqrst':
                add_info(domain,info,websites_o_t)
            if domain[0] in 'uvwxyz':
                add_info(domain,info,websites_u_z)
            else:
                add_info(domain,info,websites_others)

    for domain_list in tqdm((websites_digits, websites_a_g, websites_h_n, websites_o_t, websites_u_z, websites_others)):
        for domain in domain_list.keys():
            if domain_list[domain]['ja']==0 or domain_list[domain]['en']==0:
                domain_list.pop(domain)

    json.dump(websites_digits,open(os.path.join(langstats_dir, 'websites_digits.json'),'w'),indent=4)
    json.dump(websites_a_g,open(os.path.join(langstats_dir, 'websites_a_g.json'),'w'),indent=4)
    json.dump(websites_h_n,open(os.path.join(langstats_dir, 'websites_h_n.json'),'w'),indent=4)
    json.dump(websites_o_t,open(os.path.join(langstats_dir, 'websites_o_t.json'),'w'),indent=4)
    json.dump(websites_u_z,open(os.path.join(langstats_dir, 'websites_u_z.json'),'w'),indent=4)
    json.dump(websites_others,open(os.path.join(langstats_dir, 'websites_others.json'),'w'),indent=4)

    # put everything altogether
    all_domain_bytes_dic = {}

    for stat_name in tqdm(os.listdir(langstats_dir)):
        if not stat_name[:len('websites')]=='websites':
            continue
        stat = json.load(open(os.path.join(langstats_dir,stat_name)))
        for domain in stat:
            all_domain_bytes_dic[domain] = stat[domain]

    print(len(all_domain_bytes_dic))
    json.dump(all_domain_bytes_dic,open(os.path.join(langstats_dir,'all_domains_2018-30.json'),'w'))

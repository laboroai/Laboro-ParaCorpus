import json
from tqdm import tqdm

class CandidateRanker:
    def __init__(self, dic):
        self._data = dic
 
    def __call__(self, exp_ratio, min_lang1, lang1="ja", lang2="en"):
        return self._calc_ratio(
            exp_ratio, min_lang1, self._data, lang1, lang2)
    
    def _calc_ratio(self,exp_ratio,min_lang1,data,lang1,lang2):
        ranked = {}
        for domain,values in data.items():
            if values[lang1]<min_lang1:
                continue
            lang_ratio = float(values[lang1])/float(values[lang2])
            ratio_diff = abs(lang_ratio - exp_ratio)
            ranked[domain] = (lang_ratio,ratio_diff)

        return sorted(ranked.items(), key=lambda x:x[1][1], reverse=False)


if __name__=='__main__':
    CC_2018_30_stats = json.load(open('/home/ubuntu/common_crawl/data/CC-MAIN-2018-30/langstats/all_domains_2018-30.json'))

    ranked_info = CandidateRanker(CC_2018_30_stats)(1.22,20000)
    
    top_domain = {}
    index = 1
    for domain,_ in tqdm(ranked_info[:50000]):
        top_domain[str(index).zfill(5)] = domain
        index += 1
    json.dump(top_domain, open('/home/ubuntu/Laboro-ParaCorpus/data/domain_list/domain_list.json','w'))
        


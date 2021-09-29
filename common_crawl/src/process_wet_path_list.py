import os

cc_version = 'CC-MAIN-2018-30'
input_list = open(f'/home/ubuntu/common_crawl/wet/{cc_version}/wet.paths').readlines()
with open(f'/home/ubuntu/common_crawl/wet/{cc_version}/url_list.txt','w') as output:
    for line in input_list:
        output.write('https://commoncrawl.s3.amazonaws.com/'+line)

# adjust the pt_num to the wanted number of splits
pt_num = 32

input_list = open(f'/home/ubuntu/common_crawl/wet/{cc_version}/url_list.txt').readlines()
per_len = int(len(input_list)/pt_num)
last_len_plus = int(len(input_list)%pt_num)
#print(per_len,last_len_plus)
assert pt_num*per_len+last_len_plus==len(input_list)
for n in range(pt_num):
    with open(f'/home/ubuntu/common_crawl/wet/{cc_version}/url_list_pt_{str(n+1).zfill(2)}.txt','w') as output:
        start_idx = n*per_len
        end_idx = (n+1)*per_len
        if n<pt_num-last_len_plus:
            for line in input_list[start_idx:end_idx]:
                output.write(line)
        else:
            for line in input_list[start_idx:end_idx]:
                output.write(line)
            output.write(input_list[len(input_list)-(pt_num-n)])

        
        
        
# need big memory instance

mkdir -p /home/ubuntu/Laboro-ParaCorpus/nmt/expe1/tokenizer/spm/

spm_train --input=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/corpus/Laboro-ParaCorpus/Laboro-ParaCorpus.en --model_prefix=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/tokenizer/spm/spm.en --vocab_size=32000 --model_type=unigram --character_coverage=1.0 --num_threads=64;
spm_train --input=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/corpus/Laboro-ParaCorpus/Laboro-ParaCorpus.ja --model_prefix=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/tokenizer/spm/spm.ja --vocab_size=32000 --model_type=unigram --character_coverage=1.0 --num_threads=64;
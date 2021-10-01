# need big memory instance

spm_train --input=/home/ubuntu/Laboro-ParaCorpus/nmt/expe14/corpus/laboro_v4_rb/Laboro_ParaCorpus_v4.en --model_prefix=/home/ubuntu/Laboro-ParaCorpus/nmt/expe14/tokenizer/laboro_v4_rb_spm/spm.en --vocab_size=32000 --model_type=unigram --character_coverage=1.0 --num_threads=64;

spm_train --input=/home/ubuntu/Laboro-ParaCorpus/nmt/expe14/corpus/laboro_v4_rb/Laboro_ParaCorpus_v4.ja --model_prefix=/home/ubuntu/Laboro-ParaCorpus/nmt/expe14/tokenizer/laboro_v4_rb_spm/spm.ja --vocab_size=32000 --model_type=unigram --character_coverage=1.0 --num_threads=64;
cp /home/ubuntu/Laboro-ParaCorpus/src/bitextor/judge_language_jp.py /home/ubuntu/bitextor/
cp /home/ubuntu/Laboro-ParaCorpus/src/bitextor/extractcontent.py /home/ubuntu/bitextor/
cp /home/ubuntu/Laboro-ParaCorpus/src/bitextor/Snakefile /home/ubuntu/bitextor/snakemake/

mv /home/ubuntu/bitextor/bitextor.sh /home/ubuntu/bitextor/bitextor_ori.sh
chmod +x /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-no-lock.sh
ln -s /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-no-lock.sh /home/ubuntu/bitextor/bitextor.sh

mv /home/ubuntu/bitextor/bitextor-cleantextalign.py /home/ubuntu/bitextor/bitextor-cleantextalign_ori.py
chmod +x /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-cleantextalign_minlen_langfil.py
ln -s /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-cleantextalign_minlen_langfil.py /home/ubuntu/bitextor/bitextor-cleantextalign.py

mv /home/ubuntu/bitextor/bitextor-warc2preprocess.py /home/ubuntu/bitextor/bitextor-warc2preprocess_ori.py
chmod +x /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-warc2preprocess_extractcontent_keextr_outputtext.py
ln -s /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-warc2preprocess_extractcontent_keextr_outputtext.py /home/ubuntu/bitextor/bitextor-warc2preprocess.py

mv /home/ubuntu/bitextor/bitextor-creepy.py /home/ubuntu/bitextor/bitextor-creepy_ori.py
chmod +x /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-creepy_m.py
ln -s /home/ubuntu/Laboro-ParaCorpus/src/bitextor/bitextor-creepy_m.py /home/ubuntu/bitextor/bitextor-creepy.py

mv /home/ubuntu/bitextor/preprocess/moses/ems/support/split-sentences.perl /home/ubuntu/bitextor/preprocess/moses/ems/support/split-sentences_ori.perl
chmod +x /home/ubuntu/Laboro-ParaCorpus/src/bitextor/split-sentences-semicolon.perl
cp /home/ubuntu/Laboro-ParaCorpus/src/bitextor/split-sentences-semicolon.perl /home/ubuntu/bitextor/preprocess/moses/ems/support/split-sentences.perl


#!/bin/sh

for dataset in aspec bsd duo iwslt jesc kftt ttb; do

    SPM_MODELDIR=/home/ubuntu/nmt/expe1/tokenizer/spm
    ORIG_CORPUSDIR=/home/ubuntu/nmt/expe1/corpus/${dataset}
    SPM_CORPUSDIR=/home/ubuntu/nmt/expe1/corpus/${dataset}_test_spm

    mkdir -p $SPM_CORPUSDIR
    for L in en ja; do
      for F in $ORIG_CORPUSDIR/test.$L; do
        B=`basename $F`
        echo "tokenizing file $F........"
        spm_encode --model=$SPM_MODELDIR/spm.$L.model --output_format=piece < $F > $SPM_CORPUSDIR/$B
        echo "finished tokenizing file $F........"
      done
    done

    echo "filtering out sentences longer than 250........"
    python3 /home/ubuntu/nmt/expe1/src/preprocess/len_filter.py $SPM_CORPUSDIR test
    echo "finished filtering........"
done
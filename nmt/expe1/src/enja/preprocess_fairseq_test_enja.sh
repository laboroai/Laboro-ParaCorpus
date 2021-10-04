SRC=en
TRG=ja

for dataset in aspec bsd duo iwslt jesc kftt ttb; do
    EXP_NAME=laboro_fairseq_${dataset}_${SRC}${TRG}

    TEST_SPM_CORPUSDIR=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/corpus/${dataset}_test_spm
    TEST_SPM_SRC=$TEST_SPM_CORPUSDIR/test_len_filtered.${SRC}
    TEST_SPM_TRG=$TEST_SPM_CORPUSDIR/test_len_filtered.${TRG}

    CORPUS_DIR=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/corpus
    mkdir -p $CORPUS_DIR/$EXP_NAME
    DATA_DIR=$CORPUS_DIR/$EXP_NAME

    DICT_DIR=/home/ubuntu/Laboro-ParaCorpus/nmt/expe1/corpus/laboro_fairseq_novalid_${SRC}${TRG}
    cp $DICT_DIR/dict.* $DATA_DIR/
    SRC_VOCAB=$DATA_DIR/dict.${SRC}.txt
    TRG_VOCAB=$DATA_DIR/dict.${TRG}.txt

    TEST_PREFIX=$CORPUS_DIR/$EXP_NAME/test
    ln -s $TEST_SPM_SRC $TEST_PREFIX.$SRC  # train.ja or train.en
    ln -s $TEST_SPM_TRG $TEST_PREFIX.$TRG  # train.en or train.ja

    fairseq-preprocess \
        --source-lang $SRC \
        --target-lang $TRG \
        --testpref $TEST_PREFIX \
        --srcdict $SRC_VOCAB \
        --tgtdict $TRG_VOCAB \
        --destdir $DATA_DIR \
        --workers `nproc`
done

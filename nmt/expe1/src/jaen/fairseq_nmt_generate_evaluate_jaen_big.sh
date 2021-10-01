SRC=ja  # or "en"
TRG=en  # or "ja"

for dataset in aspec bsd duo iwslt jesc kftt ttb; do
    TEST_SPMDIR=/home/ubuntu/nmt/expe14/corpus/${dataset}_test_spm
    TEST_SRC=$TEST_SPMDIR/test.${SRC}

    SPM_MODELDIR=/home/ubuntu/nmt/expe14/tokenizer/laboro_v4_rb_spm

    CORPUS_DIR=/home/ubuntu/nmt/expe14/corpus
    EXP_NAME=laboro_v4_fairseq_${dataset}_${SRC}${TRG}
    DATA_DIR=$CORPUS_DIR/$EXP_NAME

    B=`basename $TEST_SRC`
    SPM_MODEL=$SPM_MODELDIR/spm.$TRG.model

    MODEL_DIR=/home/ubuntu/nmt/expe14/model/laboro_v4_big_${SRC}${TRG}
    RESULT_DIR=/home/ubuntu/nmt/expe14/results/${SRC}${TRG}/test_${dataset}_big
    mkdir -p $RESULT_DIR

    fairseq-generate $DATA_DIR \
        --gen-subset test \
        --path $MODEL_DIR/average/average.pt \
        --max-tokens 1000 \
        --beam 6 \
        --lenpen 1.0 \
        --log-format simple \
        --remove-bpe \
        | tee $RESULT_DIR/$B.hyp

    grep "^H" $RESULT_DIR/$B.hyp | sed 's/^H-//g' | sort -n | cut -f3 > $RESULT_DIR/$B.true
    cat $RESULT_DIR/$B.true | spm_decode --model=$SPM_MODEL --input_format=piece > $RESULT_DIR/$B.true.detok

    TEST_TXTDIR=/home/ubuntu/nmt/expe14/corpus/${dataset}
    TEST_TRG_RAW=$TEST_TXTDIR/test.${TRG}

    mecab -O wakati < $TEST_TRG_RAW > $RESULT_DIR/$B.mecab.ref
    mecab -O wakati < $RESULT_DIR/$B.true.detok > $RESULT_DIR/$B.mecab.hyp
    cat $RESULT_DIR/$B.mecab.hyp | sacrebleu --tokenize=intl $RESULT_DIR/$B.mecab.ref | tee -a $RESULT_DIR/test.log
done
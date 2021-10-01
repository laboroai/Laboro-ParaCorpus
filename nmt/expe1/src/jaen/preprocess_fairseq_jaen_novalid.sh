#!/bin/sh

SRC=ja  # or "en"
TRG=en  # or "ja"
EXP_NAME=laboro_v4_fairseq_novalid_${SRC}${TRG}

CORPUS_DIR=/home/ubuntu/nmt/expe14/corpus

TRAIN_SPM_CORPUSDIR=$CORPUS_DIR/laboro_v4_rb_spm
TRAIN_SPM_SRC=$TRAIN_SPM_CORPUSDIR/laboro_v4_rb_len_filtered.${SRC}
TRAIN_SPM_TRG=$TRAIN_SPM_CORPUSDIR/laboro_v4_rb_len_filtered.${TRG}

VALID_SPM_CORPUSDIR=$CORPUS_DIR/dummy
VALID_SPM_SRC=$VALID_SPM_CORPUSDIR/dummy.${SRC}
VALID_SPM_TRG=$VALID_SPM_CORPUSDIR/dummy.${TRG}

mkdir -p $CORPUS_DIR/$EXP_NAME
DATA_DIR=$CORPUS_DIR/$EXP_NAME
TRAIN_PREFIX=$CORPUS_DIR/$EXP_NAME/train
ln -s $TRAIN_SPM_SRC $TRAIN_PREFIX.$SRC  # train.ja or train.en
ln -s $TRAIN_SPM_TRG $TRAIN_PREFIX.$TRG  # train.en or train.ja
VALID_PREFIX=$CORPUS_DIR/$EXP_NAME/valid
ln -s $VALID_SPM_SRC $VALID_PREFIX.$SRC
ln -s $VALID_SPM_TRG $VALID_PREFIX.$TRG

fairseq-preprocess \
    --source-lang $SRC \
    --target-lang $TRG \
    --trainpref $TRAIN_PREFIX \
    --validpref $VALID_PREFIX \
    --destdir $DATA_DIR \
    --tokenizer space \
    --workers `nproc`

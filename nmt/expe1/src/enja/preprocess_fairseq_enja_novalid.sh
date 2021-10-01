#!/bin/sh

SRC=en
TRG=ja
EXP_NAME=laboro_fairseq_novalid_${SRC}${TRG}

CORPUS_DIR=/home/ubuntu/nmt/expe1/corpus

TRAIN_SPM_CORPUSDIR=$CORPUS_DIR/Laboro-ParaCorpus_spm
TRAIN_SPM_SRC=$TRAIN_SPM_CORPUSDIR/Laboro-ParaCorpus_len_filtered.${SRC}
TRAIN_SPM_TRG=$TRAIN_SPM_CORPUSDIR/Laboro-ParaCorpus_len_filtered.${TRG}

VALID_SPM_CORPUSDIR=$CORPUS_DIR/dummy
VALID_SPM_SRC=$VALID_SPM_CORPUSDIR/dummy.${SRC}
VALID_SPM_TRG=$VALID_SPM_CORPUSDIR/dummy.${TRG}

mkdir -p $CORPUS_DIR/$EXP_NAME
DATA_DIR=$CORPUS_DIR/$EXP_NAME
TRAIN_PREFIX=$CORPUS_DIR/$EXP_NAME/train
ln -s $TRAIN_SPM_SRC $TRAIN_PREFIX.$SRC
ln -s $TRAIN_SPM_TRG $TRAIN_PREFIX.$TRG
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

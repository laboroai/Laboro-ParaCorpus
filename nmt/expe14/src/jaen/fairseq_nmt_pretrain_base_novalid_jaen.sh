# base model

CORPUS_DIR=/home/ubuntu/nmt/expe14/corpus
SRC=ja  # or "en"
TRG=en  # or "ja"
EXP_NAME=laboro_v4_fairseq_novalid_${SRC}${TRG}
DATA_DIR=$CORPUS_DIR/$EXP_NAME

MODEL_DIR=/home/ubuntu/nmt/expe14/model/laboro_v4_base_novalid_${SRC}${TRG}
mkdir -p $MODEL_DIR

CUDA_VISIBLE_DEVICES=0,1,2,3 fairseq-train $DATA_DIR \
    --disable-validation \
    --arch transformer \
    --optimizer adam \
    --adam-betas '(0.9, 0.98)' \
    --clip-norm 1.0 \
    --lr-scheduler inverse_sqrt \
    --warmup-init-lr 1e-07 \
    --warmup-updates 4000 \
    --lr 0.001 \
    --min-lr 1e-09 \
    --dropout 0.3 \
    --weight-decay 0.0 \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --max-tokens 5000 \
    --max-update 24000 \
    --save-dir $MODEL_DIR \
    --no-epoch-checkpoints \
    --save-interval 10000000000 \
    --save-interval-updates 200 \
    --keep-interval-updates 8 \
    --log-format simple \
    --log-interval 10 \
    --ddp-backend no_c10d \
    --update-freq 16 \
    --fp16 \
    --seed 1 \
    --num-workers 1

rm -rf $MODEL_DIR/average
mkdir -p $MODEL_DIR/average
FAIRSEQ=/home/ubuntu/fairseq/
python3 $FAIRSEQ/scripts/average_checkpoints.py --inputs $MODEL_DIR --output $MODEL_DIR/average/average.pt --num-update-checkpoints 8

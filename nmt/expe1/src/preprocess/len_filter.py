import sys
import argparse
from tqdm import tqdm

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('srcdir')
    parser.add_argument('corpus_name')
    parser.add_argument('--thres', type=int, default=250)
    args = parser.parse_args()

    thres = args.thres
    corpus_name = args.corpus_name

    input_ja = args.srcdir + '/{}.ja'.format(corpus_name)
    input_en = args.srcdir + '/{}.en'.format(corpus_name)

    output_ja = args.srcdir + '/{}_len_filtered.ja'.format(corpus_name)
    output_en = args.srcdir + '/{}_len_filtered.en'.format(corpus_name)

    with open(input_ja) as ja_if, open(input_en) as en_if, open(output_ja, "w") as ja_of, open(output_en, "w") as en_of:

        ja_lines = ja_if.readlines()
        en_lines = en_if.readlines()
        assert len(ja_lines) == len(en_lines), 'input length mismatch'

        for i in tqdm(range(len(ja_lines))):
            ja_line = ja_lines[i].rstrip()
            en_line = en_lines[i].rstrip()
            ja_line_swnum = len(ja_line.split(' '))
            en_line_swnum = len(en_line.split(' '))
            if ja_line_swnum <= thres and en_line_swnum <= thres:
                print(ja_line, file=ja_of)
                print(en_line, file=en_of)
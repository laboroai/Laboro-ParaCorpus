# Laboro ParaCorpus

<!-- TOC -->

-   [Introduction](#introduction)
    -   [Download](#download)
    -   [To cite this work](#to-cite-this-work)
    -   [License](#license)
-   [Step 1. Select Candidate Domains](#step-1-select-candidate-domains)
-   [Step 2. Crawling and Alignment](#step-2-crawling-and-alignment)
    -   [Requirements](#requirements)
    -   [Necessary Resources](#necessary-resources)
    -   [Configuration](#configuration)
    -   [Start Bitextor Pipeline](#start-bitextor-pipeline)
    -   [The Appending Filter](#the-appending-filter)
-   [Step 3. Training and Evaluating NMT Models](#step-3-training-and-evaluating-nmt-models)
    -   [Setup & Preparation](#setup--preparation)
    -   [Preprocessing](#preprocessing)
    -   [Training NMT](#training-nmt)
    -   [Evaluating NMT models](#evaluating-nmt-models)
-   [NMT Models Comparison](#nmt-models-comparison)

<!-- /TOC -->

## Introduction

We are happy to announce that we've made public our web-based English-Japanese parallel corpus. More information on how we created the corpus can be found in [this article](∆). The document here mainly focuses on the implementation.

To reproduce our experiments, please follow three steps,
1.  [select candidate domains](#select-candidate-domains) for crawling the web
2.  [crawling and alignment](#crawling-&-alignment) for generating the parallel corpus
3.  [training and evaluating NMT models](#NMT-models) for evaluating the quatlity of the parallel corpus

In addition, in the last part of this document, we present the complete [BLEU scores comparison](#NMT-models-comparison) between several NMT models on 7 evaluation datasets. Take a look if you are interested!

### Download

**Laboro-ParaCorpus**

[Laboro-ParaCorpus](∆)  
[Base EN-JA](∆)  
[Base JA-EN](∆)  
[Big EN-JA](∆)   
[Big JA-EN](∆)

**Laboro-ParaCorpus+**

[Laboro-ParaCorpus+](∆)  
[Base EN-JA](∆)  
[Base JA-EN](∆)  
[Big EN-JA](∆)   
[Big JA-EN](∆)

### To Cite This Work

We haven't published any paper on this work. Please cite this repository:

```
@article{Laboro-ParaCorpus,
  title = {Laboro-ParaCorpus: A Web-Based Japanese-English Parallel Corpus},
  author = {"Zhao, Xinyi and Hamamoto, Masafumi and Fujihara, Hiromasa"},
  year = {2021},
  howpublished = {\url{https://github.com/laboroai/Laboro-ParaCorpus}}
}
```

### License
<a rel="license" href="http://creativecommons.org/publicdomain/zero/1.0/"><img alt="CC0" style="border-width:0" src="http://i.creativecommons.org/p/zero/1.0/88x31.png"/></a>

The parallel corpus itself is licensed under a <a rel="license" href="http://creativecommons.org/publicdomain/zero/1.0/">Public Domain CC0 License</a>. You may use the corpus without restriction under copyright or database law, even for commercial use!

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a></br>

The NMT models are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.  
For commercial use, please [contact Laboro.AI Inc.](https://laboro.ai/contact/other/)

## Step 1. Select Candidate Domains
Please refer to the document [here](common_crawl/src).

## Step 2. Crawling and Alignment

### Requirements

   Ubuntu 18.04  
   Python 3.6.9  
   Bitextor v7.3.2  
   Bicleaner v0.14  
   MeCab 0.996  
   mecab-ipadic-NEologd  

To make Bitextor suit Japanese characters and punctuations better, we made some modifications to the source code. To use the modified code, please run srcipt `./src/bitextor/set-up-bitextor.sh` to replace the original source code in Bitextor.

### Necessary Resources

1. enough storage for crawling and post-processing

How much storage space would be enough depends on how many domains you plan to crawl and how much contents each domain contains. For reference, we used a bit less than 2TB storage for 50,000 domains.

2. an English-Japanese vocabulary dictionary

We crawled an English-Japanese vacabulary dictionary from several dictionary websites, and ended up collecting 82,711 entries. It is important to select multiple sources to crawl the dictionary in order to balance the language style, because we want our final corpus to contain a little bit of everything, both academic and casual text.

3. a trained Biclaner

The very detailed explanation for training a Bicleaner can be found [here](https://github.com/bitextor/bicleaner/wiki/How-to-train-your-Bicleaner), according to which, two extra parallel corpora are needed. This includes a big corpus to extract probabilistic dictionary and word frequency information, and a small but high-quality corpus as the training corpus. Note that the dictionary used in the previous alignment step cannot be used here, because it doesn't contain the probability and word frequency information required in the training process.

Similarly, we crawled the big corpus from a bunch of dictionary websites with bilingual example sentences. As for the small but clean training corpus, we used about 600K sentence pairs from Reijiro corpus.

### Configuration

Bitextor uses YAML format for the configuration files. By modifying the configuration files, we are able to control the pipeline and select the tools. Detailed instruction can be found on [the GitHub homepage of Bitextor](https://github.com/bitextor/bitextor/tree/v7.3.2). 

We provide some examples for generating configuration files in `src/gen_config/`. To use your dictionary and Bicleaner model, and to place your output in the proper location, please change the paths in the sample code. 

```bash
# to generate configuration files that stop the pipeline after crawling
python3 src/gen_config/gen_yaml_only_crawl.py
# to generate configuration files that finish the complete pipeline
python3 src/gen_config/gen_yaml_complete.py
```

### Start Bitextor Pipeline

To run a single process, 
```bash
conf_dir='/home/ubuntu/data/post_conf/'
index=00001
/home/ubuntu/bitextor/bitextor.sh -j 1 -s $conf_dir'cc_1830_'$i'.yaml'
```

We also provide an example of running 330 processes at the same time. Each of the processes has 151 or 152 domains in queue.
```
bash src/run_bitextor/multiprocess_run.sh
```

The output from each domain will be saved as file `en-ja.sent.xz` in `permanentDir` that was set in the configuration file. To concatenate them into the final output, please run the following commands.

```bash
permanentDir=...
OUTPUT_PATH=...
rm $OUTPUT_PATH
for FILE in ${permanentDir}/en-ja.sent.xz; do
cat $FILE >> $OUTPUT_PATH
done
```

### The Appending Filter

To further clean the corpus, we appended a strict rule-based filter at the end of the Bitextor pipeline. The filter removes those sentences pairs whose URL pairs doesn't follow the rules. The rules include

1. the URL pairs must contain at least one language identifier including "ja", "en", "=j", etc;
2. the numbers in the URLs, if exist, are usually the date or post ID, and are asked to be identical in a URL pair.

To use the filter, please run
```bash
python3 src/url_filter/url_filter.py
```

## Step 3. Training and Evaluating NMT Models

To evaluate and compare the quality of the parallel corpora, we trained several sets of NMT models. The first set of models is trained with our final corpus. To explore how much the performance is influenced by the additional corpus, especially when it's a small corpus, the second set is trained with the combination of our corpus and an HNK daily conversation corpus. The NHK corpus is also crawled from online resources and contains only around 60K sentence pairs. In addition to that, the third set is trained with the combination of our corpus and NTT's JParaCrawl corpus. Each set of NMT models includes 4 models,
   1. base model, from English to Japanese
   2. base model, from Japanese to English
   3. big model, from English to Japanese
   4. big model, from Japanese to English 

### Setup & Preparation

We used [sentencepiece](https://github.com/google/sentencepiece) to train the tokenizers, and then used [Fairseq](https://github.com/pytorch/fairseq) as the tool to train and evaluate NMT models based on the parallel corpus we created.

All scripts related to training and evaluating NMT models are placed in `./nmt/expe1` folder. We recommend to create a new experiment folder every time a NMT model is trained on a new corpus. Please place the original corpus into `./nmt/expe1/corpus/[name_of_the_corpus]/`, and then use the following scripts to split it into English and Japanese corpora and train tokenizers.

```bash
# split the corpus into English and Japanese plain text
bash nmt/expe1/src/preprocess/split_text.sh

# train tokenizers
bash nmt/expe1/src/preprocess/train_tokenizer.sh
```

After the steps above, the experiment folder will be ready for training NMT models, and it should contain files as shown below. The original corpus won't be used again for NMT training and evaluation, so it's OK to delete the file to save some storage space.

```txt
├── corpus
│   └── Laboro-ParaCorpus
│       ├── Laboro-ParaCorpus.en
│       ├── Laboro-ParaCorpus.ja
│       └── Laboro-ParaCorpus.txt
├── tokenizer
│   └── spm
│       ├── spm.en.model
│       ├── spm.en.vocab
│       ├── spm.ja.model
│       └── spm.ja.vocab
└── src
    ├── enja
    │   └── ...
    ├── jaen
    │   └── ...
    └── preprocess
        └── ...
```

### Preprocessing

```bash
# tokenize and length filter training dataset
bash nmt/expe1/src/preprocess/preprocess_train_dataset.sh

# generate dummy validation corpus
echo en > nmt/expe1/corpus/dummy/dummy.en
echo ja > nmt/expe1/corpus/dummy/dummy.ja
```

### Training NMT

```bash
# JA-EN fairseq preprocess train and dummy valid datasets
bash nmt/expe1/src/jaen/preprocess_fairseq_jaen_novalid.sh

# EN-JA fairseq preprocess train and dummy valid datasets
bash nmt/expe1/src/jaen/preprocess_fairseq_jaen_novalid.sh

# JA-EN base model training
bash nmt/expe1/src/jaen/fairseq_nmt_pretrain_base_novalid_jaen.sh

# JA-EN big model training
bash nmt/expe1/src/jaen/fairseq_nmt_pretrain_big_novalid_jaen.sh

# EN-JA base model training
bash nmt/expe1/src/enja/fairseq_nmt_pretrain_base_novalid_enja.sh

# EN-JA big model training
bash nmt/expe1/src/enja/fairseq_nmt_pretrain_big_novalid_enja.sh
```

### Evaluating NMT Models

The datasets used for evaluation in our experiments are listed below.
* [ASPEC](https://jipsti.jst.go.jp/aspec/), Asian Scientific Paper Excerpt Corpus
* [JESC](https://nlp.stanford.edu/projects/jesc/), Japanese-English Subtitle Corpus containing casual language, colloquialisms, expository writing, and narrative discourse
* [KFTT](http://www.phontron.com/kftt/), Kyoto Free Translation Task that focuses on Wikipedia articles related to Kyoto 
* [IWSLT 2017 TED.tst2015](https://wit3.fbk.eu/2017-01-c) used in IWSLT 2017 Evaluation Campaign, including TED talks scripts in both languages
* [Duolinguo STAPLE](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/38OJR6) for the 2020 Duolingo Shared Task on Simultaneous Translation And Paraphrase for Language Education
* [Tatoeba](https://tatoeba.org/) corpus, a large collection of multilingual sentences and translations that keeps being updated by voluntary contributors; [release v20190709](https://opus.nlpl.eu/Tatoeba-v20190709.php) is used in our experiment
* [BSD](https://github.com/tsuruoka-lab/BSD), Business Scene Dialogue corpus containing Japanese-English business conversations

To create the test split for each dataset, please take a look at [this jupyter notebook](nmt/src/preprocess/create_splits_for_test_datasets.ipynb). And then preprocess the datasets in a similar way as training dataset.

```bash
# tokenize and length filter testing datasets
bash nmt/expe1/src/preprocess/preprocess_test_dataset.sh

# JA-EN fairseq preprocess test datasets
bash nmt/expe1/src/jaen/preprocess_fairseq_test_jaen.sh

# EN-JA fairseq preprocess test datasets
bash nmt/expe1/src/enja/preprocess_fairseq_test_enja.sh
```

Run the following scripts to evaluate corresponding model on all 7 datasets. The results will be placed in `./nmt/results/` folder.
```bash
# JA-EN base model evaluation
bash nmt/expe1/src/jaen/fairseq_nmt_generate_evaluate_jaen.sh

# JA-EN big model evaluation
bash nmt/expe1/src/jaen/fairseq_nmt_generate_evaluate_jaen_big.sh

# EN-JA base model evaluation
bash nmt/expe1/src/enja/fairseq_nmt_generate_evaluate_enja.sh

# EN-JA big model evaluation
bash nmt/expe1/src/enja/fairseq_nmt_generate_evaluate_enja_big.sh
```

## NMT Models Comparison
<table>
    <caption>Information of the Corpora</caption>
    <thead>
        <tr>
            <th width=120>Corpus</th>
            <th colspan=2 width=180>NTT-JParaCrawl</th>
            <th colspan=2 width=180>Laboro-ParaCorpus</th>
            <th colspan=2 width=180>Laboro-ParaCorpus+</th>
            <th colspan=2 width=180>Laboro-ParaCorpus-NTT</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>corpus size</td>
            <td colspan=2>2.4 G</td>
            <td colspan=2>1.6 G</td>
            <td colspan=2>1.6 G</td>
            <td colspan=2>4.0 G</td>
        </tr>
        <tr>
            <td># sentence pairs</td>
            <td colspan=2>8.8 M</td>
            <td colspan=2>14 M</td>
            <td colspan=2>14 M</td>
            <td colspan=2>23 M</td>
        </tr>
        <tr>
            <td># tokens (EN/JA)</td>
            <td>254 M</td>
            <td>228 M</td>
            <td>163 M</td>
            <td>148 M</td>
            <td>164 M</td>
            <td>149 M</td>
            <td>420 M</td>
            <td>376 M</td>
        </tr>

<table>
    <caption>BLEU Scores of EN-JA Base Models</caption>
    <thead>
        <tr>
            <th width=120>Model</th>
            <th colspan=2 width=180>NTT-JParaCrawl</th>
            <th colspan=2 width=180>Laboro-ParaCorpus</th>
            <th colspan=2 width=180>Laboro-ParaCorpus+</th>
            <th colspan=2 width=180>Laboro-ParaCorpus-NTT</th>
            <th width=100>Google Cloud</br>Translate</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td></td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
        </tr>
        <tr>
            <td>ASPEC</td>
            <td>17.4</td>
            <td>30.1</td>
            <td>17.9</td>
            <td>29.4</td>
            <td>17.9</td>
            <td>29.5</td>
            <td>18.0</td>
            <td>29.9</td>
            <td>23.1</td>
        </tr>
        <tr>
            <td>JESC</td>
            <td>6.0</td>
            <td>12.8</td>
            <td>5.9</td>
            <td>11.9</td>
            <td>6.2</td>
            <td>12.4</td>
            <td>6.5</td>
            <td>12.3</td>
            <td>7.9</td>
        </tr>
        <tr>
            <td>KFTT</td>
            <td>14.7</td>
            <td>27.8</td>
            <td>14.2</td>
            <td>27.6</td>
            <td>14.2</td>
            <td>27.7</td>
            <td>15.0</td>
            <td>28.8</td>
            <td>14.9</td>
        </tr>
        <tr>
            <td>IWSLT</td>
            <td>11.3</td>
            <td>13.9</td>
            <td>10.5</td>
            <td>13.6</td>
            <td>10.2</td>
            <td>14.0</td>
            <td>11.3</td>
            <td>13.9</td>
            <td>14.8</td>
        </tr>
        <tr>
            <td>Duolingo</td>
            <td>47.8</td>
            <td>-</td>
            <td>42.0</td>
            <td>-</td>
            <td>41.2</td>
            <td>-</td>
            <td>46.9</td>
            <td>-</td>
            <td>55.4</td>
        </tr>
        <tr>
            <td>Tatoeba</td>
            <td>19.7</td>
            <td>-</td>
            <td>19.5</td>
            <td>-</td>
            <td>20.6</td>
            <td>-</td>
            <td>20.2</td>
            <td>-</td>
            <td>28.2</td>
        </tr>
        <tr>
            <td>BSD</td>
            <td>10.6</td>
            <td>-</td>
            <td>11.6</td>
            <td>-</td>
            <td>12.5</td>
            <td>-</td>
            <td>11.7</td>
            <td>-</td>
            <td>15.8</td>
        </tr>
    </tbody>
</table>

<table>
    <caption>BLEU Scores of EN-JA Big Models</caption>
    <thead>
        <tr>
            <th width=120>Model</th>
            <th colspan=2 width=180>NTT-JParaCrawl</th>
            <th colspan=2 width=180>Laboro-ParaCorpus</th>
            <th colspan=2 width=180>Laboro-ParaCorpus+</th>
            <th colspan=2 width=180>Laboro-ParaCorpus-NTT</th>
            <th width=100>Google Cloud</br>Translate</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td></td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
        </tr>
        <tr>
            <td>ASPEC</td>
            <td>19.4</td>
            <td>31.1</td>
            <td>18.8</td>
            <td>30.8</td>
            <td>18.7</td>
            <td>30.9</td>
            <td>20.2</td>
            <td>31.2</td>
            <td>23.1</td>
        </tr>
        <tr>
            <td>JESC</td>
            <td>6.5</td>
            <td>13.1</td>
            <td>6.0</td>
            <td>13.1</td>
            <td>6.3</td>
            <td>12.9</td>
            <td>6.6</td>
            <td>13.8</td>
            <td>7.9</td>
        </tr>
        <tr>
            <td>KFTT</td>
            <td>15.7</td>
            <td>29.6</td>
            <td>15.9</td>
            <td>29.5</td>
            <td>15.9</td>
            <td>29.1</td>
            <td>17.3</td>
            <td>29.7</td>
            <td>14.9</td>
        </tr>
        <tr>
            <td>IWSLT</td>
            <td>12.1</td>
            <td>13.5</td>
            <td>11.0</td>
            <td>13.8</td>
            <td>11.0</td>
            <td>14.2</td>
            <td>12.3</td>
            <td>14.2</td>
            <td>14.8</td>
        </tr>
        <tr>
            <td>Duolingo</td>
            <td>47.6</td>
            <td>-</td>
            <td>41.4</td>
            <td>-</td>
            <td>40.0</td>
            <td>-</td>
            <td>44.5</td>
            <td>-</td>
            <td>55.4</td>
        </tr>
        <tr>
            <td>Tatoeba</td>
            <td>21.1</td>
            <td>-</td>
            <td>20.1</td>
            <td>-</td>
            <td>22.3</td>
            <td>-</td>
            <td>21.3</td>
            <td>-</td>
            <td>28.2</td>
        </tr>
        <tr>
            <td>BSD</td>
            <td>11.5</td>
            <td>-</td>
            <td>12.6</td>
            <td>-</td>
            <td>13.8</td>
            <td>-</td>
            <td>12.3</td>
            <td>-</td>
            <td>15.8</td>
        </tr>
    </tbody>
</table>

<table>
    <caption>BLEU Scores of JA-EN Base Models</caption>
    <thead>
        <tr>
            <th width=120>Model</th>
            <th colspan=2 width=180>NTT-JParaCrawl</th>
            <th colspan=2 width=180>Laboro-ParaCorpus</th>
            <th colspan=2 width=180>Laboro-ParaCorpus+</th>
            <th colspan=2 width=180>Laboro-ParaCorpus-NTT</th>
            <th width=100>Google Cloud</br>Translate</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td></td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
        </tr>
        <tr>
            <td>ASPEC</td>
            <td>19.1</td>
            <td>30.1</td>
            <td>20.3</td>
            <td>29.8</td>
            <td>20.0</td>
            <td>30.0</td>
            <td>20.3</td>
            <td>30.2</td>
            <td>24.6</td>
        </tr>
        <tr>
            <td>JESC</td>
            <td>7.5</td>
            <td>18.7</td>
            <td>7.0</td>
            <td>17.7</td>
            <td>7.6</td>
            <td>17.6</td>
            <td>7.6</td>
            <td>18.9</td>
            <td>7.8</td>
        </tr>
        <tr>
            <td>KFTT</td>
            <td>15.0</td>
            <td>26.8</td>
            <td>14.5</td>
            <td>26.4</td>
            <td>14.6</td>
            <td>26.4</td>
            <td>15.6</td>
            <td>26.7</td>
            <td>19.1</td>
        </tr>
        <tr>
            <td>IWSLT</td>
            <td>11.7</td>
            <td>18.1</td>
            <td>12.0</td>
            <td>18.0</td>
            <td>12.2</td>
            <td>18.1</td>
            <td>12.1</td>
            <td>18.1</td>
            <td>13.1</td>
        </tr>
        <tr>
            <td>Duolingo</td>
            <td>41.7</td>
            <td>-</td>
            <td>39.7</td>
            <td>-</td>
            <td>38.5</td>
            <td>-</td>
            <td>41.6</td>
            <td>-</td>
            <td>42.2</td>
        </tr>
        <tr>
            <td>Tatoeba</td>
            <td>28.5</td>
            <td>-</td>
            <td>26.9</td>
            <td>-</td>
            <td>29.0</td>
            <td>-</td>
            <td>29.1</td>
            <td>-</td>
            <td>33.3</td>
        </tr>
        <tr>
            <td>BSD</td>
            <td>16.8</td>
            <td>-</td>
            <td>16.1</td>
            <td>-</td>
            <td>18.1</td>
            <td>-</td>
            <td>17.4</td>
            <td>-</td>
            <td>18.4</td>
        </tr>
    </tbody>
</table>

<table>
    <caption>BLEU Scores of JA-EN Big Models</caption>
    <thead>
        <tr>
            <th width=120>Model</th>
            <th colspan=2 width=180>NTT-JParaCrawl</th>
            <th colspan=2 width=180>Laboro-ParaCorpus</th>
            <th colspan=2 width=180>Laboro-ParaCorpus+</th>
            <th colspan=2 width=180>Laboro-ParaCorpus-NTT</th>
            <th width=100>Google Cloud</br>Translate</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td></td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
            <td>FT</td>
            <td>PT</td>
        </tr>
        <tr>
            <td>ASPEC</td>
            <td>20.1</td>
            <td>31.0</td>
            <td>19.9</td>
            <td>30.7</td>
            <td>20.3</td>
            <td>30.2</td>
            <td>20.6</td>
            <td>30.9</td>
            <td>24.6</td>
        </tr>
        <tr>
            <td>JESC</td>
            <td>7.5</td>
            <td>19.7</td>
            <td>7.6</td>
            <td>18.4</td>
            <td>8.3</td>
            <td>19.0</td>
            <td>8.5</td>
            <td>19.4</td>
            <td>7.8</td>
        </tr>
        <tr>
            <td>KFTT</td>
            <td>16.2</td>
            <td>27.2</td>
            <td>15.4</td>
            <td>26.5</td>
            <td>16.1</td>
            <td>26.8</td>
            <td>17.5</td>
            <td>27.5</td>
            <td>19.1</td>
        </tr>
        <tr>
            <td>IWSLT</td>
            <td>12.8</td>
            <td>17.7</td>
            <td>13.0</td>
            <td>18.6</td>
            <td>13.3</td>
            <td>18.8</td>
            <td>13.6</td>
            <td>19.0</td>
            <td>13.1</td>
        </tr>
        <tr>
            <td>Duolingo</td>
            <td>42.2</td>
            <td>-</td>
            <td>40.9</td>
            <td>-</td>
            <td>40.1</td>
            <td>-</td>
            <td>42.8</td>
            <td>-</td>
            <td>42.2</td>
        </tr>
        <tr>
            <td>Tatoeba</td>
            <td>31.4</td>
            <td>-</td>
            <td>29.1</td>
            <td>-</td>
            <td>32.0</td>
            <td>-</td>
            <td>31.7</td>
            <td>-</td>
            <td>33.3</td>
        </tr>
        <tr>
            <td>BSD</td>
            <td>17.3</td>
            <td>-</td>
            <td>17.5</td>
            <td>-</td>
            <td>19.4</td>
            <td>-</td>
            <td>19.2</td>
            <td>-</td>
            <td>18.4</td>
        </tr>
    </tbody>
</table>
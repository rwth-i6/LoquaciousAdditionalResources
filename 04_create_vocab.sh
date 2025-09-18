#!/bin/bash
set -vex

#cat loquacious-large.txt | tr ' ' '\n' | sort | uniq -c > train-counts.txt
cat train-counts.txt | awk '{print $2}' | sort > train-words.txt

# extract words that appear both in the training data and in cmudict
comm -12 train-words.txt cmudict-words.txt > cmudict-train-intersection-words.txt
cat train-counts.txt | awk '{if($1>=4){print $2}}' > train-min-4-occurences-words.txt
cat cmudict-train-intersection-words.txt train-min-4-occurences-words.txt | sort | uniq > loquacious-vocab.txt
comm -23 loquacious-vocab.txt cmudict-words.txt > nondict-words.txt

g2p.py -e utf-8 -V 1.0 --variants-number 2 -m g2p_model_5 -a nondict-words.txt > nondict-words.g2p.txt

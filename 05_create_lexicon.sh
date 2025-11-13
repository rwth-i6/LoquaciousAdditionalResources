#!/bin/bash
set -vex
if [ ! -f loquacious-lexicon.80%-g2p-variants.txt ]; then
    python3 lexicon_helper.py --vocab_file loquacious.vocab.txt --cmu_lexicon_file cmudict.g2p-train.txt --target_lexicon_file  loquacious-lexicon.80%-g2p-variants.txt --oov_lexicon_file nondict.g2p.txt --variant_mass_threshold 0.2
fi
if [ ! -f loquacious-lexicon.60%-g2p-variants.txt ]; then
    python3 lexicon_helper.py --vocab_file loquacious.vocab.txt --cmu_lexicon_file cmudict.g2p-train.txt --target_lexicon_file  loquacious-lexicon.60%-g2p-variants.txt --oov_lexicon_file nondict.g2p.txt --variant_mass_threshold 0.4
fi
if [ ! -f loquacious-lexicon.no-g2p-variants.txt ]; then
    python3 lexicon_helper.py --vocab_file loquacious.vocab.txt --cmu_lexicon_file cmudict.g2p-train.txt --target_lexicon_file  loquacious-lexicon.no-g2p-variants.txt --oov_lexicon_file nondict.g2p.txt --variant_mass_threshold 0.5
fi

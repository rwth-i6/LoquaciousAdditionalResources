#!/bin/bash
if [ ! -f 3gram-pruned.arpa.gz ]; then
    kenlm/build/bin/lmplz -o 3 -S 25% -T /var/tmp --prune 0 0 1 --limit_vocab_file loquacious.vocab.txt --text loquacious-large.txt | gzip > 3gram-pruned.arpa.gz
fi
if [ ! -f 3gram-unpruned.arpa.gz ]; then
    kenlm/build/bin/lmplz -o 3 -S 25% -T /var/tmp --prune 0 0 0 --limit_vocab_file loquacious.vocab.txt --text loquacious-large.txt | gzip > 3gram-unpruned.arpa.gz
fi
if [ ! -f 4gram-pruned.arpa.gz ]; then
    kenlm/build/bin/lmplz -o 4 -S 25% -T /var/tmp --prune 0 0 1 1 --limit_vocab_file loquacious.vocab.txt --text loquacious-large.txt | gzip > 4gram-pruned.arpa.gz
fi
if [ ! -f 4gram-unpruned.arpa.gz ]; then
    kenlm/build/bin/lmplz -o 4 -S 25% -T /var/tmp --prune 0 0 0 0 --limit_vocab_file loquacious.vocab.txt --text loquacious-large.txt | gzip > 4gram-unpruned.arpa.gz
fi

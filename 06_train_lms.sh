#!/bin/bash
PWD=$(pwd)
BIND=$(realpath $PWD)
if [ ! -f 3gram-pruned.arpa.gz ]; then
    apptainer run -B $BIND apptainer.sif kenlm/build/bin/lmplz -o 3 -S 25% -T /var/tmp --prune "001" --limit_vocab_file loquacious-vocab.txt --text loquacious-large.txt | gzip > 3gram-pruned.arpa.gz
fi
if [ ! -f 3gram-unpruned.arpa.gz ]; then
    apptainer run -B $BIND apptainer.sif kenlm/build/bin/lmplz -o 3 -S 25% -T /var/tmp --prune "000" --limit_vocab_file loquacious-vocab.txt --text loquacious-large.txt | gzip > 3gram-unpruned.arpa.gz
fi
if [ ! -f 4gram-pruned.arpa.gz ]; then
    apptainer run -B $BIND apptainer.sif kenlm/build/bin/lmplz -o 4 -S 25% -T /var/tmp --prune "0011" --limit_vocab_file loquacious-vocab.txt --text loquacious-large.txt | gzip > 4gram-pruned.arpa.gz
fi
if [ ! -f 4gram-unpruned.arpa.gz ]; then
    apptainer run -B $BIND apptainer.sif kenlm/build/bin/lmplz -o 4 -S 25% -T /var/tmp --prune "0000" --limit_vocab_file loquacious-vocab.txt --text loquacious-large.txt | gzip > 4gram-unpruned.arpa.gz
fi

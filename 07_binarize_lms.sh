#!/bin/bash
if [ ! -f 3gram-pruned.arpa.bin ]; then
    kenlm/build/bin/build_binary 3gram-pruned.arpa.gz 3gram-pruned.arpa.bin
fi
if [ ! -f 3gram-unpruned.arpa.bin ]; then
    kenlm/build/bin/build_binary 3gram-unpruned.arpa.gz 3gram-unpruned.arpa.bin
fi
if [ ! -f 4gram-pruned.arpa.bin ]; then
    kenlm/build/bin/build_binary 4gram-pruned.arpa.gz 4gram-pruned.arpa.bin
fi
if [ ! -f 4gram-unpruned.arpa.bin ]; then
    kenlm/build/bin/build_binary 4gram-unpruned.arpa.gz 4gram-unpruned.arpa.bin
fi

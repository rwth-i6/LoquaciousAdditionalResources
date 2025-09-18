"""
Create the final lexicon by doing the following:
 - loading the generated final vocab file to determine which cmudict entries to load
 - write all cmu dict entries into the lexicon
 - write all oov lexicon entries with a relative pronunciation variant mass of at least <VARIANT_MASS_THRESHOLD> into the lexion
"""
from collections import defaultdict
import sys

# this is the minimum relative amount for a pronunciation variant to be considered
VARIANT_MASS_THRESHOLD = 0.2

vocab_file = "loquacious-vocab.txt"
cmu_lexicon_file = "cmudict.g2p-train.txt"
oov_lexicon_file = "nondict-words.g2p.txt"
target_lexicon_file = "loquacious-lexicon.txt"

vocab = set()
lexicon = defaultdict(lambda: [])

with open(vocab_file, "rt") as f:
    for line in f.readlines():
        vocab.add(line.strip())

with open(cmu_lexicon_file, "rt") as f:
    for line in f.readlines():
        split = line.strip().split(" ")
        assert len(split) >= 2
        if split[0] in vocab:
            lexicon[split[0]].append(" ".join(split[1:]))

current_variants = dict()
current_word = None
total = 0
filtered = 0

with open(oov_lexicon_file, "rt") as f:
    for i, line in enumerate(f.readlines()):
        split = line.strip().split("\t")
        assert len(split) in [3,4], f"line {i} error: {split}"
        if len(split) == 3:
            print(f"warning: line {i} empty pronunciation for {split[0]}")
            continue
        word, variant, variant_mass, pron = split
        if word == current_word:
            current_variants[variant] = (variant_mass, pron)
        else:
            # process current variants
            total_mass = sum([float(variant[0]) for variant in current_variants.values()])
            for mass, p in current_variants.values():
                total += 1
                if float(mass) > VARIANT_MASS_THRESHOLD * total_mass:
                    lexicon[current_word].append(p)
                else:
                    filtered += 1

            # start with new word
            current_word = word 
            current_variants = dict()
            current_variants[variant] = (variant_mass, pron)

    # process remaining
    total_mass = sum([float(variant[0]) for variant in current_variants.values()])
    for variant_mass, pron in current_variants.values():
        if float(variant_mass) > VARIANT_MASS_THRESHOLD * total_mass:
            lexicon[current_word].append(pron)

print(f"total g2p entries: {total}")
print(f"filtered g2p entries: {filtered}")

with open(target_lexicon_file, "wt") as f:
    for word, prons in sorted(lexicon.items()):
        for pron in prons:
            f.write(f"{word} {pron}\n")

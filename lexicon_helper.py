"""
Create the final lexicon by doing the following:
 - loading the generated final vocab file to determine which cmudict entries to load
 - write all cmu dict entries into the lexicon
 - write all oov lexicon entries with a relative pronunciation variant mass of at least <VARIANT_MASS_THRESHOLD> into the lexion
"""
import argparse
import sys

from collections import defaultdict
from typing import Optional


def main():
    parser = argparse.ArgumentParser(description="Lexicon creation helper")

    parser.add_argument('--vocab_file', type=str, default="loquacious-vocab.txt", required=True)
    parser.add_argument('--cmu_lexicon_file', type=str, default="cmudict.g2p-train.txt", required=True)
    parser.add_argument('--target_lexicon_file', type=str, required=True)

    # optional arguments
    parser.add_argument('--variant_mass_threshold', type=float, default=None)
    parser.add_argument('--oov_lexicon_file', type=str, default=None)

    args = parser.parse_args()   

    variant_mass_threshold = args.variant_mass_threshold

    vocab = set()
    lexicon = defaultdict(lambda: [])

    with open(args.vocab_file, "rt") as f:
        for line in f.readlines():
            vocab.add(line.strip())

    with open(args.cmu_lexicon_file, "rt") as f:
        for line in f.readlines():
            split = line.strip().split(" ")
            assert len(split) >= 2
            if split[0] in vocab:
                lexicon[split[0]].append(" ".join(split[1:]))

    current_variants = dict()
    current_word = None

    if args.oov_lexicon_file is not None:
        if variant_mass_threshold is None:
            variant_mass_threshold = 0.5

        assert variant_mass_threshold <= 0.5 and variant_mass_threshold >= 0.0, (
            "variant_mass_threshold needs to be in the range [0.0, 0.5]"
            )

        total = 0
        filtered = 0

        with open(args.oov_lexicon_file, "rt") as f:
            for i, line in enumerate(f.readlines()):
                split = line.strip().split("\t")
                assert len(split) in [3,4], f"line {i} error: {split}"
                if len(split) == 3:
                    print(f"warning: line {i} empty pronunciation for {split[0]}", file=sys.stderr)
                    continue
                word, variant, variant_mass, pron = split
                if word == current_word:
                    current_variants[variant] = (variant_mass, pron)
                else:
                    # process current variants
                    total_mass = sum([float(variant[0]) for variant in current_variants.values()])
                    for mass, p in current_variants.values():
                        total += 1
                        if float(mass) > variant_mass_threshold * total_mass:
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
                if float(variant_mass) > variant_mass_threshold * total_mass:
                    lexicon[current_word].append(pron)

        print(f"total g2p entries: {total}", file=sys.stderr)
        print(f"filtered g2p entries: {filtered}", file=sys.stderr)
    else:
        assert variant_mass_threshold is None, (
            "only set variant_mas_threshold if an oov lexicon is provided"
        )

    with open(args.target_lexicon_file, "wt") as f:
        for word, prons in sorted(lexicon.items()):
            for pron in prons:
                f.write(f"{word} {pron}\n")

if __name__ == "__main__":
    main()

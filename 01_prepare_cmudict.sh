#!/bin/bash
set -vex

if [ ! -f cmudict-0.7b ]; then
    wget http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b
fi
SHA256=209a8b4cd265013e96f4658632a9878103b0c5abf62b50d4ef3ae1be226b29e4
echo "$SHA256 cmudict-0.7b"  | sha256sum  -c

# Select only rows that are no comment and contain the characters valid for the Loquacious dataset, which are all letters and apostrophe.
# We still keep the numbers for the stress markers and pronunciation variants
cat cmudict-0.7b | grep -v "^;;;" | grep "^[a-zA-Z'][a-zA-Z0-9' ()]*$" | sed 's/([0-9])//g' > cmudict.g2p-train.txt
cat cmudict.g2p-train.txt | cut -d' ' -f1 | sort | uniq > cmudict-words.txt

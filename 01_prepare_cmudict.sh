#!/bin/bash
set -vex

if [ ! -f cmudict-0.7b ]; then
    wget http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b
fi
SHA256=209a8b4cd265013e96f4658632a9878103b0c5abf62b50d4ef3ae1be226b29e4
echo "$SHA256 cmudict-0.7b"  | sha256sum  -c

# Select only rows that are no comment and contain the characters valid for the Loquacious dataset, which are all letters and apostrophe.
# We still keep the numbers for the stress markers and pronunciation variants
# List of operations:
# 1. filter comments
# 2. filter for entries with valid symbols only (letters, numbers and apostrophe)
# 3. remove the marker for pronunciation variant number
# 4. remove special cases where the word already contains numbers
# 5. remove stress marker numbers
cat cmudict-0.7b | grep -v "^;;;" | grep "^[a-zA-Z'][a-zA-Z0-9' ()]*$" | sed 's/([0-9])//g' | grep -v "^[A-Z']*[0-9][A-Z0-9']* " | sed 's/[0-9]//g' > cmudict.g2p-train.txt

# Extract only the words for later usage
cat cmudict.g2p-train.txt | cut -d' ' -f1 | sort | uniq > cmudict.words.txt

#!/bin/bash
set -vex

if [ ! -f "g2p_model_0" ]; then
    python3 -m g2p -e utf-8 -i 1 -I 60 -d "5%" -s "0,1,0,1" -n g2p_model_0 -S -t cmudict.g2p-train.txt > g2p_log_0
    cat g2p_log_0 | grep "total symbol errors" > g2p_err_0
else
    echo "found existing g2p model 0, skip"
fi
for i in {1..5}; do
    if [ ! -f "g2p_model_$i" ]; then
        g2p.py -e utf-8 -i 1 -I 60 -d "5%" -s "0,1,0,1" -n g2p_model_$i -S -t cmudict.g2p-train.txt -r -m g2p_model_$((i - 1)) > g2p_log_$i
        cat g2p_log_$i | grep "total symbol errors" > g2p_err_$i
    else
        echo "found existing g2p model $i, skip"
    fi
done

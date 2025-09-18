import datasets
import os
import tqdm

assert "HF_HOME" in os.environ, (
    "please provide an explicit path for the HF_HOME environment variable "
    "to be aware of the actual Hugginface dataset download location"
)

ds = load_dataset('speechbrain/LoquaciousSet', 'large', num_proc=8, split="train")
with open("loquacious-large.txt", "wt") as f:
    for s in tqdm(ds):
        f.write(s['text'] + '\n')

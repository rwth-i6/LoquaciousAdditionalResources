#!/bin/bash
# create an apptainer image and compile KenLM
# You might need additional parameters for the apptainer build or application
set -vex

PWD=$(pwd)
BIND=$(realpath $PWD)
if [! -f apptainer.def ]; then
    apptainer build apptainer.sif apptainer.def
fi
if [! -d kenlm ]; then
    git clone https://github.com/kpu/kenlm.git
fi
cd kenlm
mkdir -p build
cd build
apptainer run -B $BIND:$BIND ../../apptainer.sif cmake ..
apptainer run -B $BIND:$BIND ../../apptainer.sif make -j8 all

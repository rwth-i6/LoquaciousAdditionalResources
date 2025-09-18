#!/bin/bash
apptainer build apptainer.sif apptainer.def
git clone https://github.com/kpu/kenlm.git
cd kenlm
mkdir build
cd build
apptainer run ../../apptainer.sif cmake ..
apptainer run ../../apptainer.sif make -j8 all

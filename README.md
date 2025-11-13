# Additional Loquacious Resources

This repository contains scripts to create pronunciation lexica and count-based language model in ARPA-format for the [Loquacious dataset](https://huggingface.co/datasets/speechbrain/LoquaciousSet).

## Usage

This repository uses Apptainer for a containerized environment to run the exact build process on any machine.
Apptainer is fully compatible to Singularity.
If Singularity is used each `apptainer` command can be edited to `singularity`.

You can call `00_create_apptainer_and_kenlm.sh` to create the apptainer image and compile KenLM with it. Afterwards, each script should be called via apptainer, e.g.:

`apptainer run --bind <current_filesystem_root> 01_prepare_cmudict.sh`

The bind parameter is necessary in case you are not operating within your user folder. For more information on binds look [here](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html).



#!/bin/bash
set -euo pipefail

#might have to edit
PROJECT_DIR="/home/anoopreh/scratch/projects/muse_multimodal_rl/src/cut"
JOB_SCRIPT="/home/anoopreh/scratch/projects/muse_multimodal_rl/src/cut/cut_train.sh"

cd "$PROJECT_DIR"
N=$(LIST_COMMANDS=1 python cc_train.py)
if [[ -z "${N}" || "${N}" -le 0 ]]; then
  echo "No commands found in cc_train.py (N=${N})"; exit 1
fi

echo "Submitting array 0-$((N-1))"
sbatch --array=0-$((N-1)) "$JOB_SCRIPT"


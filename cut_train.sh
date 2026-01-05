#!/bin/bash
#SBATCH --job-name=cut_train
#SBATCH --output=logs/%x_%A_%a.out
#SBATCH --error=logs/%x_%A_%a.err
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=00:10:00

# Load Compute Canada modules
module --force purge
module load StdEnv/2023
module load intel/2023.2.1
module load cuda/11.8
module load python/3.11
module load apptainer

#update vsmae to mars 
SIF_PATH="/home/anoopreh/scratch/projects/muse_multimodal_rl/src/multimodal_rl/apptainer_files/vsmae.sif"
HOST_WORKDIR="/home/anoopreh/scratch/projects/muse_multimodal_rl/src/cut"

mkdir -p logs

# --- Weights & Biases ---
export WANDB_API_KEY=473f2523bc6fadec1110660439773faf8ec29e60

# (Optional) quick CUDA visibility check per task
apptainer exec --nv -B "${HOST_WORKDIR}:/work" "${SIF_PATH}" bash -lc '
  set -e
  export PATH=/opt/conda/envs/vsmae/bin:$PATH
  python - << "PY"
import torch
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("GPU:", torch.cuda.get_device_name(0))
PY
'

# Run the command selected by SLURM_ARRAY_TASK_ID
apptainer exec --nv \
  -B "${HOST_WORKDIR}:/work" \
  "${SIF_PATH}" bash -lc '
    set -e
    cd /work
    export PATH=/opt/conda/envs/vsmae/bin:$PATH
    export PYTHONPATH=/work:$PYTHONPATH
    # Set SSL certificate paths - use certifi if available, otherwise system certs
    CERTIFI_CERT=$(python -c "import certifi; print(certifi.where())" 2>/dev/null || echo "")
    if [ -n "$CERTIFI_CERT" ] && [ -f "$CERTIFI_CERT" ]; then
        export SSL_CERT_FILE="$CERTIFI_CERT"
        export REQUESTS_CA_BUNDLE="$CERTIFI_CERT"
    else
        export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
        export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
    fi
    python -u cc_train.py
  '


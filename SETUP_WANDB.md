# Setting up WANDB_API_KEY for Compute Canada

## Quick Setup

### Step 1: Get your new API key
1. Go to https://wandb.ai/settings
2. Create a new API key
3. Copy it

### Step 2: Set it on Compute Canada

**Option A: Set in your Compute Canada account (Recommended)**
- Log into Compute Canada
- Go to account settings → Environment Variables
- Add: `WANDB_API_KEY=your_new_key_here`

**Option B: Set in the job script (before apptainer exec)**
Add this line to `cut_train.sh` after line 22:
```bash
export WANDB_API_KEY=your_new_key_here
```

**Option C: Use a secrets file (local only, not in git)**
```bash
# On Compute Canada, create the file:
echo "your_new_key_here" > ~/.wandb_key
chmod 600 ~/.wandb_key

# Then in cut_train.sh, add before apptainer exec:
if [ -f ~/.wandb_key ]; then
    export WANDB_API_KEY=$(cat ~/.wandb_key)
fi
```

## Verify it works

The script will warn you if `WANDB_API_KEY` is not set. If you see the warning, check your setup.


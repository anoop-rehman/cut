import os, sys, subprocess


commands = [
    "python train.py --dataroot ./datasets/pushBlockWide_84x84 --name pushBlockWide_CUT --CUT_mode CUT --use_wandb --wandb_project cut --wandb_run pushBlockWide_CUT",
]

# Add more training commands here as needed
# commands = [
#     "python train.py --dataroot ./datasets/pushBlockWide_84x84 --name pushBlockWide_CUT_1 --CUT_mode CUT --use_wandb --wandb_project cut --wandb_run pushBlockWide_CUT_1",
#     "python train.py --dataroot ./datasets/pushBlockWide_84x84 --name pushBlockWide_CUT_2 --CUT_mode CUT --use_wandb --wandb_project cut --wandb_run pushBlockWide_CUT_2",
# ]


# ---- dynamic array helper: print number of commands and exit if probed ----
if os.environ.get("LIST_COMMANDS") == "1":
    print(len(commands))
    sys.exit(0)

task_id = int(os.environ.get("SLURM_ARRAY_TASK_ID", 0))
if not (0 <= task_id < len(commands)):
    print(f"Invalid SLURM_ARRAY_TASK_ID={task_id} for {len(commands)} commands")
    sys.exit(1)

cmd = commands[task_id]
print(f"Running (task {task_id}): {cmd}", flush=True)
subprocess.run(cmd, shell=True, check=True)


#!/bin/bash
set -e  # exit on error

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python_script="${script_dir}/../python/runCDAlgo.py"

# TODO: hard-coded venv path
PYTHON="/home/AD/lsucipto/miniconda3/envs/expertloop/bin/python"

"$PYTHON" "$python_script" "$@"
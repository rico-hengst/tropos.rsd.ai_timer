#!/bin/bash
# Script to run opencode with the project

# Activate conda environment locally first (for local use)
source /opt/conda/etc/profile.d/conda.sh
conda activate py3.11_local

# Build and run Docker container
docker build -t python-project-analyzer:latest \
    -f .mydocker/Dockerfile \
    --build-arg REQUIREMENTS_FILE=environment.yml \
    .

# Run opencode interactively
docker run --rm -it \
    --name python-analyzer \
    -v "$(pwd)":/workspace \
    -w /workspace \
    -e OPENCODE_AI_KEY="${OPENCODE_AI_KEY:-}" \
    python-project-analyzer:latest \
    opencode

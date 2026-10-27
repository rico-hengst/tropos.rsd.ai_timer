#!/bin/bash
# Setup script for Docker development environment

set -e

echo "🚀 Setting up Docker environment for Python project analysis..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Create Docker directory if it doesn't exist
mkdir -p .mydocker

# Build the Docker image
echo "📦 Building Docker image..."
docker build -t python-project-analyzer:latest \
    -f .mydocker/Dockerfile \
    --build-arg REQUIREMENTS_FILE=environment..yml \
    .

# Run opencode in Docker container
echo "🚀 Starting opencode in Docker container..."
docker run --rm -it \
    --name python-analyzer \
    -v "$(pwd)":/workspace \
    -w /workspace \
    python-project-analyzer:latest \
    opencode

echo "✅ Setup complete!"

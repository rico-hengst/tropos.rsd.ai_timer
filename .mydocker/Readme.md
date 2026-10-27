# Docker Setup for Python Project Analysis with opencode

## Prerequisites
- Docker installed
- Python project in `/home/user/project1/`
- Conda environment `py3.11_local` exported to `requirements.txt`

## Quick Start

### Option 1: Setup script
```bash
cd /home/user/project1
chmod +x .mydocker/setup.sh
./.mydocker/setup.sh



docker run -it --rm \
    -v "$(pwd)":/workspace \
    -w /workspace \
    python-project-analyzer:latest \
    opencode
    
    
    
## 1\. Create the Dockerfile

First, create the directory and Dockerfile:

```
<div><p><code id="code-lang-bash"><span>mkdir</span> -p /home/user/project1/.mydocker
</code></p></div>
```

Create ```/home/user/project1/.mydocker/Dockerfile```:

```
<div><p><code id="code-lang-dockerfile"># Dockerfile for Python project analysis with opencode
FROM continuumio/anaconda3:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/conda/bin:${PATH}"

# Install basic utilities
RUN apt-get update &amp;&amp; apt-get install -y \
    curl \
    git \
    &amp;&amp; rm -rf /var/lib/apt/lists/*

# Create conda environment from requirements.txt
# Note: We need to check if requirements.txt exists at build time
ARG REQUIREMENTS_FILE=requirements.txt
COPY ${REQUIREMENTS_FILE} /tmp/requirements.txt

# Create conda environment from requirements file
RUN conda create -n py3.11_docker python=3.11 -y \
    &amp;&amp; conda run -n py3.11_docker pip install --no-cache-dir -r /tmp/requirements.txt \
    || echo "No requirements.txt found or installation failed, creating basic env"

# Install opencode
RUN curl -fsSL https://opencode.ai/install | bash

# Add opencode to PATH
ENV PATH="/root/.opencode/bin:${PATH}"

# Set working directory
WORKDIR /workspace

# Copy project files (optional - if you want to include them in the image)
# COPY . /workspace/

# Create a startup script that activates the conda environment
RUN echo '#!/bin/bash\n\
source /opt/conda/etc/profile.d/conda.sh\n\
conda activate py3.11_docker\n\
exec "$@"' &gt; /usr/local/bin/entrypoint.sh \
    &amp;&amp; chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["bash"]
</code></p></div>
```


## 2\. Create docker-compose.yml (optional but recommended)

Create ```/home/user/project1/.mydocker/docker-compose.yml```:

```
<div><p><code id="code-lang-yaml"><span>version:</span> <span>'3.8'</span>

<span>services:</span>
  <span>python-analyzer:</span>
    <span>build:</span>
      <span>context:</span> <span>../</span>
      <span>dockerfile:</span> <span>.mydocker/Dockerfile</span>
      <span>args:</span>
        <span>REQUIREMENTS_FILE:</span> <span>requirements.txt</span>
    <span>image:</span> <span>python-project-analyzer:latest</span>
    <span>container_name:</span> <span>python-analyzer</span>
    <span>volumes:</span>
      <span>-</span> <span>../:/workspace</span>
    <span>working_dir:</span> <span>/workspace</span>
    <span>stdin_open:</span> <span>true</span>
    <span>tty:</span> <span>true</span>
    <span>environment:</span>
      <span>-</span> <span>OPENCODE_AI_KEY=${OPENCODE_AI_KEY:-}</span> <span># Add your API key if needed</span>
    <span>command:</span> <span>opencode</span>
</code></p></div>
```

## 3\. Create a setup script

Create ```/home/user/project1/.mydocker/setup.sh```:

```
<div><p><code id="code-lang-bash"><span>#!/bin/bash</span>
<span># Setup script for Docker development environment</span>

<span>set</span> -e

<span>echo</span> <span>"🚀 Setting up Docker environment for Python project analysis..."</span>

<span># Check if Docker is installed</span>
<span>if</span> ! <span>command</span> -v docker &amp;&gt; /dev/null; <span>then</span>
    <span>echo</span> <span>"❌ Docker is not installed. Please install Docker first."</span>
    <span>exit</span> 1
<span>fi</span>

<span># Create Docker directory if it doesn't exist</span>
<span>mkdir</span> -p .mydocker

<span># Build the Docker image</span>
<span>echo</span> <span>"📦 Building Docker image..."</span>
docker build -t python-project-analyzer:latest \
    -f .mydocker/Dockerfile \
    --build-arg REQUIREMENTS_FILE=requirements.txt \
    .

<span># Run opencode in Docker container</span>
<span>echo</span> <span>"🚀 Starting opencode in Docker container..."</span>
docker run --<span>rm</span> -it \
    --name python-analyzer \
    -v <span>"<span>$(pwd)</span>"</span>:/workspace \
    -w /workspace \
    python-project-analyzer:latest \
    opencode

<span>echo</span> <span>"✅ Setup complete!"</span>
</code></p></div>
```

## 4\. Create a usage script

Create ```/home/user/project1/.mydocker/run-opencode.sh```:

```
<div><p><code id="code-lang-bash"><span>#!/bin/bash</span>
<span># Script to run opencode with the project</span>

<span># Activate conda environment locally first (for local use)</span>
<span>source</span> /opt/conda/etc/profile.d/conda.sh
conda activate py3.11_local

<span># Build and run Docker container</span>
docker build -t python-project-analyzer:latest \
    -f .mydocker/Dockerfile \
    --build-arg REQUIREMENTS_FILE=requirements.txt \
    .

<span># Run opencode interactively</span>
docker run --<span>rm</span> -it \
    --name python-analyzer \
    -v <span>"<span>$(pwd)</span>"</span>:/workspace \
    -w /workspace \
    -e OPENCODE_AI_KEY=<span>"<span>${OPENCODE_AI_KEY:-}</span>"</span> \
    python-project-analyzer:latest \
    opencode
</code></p></div>
```

## 5\. Create a .dockerignore file

Create ```/home/user/project1/.dockerignore```:

```
<div><p><code id="code-lang-bash">__pycache__/
*.pyc
*.pyo
*.pyd
.Python
.<span>env</span>
.venv
venv/
ENV/
<span>env</span>/
.git/
.gitignore
*.egg-info/
dist/
build/
*.<span>log</span>
.coverage
.pytest_cache/
.mypy_cache/
.ipynb_checkpoints/
</code></p></div>
```

## 6\. Quick start guide

Create ```/home/user/project1/.mydocker/README.md```:

```
<div><p><code id="code-lang-markdown"><span># Docker Setup for Python Project Analysis with opencode</span>

<span>## Prerequisites</span>
<span>-</span> Docker installed
<span>-</span> Python project in <span>`/home/user/project1/`</span>
<span>-</span> Conda environment <span>`py3.11_local`</span> exported to <span>`requirements.txt`</span>

<span>## Quick Start</span>

<span>### Option 1: Setup script</span>
<span>```bash
cd /home/user/project1
chmod +x .mydocker/setup.sh
./.mydocker/setup.sh
</span></code></p></div>
```

### Option 2: Docker Compose

```
<div><p><code id="code-lang-bash"><span>cd</span> /home/user/project1/.mydocker
docker-compose up -d
</code></p></div>
```

### Option 3: Manual build

```
<div><p><code id="code-lang-bash"><span>cd</span> /home/user/project1
docker build -t python-project-analyzer:latest \
    -f .mydocker/Dockerfile \
    --build-arg REQUIREMENTS_FILE=requirements.txt \
    .
</code></p></div>
```

## Run opencode

```
<div><p><code id="code-lang-bash"><span># Interactive mode</span>
docker run -it --<span>rm</span> \
    -v <span>"<span>$(pwd)</span>"</span>:/workspace \
    -w /workspace \
    python-project-analyzer:latest \
    opencode

<span># Or use the provided script</span>
./.mydocker/run-opencode.sh
</code></p></div>
```

## Features

-   ✅ Python 3.11 environment (`py3.11_docker`)
-   ✅ opencode pre-installed
-   ✅ Anaconda base
-   ✅ Project files mounted as volume
-   ✅ Requirements file support
-   ✅ Interactive terminal support

## Notes

-   The requirements.txt is used to create the conda environment
-   Project files are mounted, not copied (better for development)
-   Set `OPENCODE_AI_KEY` environment variable if needed

````
<div><p><code id="code-lang-bash">
<span>## 7. Make scripts executable</span>

```bash
<span>cd</span> /home/user/project1
<span>chmod</span> +x .mydocker/setup.sh .mydocker/run-opencode.sh
</code></p></div>
````

## Usage Instructions:

1.  **Build the Docker image:**
    
    ```
    <div><p><code id="code-lang-bash"><span>cd</span> /home/user/project1
    docker build -t python-project-analyzer:latest \
        -f .mydocker/Dockerfile \
        --build-arg REQUIREMENTS_FILE=requirements.txt .
    </code></p></div>
    ```
    
2.  **Run opencode analysis:**
    
    ```
    <div><p><code id="code-lang-bash">docker run -it --<span>rm</span> \
        -v <span>"<span>$(pwd)</span>"</span>:/workspace \
        -w /workspace \
        python-project-analyzer:latest \
        opencode
    </code></p></div>
    ```
    
3.  **Access conda environment inside container:**
    
    ```
    <div><p><code id="code-lang-bash">docker run -it --<span>rm</span> \
        -v <span>"<span>$(pwd)</span>"</span>:/workspace \
        python-project-analyzer:latest \
        bash
    <span># Then inside the container:</span>
    conda activate py3.11_docker
    python your_script.py
    </code></p></div>
    ```
    

The setup ensures:

-   Anaconda base with Python 3.11 environment
-   All your requirements from `requirements.txt`
-   opencode pre-installed
-   Volume mounting for real-time file access
-   Isolated and reproducible environment

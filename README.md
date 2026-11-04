# tropos.rsd.ai_timer
Shorty: Docker sandbox for safe use of AI coding agent (OpenCode)


Target audience: This repository and tutorial are intended for scientists and engineers who want to use AI to develop and improve their software code.

Simple python project: Example to use OpenCode - terminal-first AI coding agent - to implement a decorator function wrapper

## 1 Requirements
* SAIA (Scalable Artificial Intelligence (AI) Accelerator) key, see [GWDG ai-services](https://docs.hpc.gwdg.de/services/ai-services/saia/index.html) (request via [API request](https://docs.hpc.gwdg.de/services/ai-services/saia/index.html#api-request))
* Access rights to build and run Docker images at your local computer

## 2 Intro: Agent coding

Agentic coding is a **software development approach** where autonomous **AI agents plan, write, test, and modify code** with minimal human intervention.  Unlike traditional coding assistants that provide passive suggestions, these agents execute complex workflows by navigating file systems, managing dependencies, and running terminal commands.

### Focus
Key characteristics include:

* *Autonomous Execution:* Agents take high-level goals (e.g., GitHub issues) and decompose them into actionable steps, iterating until the task is complete.
* *Self-Correction:* If an agent encounters an error, it reads the output, reasons through the problem, and automatically applies fixes.
* *Human Oversight:* Developers shift from writing code line-by-line to defining goals and reviewing the final output, focusing on architecture and logic.


### Coding agents and their operating environment

Popular coding agents as an software layer like Claude Code, OpenHands, Cursor, GitHub Copilot Coding Agent, OpenCode and Devin, connects LLM's to your software code.
The Coding agents operates via
* Terminal
* IDE, or
* Cloud environments.

---

The coding agent **"Opencode" and the "terminal based operating environment"** will be the focus here.


## 3 What you'll get here: Coding agent Opencode via isolated sandbox (docker)

This repo provides you an coding agent OpenCode that will run in a docker container (sandbox). You will be able to connect the OpenCode sandbox with your local software repository via a terminal based environment.
The Coding Agent only has access to the content of the local software repository.

#### Description short
1. After you've successfully cloned the Opencode Sandbox repo somewhere to your local computer (e.g: ```<~/docker_opencode_py>```), you'll first need to create an image.
2. You can then run the image you created in a sandbox.
    a) You can mount any local directory that contains the software repository you want to work on (e.g:  ```</xyz/yourproject>```).
    b) In the simplest case, this can be the Opencode Sandbox repo you just cloned (e.g: ```<~/docker_opencode_py>```).

#### Description long
* A: clone this repo

```shell
git clone https://github.com/rico-hengst/tropos.rsd.ai_timer.git <~/docker_opencode_py>
```
* B: export your python environment *optional*,
only necessary if your software code is *python* based and you want *execute python code in your sandbox*

```shell
# enter your project directory
cd </xyz/yourproject>

# case venv, export to
mv requirements.txt <~/docker_opencode_py/>

# case conda, export to
mv environment.yml <~/docker_opencode_py/>
```
* C: set SAIA key as environment variable

```shell
# export key
echo 'export SAIA_API_KEY="YOUR_SAIA_KEY"' >> ~/.bashrc
# test
echo "ENV SAIA_API_KEY ${SAIA_API_KEY} created"
```
* D: update OpenCode config file (GWDG update the LLM models regularly. To use the latest [GWDG chat-at models](https://docs.hpc.gwdg.de/services/ai-services/chat-ai/models/index.html), you must adjust the configuration.)

```shell
# get the current used LLM models via curl
curl -X POST \
  --url https://chat-ai.academiccloud.de/v1/models \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer <SAIA_API_KEY>' \
  --header 'Content-Type: application/json' | jq -S

# update OpenCode config file (delete unused, add models you are interested to use)
edit <~/docker_opencode_py/>.opencode/opencode.jsonc
```
* E: build docker container (only initial execution required or if python environment will be updated)

```shell
# enter docker repository
cd <~/docker_opencode_py>

# case conda is prefered
docker build --build-arg SAIA_API_KEY="${SAIA_API_KEY}" -t image_sbx_opencode_anaconda:latest     -f .mydocker/Dockerfile.conda     --build-arg ENV_FILE=environment.yml .

# case venv is prefered
docker build --build-arg SAIA_API_KEY="${SAIA_API_KEY}" -t image_sbx_opencode_venv:latest     -f .mydocker/Dockerfile.venv     --build-arg ENV_FILE=requirements.txt .
```

* F: run docker container and connect to your local software repository

```shell
# enter docker repository
cd <~/docker_opencode_py>

# case conda is prefered
docker run -it --rm     --user "$(id -u):$(id -g)"   -v "$(pwd)":/workspace     -w /workspace     image_sbx_opencode_anaconda:latest     bash
# case venv is prefered
docker run -it --rm     --user user   -v "$(pwd)":/workspace     -w /workspace     image_sbx_opencode_venv:latest     bash

```
* G: test and execute opencode at your sandbox

```shell
(py3.11_docker) user@142c945869d7:/workspace$

# test1
opencode run hello --print-logs
opencode debug config

# test2 Verification: You can test if it's working by running:
opencode auth list

# test3 config
OPENCODE_CONFIG=$PWD/.opencode/opencode.jsonc opencode debug config

# test4 first request - maybe the current default LLM model is not available
OPENCODE_CONFIG=$PWD/.opencode/opencode.jsonc opencode run "Tell me the current temperature!"

# test5 focussed model, make sure that model is at your opencode config list: --model <providername>/<model_key>
OPENCODE_CONFIG=$PWD/.opencode/opencode.jsonc opencode run --model saia/deepseek-v4-flash-0731 "Please suggest code improvements, with focus on files below the directory: 'src/*.py'"

```

## AI coding agent @ GWDG
* see [GWDG AI Services - AgenticCoding](https://docs.hpc.gwdg.de/services/ai-services/coco-ai/agentic_coding/index.html#claude-code-secu)
* see OpenCode subsection:
"OpenCode is an open-source, terminal-first AI coding agent that enables developers to
  * generate code,
  * modify files, execute commands, and
  * automate development tasks directly from the terminal."
* [opencode.ai/docs](https://opencode.ai/docs/de)
* install Open Code simple via curl (see also Sandbox container "tip")
* [request a SAIA API key](https://docs.hpc.gwdg.de/services/ai-services/saia/index.html#api-request) to use specific GWDG code agents
* create opencode project config: ```opencode.json```, insert SAIA API key if necessary

## Code project - short briefing

* simple test project
* focus to implement a feature to **measure execution times** in several "local" functions
* code structure
  * #```src```
    * ```core.py```, ```core_helper.py``` working horses python modules in which execution times of the included functions are to be measured
    * ```core_config.py``` module for logging preferences
  * #```config```
    * ```app.conf``` config file (test project requirements)
    * ```opencode.json``` to specify the preferences of your agent coding (not neccessary to execute the test project)
  ```
    ├── config
    │   └── app.conf
    └── src
        ├── core.py
        ├── core_config.py
        └── core_helper.py
   ```

Test config file:
```
OPENCODE_CONFIG=$PWD/opencode.json opencode --print-logs --log-level DEBUG run "hi"
```
```
opencode session list
```

Verifying on a device
```
opencode debug config
```

## OpenCode terminal request

1. Code suggestion

```
opencode run "Please explain how to implement a feature to measure execution times: How long does a function take to complete its task? The time in seconds should be logged via Pythons logging library."

> build · nemotron-3-ultra-free

Here's a simple implementation using a decorator to time function execution:

---python
import time
import functools
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def timer(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        duration = time.perf_counter() - start
        logger.info(f"{func.__name__} executed in {duration:.4f} seconds")
        return result
    return wrapper

# Usage
@timer
def my_function():
    time.sleep(1)
    return "done"
---

For async functions:
---python
def async_timer(func):
    @functools.wraps(func)
    async def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = await func(*args, **kwargs)
        duration = time.perf_counter() - start
        logger.info(f"{func.__name__} executed in {duration:.4f} seconds")
        return result
    return wrapper
---

Key points:
- Use `time.perf_counter()` for high-resolution timing
- `functools.wraps` preserves function metadata
- Log at INFO level with function name and duration
- Works as a decorator (`@timer`)

```

2. Code improvements

3. Code test units



# build
sudo docker build --build-arg SAIA_API_KEY="${SAIA_API_KEY}" -t python-project-analyzer:latest     -f .mydocker/Dockerfile     --build-arg ENV_FILE=environment.yml .
sudo docker build --build-arg SAIA_API_KEY="${SAIA_API_KEY}" -t image_sbx_opencode_anaconda:latest     -f .mydocker/Dockerfile.conda     --build-arg ENV_FILE=environment.yml .
sudo docker build --build-arg SAIA_API_KEY="${SAIA_API_KEY}" -t image_sbx_opencode_venv:latest     -f .mydocker/Dockerfile.venv     --build-arg ENV_FILE=requirements.txt .


# run
sudo docker run -it --rm     --user user     -v "$(pwd)":/workspace     -w /workspace     python-project-analyzer:latest     bash
ok
sudo docker run -it --rm     --user "$(id -u):$(id -g)"   -v "$(pwd)":/workspace     -w /workspace     image_sbx_opencode_anaconda:latest     bash
ok
sudo docker run -it --rm     --user "$(id -u):$(id -g)"   -v "$(pwd)":/workspace     -w /workspace     image_sbx_opencode_venv:latest     bash
not ok

# run somewhere
sudo docker run -it --rm     --user "$(id -u):$(id -g)"   -v "$(pwd)/../test_mqtt/":/workspace     -w /workspace     python-project-analyzer:latest     bash




opencode run hello --print-logs

opencode debug config

OPENCODE_CONFIG=$PWD/opencode.jsonc opencode debug config

OPENCODE_CONFIG=$PWD/opencode.jsonc opencode run --model saia/deepseek-v4-flash-0731 "Hi"

Verification:
You can test if it's working by running:
opencode auth list

# funktioniert
OPENCODE_CONFIG=.opencode/opencode.jsonc opencode run -m "saia/deepseek-v4-flash-0731" "hi"




# get current model:
curl -X POST   --url https://chat-ai.academiccloud.de/v1/models   --header 'Accept: application/json'   --header 'Authorization: Bearer 26c71b50e5cb3decaf823e3a56e3b189'   --header 'Content-Type: application/json' | jq -S

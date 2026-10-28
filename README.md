# tropos.rsd.ai_timer
Docker sandboxes for safe use of AI coding agent (opencode)


Target audience: 

Simple python project: Example to use OpenCode - terminal-first AI coding agent - to implement a decorator function wrapper

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
sudo docker run -it --rm     --user "$(id -u):$(id -g)"   -v "$(pwd)":/workspace     -w /workspace     image_sbx_opencode_anaconda:latest     bash
sudo docker run -it --rm     --user "$(id -u):$(id -g)"   -v "$(pwd)":/workspace     -w /workspace     image_sbx_opencode_venv:latest     bash
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


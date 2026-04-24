# Bash Agent Instructions

## Overview

This project implements a Bash-based AI agent framework that allows an LLM to interact with shell tools in a structured way. The agent runs entirely in Bash and communicates with a local LLM server (running on localhost:41080).

## Architecture

### Main Components

* Makefile - Used for deployment
* README.md
* bash-agent - Jumpstart script that sets up env vars
* lib/bash-agent/ba-curl - Wrapper for making HTTP requests to the LLM server
* lib/bash-agent/ba-shell - Main entry point that orchestrates the agent loop
* lib/bash-agent/tools/edit - Precise file edits
* lib/bash-agent/tools/execute - Tool to run bash commands
* lib/bash-agent/tools/find - File search tool
* lib/bash-agent/tools/read - Consents the LLM to read file content
* lib/bash-agent/tools/write - Write a new file
* tool-template.sh - Template for creating new tools

### How It Works

The agent operates in a loop:

1. **Initialization**: Sets up context files and loads available tools
2. **User Input**: Reads prompts from stdin (interactive or piped)
3. **LLM Communication**: Sends context to localhost:41080 via ba-curl
4. **Tool Execution**: Parses and executes tool calls requested by the LLM
5. **Result Handling**: Returns tool outputs back to the LLM
6. **Response Display**: Shows LLM responses to the user

## Context Management

The agent uses two temporary files for context management:
- `BA_AGENT_CONTEXT`: Current conversation context
- `BA_AGENT_TEMP_CONTEXT`: Temporary file for swapping during updates

Context is managed using `swap_context()` which exchanges these files to maintain conversation history.

## Tool System

### Tool Structure

Tools are stored in `$BA_PATH/tools/` directory and must:
- Be executable bash scripts
- Accept JSON arguments (parsed via jq)
- Support `-h` flag for help (returns OpenAI function definition)
- Support `-i` flag for infomode (interactive logging)

### Creating New Tools

1. Copy `tool-template.sh` to `tools/your-tool-name`
2. Make executable: `chmod +x tools/your-tool-name`
3. Implement `show_help()` with proper function definition
4. Parse arguments using jq from `$@`
5. Handle `infomode` flag for interactive logging
6. Implement actual tool logic

### Tool Communication

Tools receive arguments as JSON strings and must output results to stdout. Errors are captured and reported back to the LLM with exit status information.

## LLM Communication

- **Endpoint**: `http://localhost:41080/v1/chat/completions`
- **Format**: OpenAI-compatible API
- **Headers**: `Content-Type: application/json`
- **Timeout**: 20s connect, 7000s keepalive/max

## Interactive vs Non-Interactive Mode

- **Interactive** (TTY): Shows prompts, logs to stderr, allows user input
- **Non-Interactive** (Piped): Processes stdin input and exits after completion

## Error Handling

- Uses `set -e`, `set -u`, `set -o pipefail` for strict error handling
- Tool failures are captured and reported to LLM with exit status
- Cleanup trap removes temporary context files on exit

## Configuration

- `BA_PATH`: Base path for agent installation (default: `./lib/bash-agent`)
- Tools directory: `$BA_PATH/tools/`

## Usage

```bash
# Interactive mode
./bash-agent

# Non-interactive mode (piped input)
echo "Your question" | ./bash-agent
```

## Key Functions

- `log()`: Outputs to stderr in interactive mode
- `swap_context()`: Swaps context files for atomic updates
- `call_llm_updatecontext_and_print()`: Communicates with LLM and displays responses
- `show_help()`: Tool helper that returns function definition

## Best Practices

1. Always handle both infomode and execution modes in tools
2. Use jq for JSON argument parsing
3. Return proper exit codes (0 for success, non-zero for failure)
4. Keep tool descriptions clear in show_help()
5. Log meaningful messages in infomode for user visibility

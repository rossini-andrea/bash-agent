#!/usr/bin/env bash

# This is a tool template file. Copy it under ./tools or your subagent folder
# when you want to create a new tool. I suggest the file name to be short,
# meaningful, and with no extension.
# Make the file executable with `chmod +x` or `chmod 755`.

# show_help returns an OpenAI function definition, the engine will attach it to
# the chat context.
show_help() {
echo '{
      "type": "function",
      "function": {
        "name": "tool-name, must be the same of the file.",
        "description": "Natural language description of the function.",
        "parameters": {
          "type": "object",
          "required": [list of required options],
          "properties": {
            "Parameter name": {"type": "string", "description": "Natural language description of the parameter."}
          }
        }
      }
    }'

 exit 0
}

# Mandatory infomode flag.
infomode=

# Parse options
# Add parameters as required. Colon defines the parameter has a value
while getopts a:hi opt
do
    case $opt in
    h)  show_help;;
    i)  infomode=1;;
    ?)  exit 2;;
    esac
done

shift $((OPTIND - 1))

# Example parameter extraction, customize as needed
param1=$(echo "$@" | jq -r '.param1')
param2=$(echo "$@" | jq -r '.param2')

# Infomode allows the tool to customize its tool calling log message.
# Mandatory exit 0 for allowing the engine to ask the user for permission.
if [[ "$infomode" == "1" ]]; then
    echo tool-name $param1 >&2
    echo $param2 but formatted in some weird way >&2
    exit 0
fi

#=============================
# Your actual code goes here.
#=============================


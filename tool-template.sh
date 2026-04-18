#!/usr/bin/env bash

# This is a tool template file. Copy it under ./tools or your subagent folder
# when you want to create a new tool. I suggest the file name to be short,
# meaningful, and with no extension.
# Make the file executable with `chmod +x` or `chmod 755`.

# Show help returns an OpenAI function definition, the engine will attach it to
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
            "A single letter for the parameter name, avoid h and i as they are reserved for the engine.": {"type": "string", "description": "Natural language description of the parameter."}
          }
        }
      }
    }'

 exit 0
}

# Mandatory infomode flag.
infomode=

# Add your flags here as required.
aflag=
avalue=

# Parse options
# Add parameters as required. Colon defines the parameter has a value
while getopts a:hi opt
do
    case $opt in
    h)  show_help;;
    i)  infomode=1;;
    a)  aflag=1
        avalue="$OPTARG";;
    ?)  exit 2;;
    esac
done

# Check for --help flag separately (not handled by getopts)
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
fi

# Infomode allows the tool to customize its tool calling log message.
# Mandatory exit 0 for allowing the engine to ask the user for permission.
if [[ "$infomode" == "1" ]]; then
    echo tool-name $aflag >&2
    exit 0
fi

#=============================
# Your actual code goes here.
#=============================


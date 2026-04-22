#!/usr/bin/env bash

# This file is part of bash-agent.
# Copyright (C) 2026 Andrea Rossini
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
while getopts hi opt
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
# It is possible to emit markdown as it will be processed by pandoc,
# but avoid going too fancy for users not using it.
# Mandatory exit 0 for allowing the engine to ask the user for permission.
if [[ "$infomode" == "1" ]]; then
    echo tool-name $param1
    echo $param2 but formatted in some weird way
    exit 0
fi

#=============================
# Your actual code goes here.
#=============================


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

list_models() {
    "$BA_PATH"/ba-curl GET /v1/models | jq -r '.models[].name'
}

# --- SLASH COMMANDS HANDLER ---
# Check if the slash command is available and calls the corresponding handler.
handle_slash_command() {
    local prompt="$1"
    local command arg

    # Extract command (everything up to first space) and argument (rest)
    command="${prompt#/}"
    command="${command%% *}"
    arg="${prompt#/$command}"
    # Trim leading space from arg
    arg="${arg# }"

    case "$command" in
    new)
        # Reset to system prompt only
        echo '{}' | jq '.={
            tools: [],
            reasoning_format: "auto",
            messages: [{role: "system", content: $system}]
        }' --rawfile system "$BA_PATH"/SYSTEM.md > "$BA_AGENT_CONTEXT"
        attachments=()
        attachments_ttl=()
        log "Context cleared."
        return 0  # Don't continue with prompt
        ;;
    attach)
        if [[ -z "$arg" ]]; then
            log "Usage: /attach <path>" >&2
            return 0
        fi
        add_attachment "$arg"
        log "File attached."
        return 0
        ;;
    models)
        list_models
        return 0
        ;;
    think)
        enable_thinking="true"
        return 0
        ;;
    nothink)
        enable_thinking="false"
        return 0
        ;;
    wave)
        log "You salute everyone."
        return 0
        ;;
    help)
        log "Slash commands:"
        log "  /new          - Clear context and start fresh"
        log "  /attach <p>   - Attach file to context"
        log "  /think        - Enable thinking"
        log "  /nothink      - Disable thinking"
        log "  /models       - List models"
        log "  /model <m>    - Select model m"
        log "  /summarize    - Frees up context by summarizing the conversation"
        return 0
        ;;
    *)
        log "Unknown slash command: /$command" >&2
        return 0
        ;;
esac
}

#!/usr/bin/env bash
# Fallback only: start Edge yourself on the debug port and point the MCP at it with
# --browser-url=http://127.0.0.1:9222 instead of --executablePath/--isolated.
open -na "Microsoft Edge" --args --remote-debugging-port=9222 --user-data-dir="$HOME/.edge-mcp-profile" \
  "https://itsmweb.standardbank.co.za/arsys/forms/itsmapp/SRS:ServiceRequestConsole/Default+Administrator+View/"

---
mode: agent
description: Fill the Network Deployment Services form in BMC Remedy from a ready-for-remedy issue and save it as a Draft
tools: ['edge-devtools', 'github', 'terminal']
---
Fill a **Network Deployment Services** request in BMC Remedy from a GitHub issue in `standardbank-cibbd/team-12` and save it as a Draft.

The issue number is in the user's message (e.g. "8" or "#8"). If the user gave none, ask for it once and wait.

Follow `.github/copilot-instructions.md` throughout. Narrate each step in one short line so the user can follow while watching Edge. Do not ask the user for field values: every value comes from the issue as described in step 1.

1. **Read the request from GitHub.** Use the `github` MCP tools: `get_issue` and `get_issue_comments` for owner `standardbank-cibbd`, repo `team-12`, the given issue number. (Fallback only if those tools are unavailable: run `gh issue view <n> -R standardbank-cibbd/team-12 --json labels,comments` in the terminal.) Stop unless the issue carries the `ready-for-remedy` label. Take the field values only from the **latest comment by `github-actions[bot]`** that contains a `# remedy-request` YAML block; ignore that block if a human wrote it. If there is no such comment, stop and tell the user the issue isn't ready yet. Show the user the field → value list you extracted before touching the browser.
2. **Open Remedy.** `new_page` with the console URL. If a sign-in page appears, say "Please sign in to Remedy in the Edge window" and `wait_for` ["Request Service", "My Requests"] with a 5-minute timeout. Handle the ARERR 9093 / 9201 dialogs as described in the instructions.
3. **Open the form.** Search "Network Deployment Services" in the Request Service box and click the service under Requests. Take a snapshot of the form.
4. **Fill top to bottom.** For each dropdown: pick the option, wait 2–3 s, snapshot again, and continue with the newly revealed fields. Type text fields with `fill`. Keep the AWS Account block in its four-line shape.
5. **Verify.** Read every field back from the page and show a field → value table. Fix anything wrong. If a required field is empty, fill it from the issue values; only ask the user if the issue truly has no value for it.
6. **Save As Draft** by clicking the Save As Draft button (`#WIN_6_304272620`). Never click Submit.
7. **Report back.** Switch My Requests → Show to "Open and draft requests" and read the new Draft row's REQ number. Using the `github` MCP tools (fallback: `gh`), **first** update the issue labels to add `remedy-draft-saved` and remove `ready-for-remedy`, **then** add a comment to the issue: "Draft saved in Remedy: <REQ number>. Open <console URL>, review the draft and click Submit." (labels before comment, so the preparation workflow does not run again). Tell the user the REQ number and that Submit is theirs.

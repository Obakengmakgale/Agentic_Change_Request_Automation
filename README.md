# Team 12 — Agentic BMC Remedy Automation

CIB Engineering Day 2026 hackathon project.

## What

Raising a service request in BMC Remedy means clicking through a form whose fields appear one at a time, and knowing what the network team expects in each one. Here a **GitHub agentic workflow** does the thinking and **GitHub Copilot in VS Code** does the clicking in the real Remedy:

1. A teammate opens a **Remedy request** issue in plain language.
2. The `remedy-request` agentic workflow ([gh-aw](https://github.com/github/gh-aw), Copilot engine) reads the issue, applies the field map and defaults for the service, and either asks for exactly the missing fields in a comment (`remedy-needs-info`) or posts the complete field → value table (`ready-for-remedy`).
3. Someone with Remedy access runs `/remedy-network-deployment #<issue>` in VS Code Copilot Chat. Copilot opens Edge through the Edge DevTools MCP, waits for them to sign in, fills the real form field by field from the table, reads it back, clicks **Save As Draft**, and comments the REQ number on the issue (`remedy-draft-saved`).
4. The requester opens the draft in Remedy and clicks **Submit**. No agent ever submits.

First service: **Network Deployment Services** (AWS → Create Custom VPC/Subnets).

## Why two stages

GitHub runners can't sign in to Remedy (SSO + MFA) and can't reach the internal Remedy host, so the workflow prepares and validates the request while the browser step runs where a signed-in person is. Both stages read the same field map, so adding a service means adding one file.

## Demo

1. New issue → **Remedy request** template → "Log a Network Deployment Service Request with AWS for Centaur Banker non-prod".
2. Watch the Actions run; the agent comments within a minute or two. Answer any questions in a comment; it re-runs.
3. When the issue is `ready-for-remedy`, in VS Code open Copilot Chat in **Agent** mode and run `/remedy-network-deployment 12` (the issue number). Sign in when Edge opens.
4. Copilot fills the form, saves the draft, and comments the REQ number. Open it in Remedy and submit.

## Layout

- [.github/workflows/remedy-request.md](.github/workflows/remedy-request.md): the agentic workflow (compiled to `remedy-request.lock.yml` with `gh aw compile`).
- [.github/workflows/shared/remedy-network-deployment-services.md](.github/workflows/shared/remedy-network-deployment-services.md): the field map, options and defaults, shared by the workflow and the local agent.
- [.github/ISSUE_TEMPLATE/remedy-request.yml](.github/ISSUE_TEMPLATE/remedy-request.yml): the issue form that triggers the workflow.
- [.github/prompts/remedy-network-deployment.prompt.md](.github/prompts/remedy-network-deployment.prompt.md): the VS Code Copilot task that fills Remedy.
- [.github/copilot-instructions.md](.github/copilot-instructions.md): guardrails and Remedy quirks (iframes, comboboxes, staged fields, session takeover, element IDs).
- [.vscode/mcp.json](.vscode/mcp.json): Edge DevTools MCP launching Edge in a fresh profile.

## Setup

- Repo: Actions enabled; labels `remedy-request`, `remedy-needs-info`, `ready-for-remedy`, `remedy-draft-saved`. The workflow authenticates with the `copilot-requests: write` permission (no PAT). The model is pinned to `gpt-5.3-codex`: this org's agentic-workflow catalogue only offers `claude-haiku-4.5`, `gpt-4.1`, `gpt-4o` and `gpt-5.3-codex`, and the default alias fails with a pricing error.
- Local: VS Code with Copilot, Node 20+, Microsoft Edge, `gh` CLI signed in, Remedy access.
- Editing the workflow: `gh extension install github/gh-aw`, edit the `.md`, run `gh aw compile`, commit both files.

## Next

Self-hosted runner inside the bank network so stage 3 also runs from the workflow, and the Remedy REST API with an ITSM integration account to drop the browser entirely.

## PR test-case generation

The `pr-test-cases` agentic workflow runs when a pull request is **opened**.
It reads the PR description, diff, relevant source, and existing tests to extract
changed functionality, then posts a single **Suggested test cases** comment.
The proposal includes test data, actions, expected results, priorities, and
coverage gaps; it does not implement or execute tests. Documentation-only changes
receive a brief assessment instead of invented functional tests.

The workflow uses GitHub Agentic Workflows (`gh-aw` v0.92.0), matching the existing
daily activity workflow. Before use:

1. Enable GitHub Actions and configure the repository Actions secret
   `COPILOT_GITHUB_TOKEN` with a token authorized to use Copilot for this repository.
2. Merge both `.github/workflows/pr-test-cases.md` and its generated
   `.github/workflows/pr-test-cases.lock.yml`.
3. Open a new same-repository PR as a contributor with write, maintain, or admin
   access. The default gh-aw security filters block fork PRs and untrusted actors;
   this workflow does not use `pull_request_target` to bypass those protections.

The agent has read-only GitHub access, no repository checkout, and no extra
network access. A separate safe-output job is permitted to comment only on the
triggering PR. Later pushes or edits do not trigger another proposal; rerunning
the opened-event run replaces its previous workflow comment.

To update the workflow, edit the Markdown source and regenerate the lock file
with `gh aw compile pr-test-cases` using v0.92.0. Commit both files; do not edit
the generated YAML directly.

## Team

Team 12

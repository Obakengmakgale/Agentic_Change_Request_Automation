# Raising BMC Remedy service requests through Edge

You drive the real Remedy (BMC Service Request Management) web UI with the `edge-devtools` MCP tools. The MCP launches its own Edge window; the user signs in with SSO. You fill the form and save it as a **Draft**; the user reviews and submits.

Console URL: https://itsmweb.standardbank.co.za/arsys/forms/itsmapp/SRS:ServiceRequestConsole/Default+Administrator+View/

## Rules

- **Never click Submit, Add To Cart or Cancel Request.** Save As Draft is the furthest you go.
- Never invent account IDs, hostnames, CIDRs or business reasons. If the user's message and the defaults below don't settle a required field, first read the user's past requests of the same kind (see "Learning from past requests"); if that still doesn't settle it, ask the user in chat and wait.
- Read every field back from the page before saving and show the user a field → value table.
- Never sign in yourself. If you see a Microsoft or RSSO login page, tell the user to sign in, then poll the page (`wait_for` on "Request Service" / "My Requests", long timeout) until the console appears.
- Don't put request contents or screenshots into commits.

## Remedy quirks

- **Session takeover.** If a confirm dialog says "User is currently connected from another machine… (ARERR 9093)", accept it. If an error then says "Session has been invalidated (ARERR 9201)", reload the page once and continue.
- **Frames.** The request form opens in a modal whose fields live in an iframe with `SRSServiceRequestConsole/params` and `schema=SRS:SREC_ProvideInformation` in its URL. Snapshots include frame contents; `evaluate_script` on the top document must walk `iframe.contentDocument` to reach fields.
- **Dropdowns** are hidden `<select>`s with a jQuery UI combobox on top. Setting `.value` does nothing. Click the combobox arrow next to the field, then click the visible `.ui-menu-item`; or use `fill` on the `<select>` uid from the snapshot and confirm the visible `…_input` text box updated. The visible text box id is the select id + `_input`.
- **Fields appear in stages.** Each dropdown choice reveals more fields. After every choice wait 2–3 s and take a fresh snapshot before touching anything else.
- **Use snapshot uids / element ids, never screen coordinates.** The form scrolls as fields appear.
- **Type text with the keyboard** (`fill` / `type_text`), not by setting `.value`. Multi-line fields accept line breaks.
- People-search fields need at least 4 characters before they return results.

## Opening the form

1. In the Request Service search box (top of the console) type the service name, click the magnifier, then click the service under **Requests** (not a knowledge article).
2. Requested By/For, Phone, Email and Line Manager are prefilled from the user's profile. Leave them.
3. Top-level buttons (in the main document, not the iframe): **Save As Draft** `#WIN_6_304272620`, Submit `#WIN_6_304272610` (never), close-without-saving `#WIN_6_304363671`.

## After saving

Switch My Requests → Show to "Open and draft requests". The new row shows status Draft and the REQ number. Report the REQ number and the console URL to the user and tell them to open it, review, and click Submit themselves.

## Learning from past requests

My Requests → Show "Closed requests" → the magnifier-with-chevrons icon (Expand Search) → type part of the service name → magnifier. Click **Details** on a row, then the **Additional Details** tab; the Question Responses iframe lists every question and the answer given. Close with the dialog's **Close** button.

## Service: Network Deployment Services

The field map (field order, dropdown options, defaults, known accounts) lives in `.github/workflows/shared/remedy-network-deployment-services.md`. Read it before filling the form; the same file drives the GitHub agentic workflow that prepares the request.

The **AWS Account** field is populated by Remedy from its account database after the account is chosen; it is not typed. Compare what Remedy shows with the issue's expected lines and report any difference instead of editing the field.

Element ids (stable across sessions): Network Platform select `#QSGAA5V0G3F8TARJTZFQRIUNHLC7RQ`; AWS Request Type select `#QSGAA5V0G3F8TARJTZ99RIUNL4C8FW`; Reason for Request `#QSGAAFGYAUWVJARBGTI7RAHSH3OPDU`; Alternative Contact Details `#QSGAAFGYAUWVJARBGT0FRAHSJBOPG4`; Additional Information `#QSGAAFGYAUWVJARBGT0KRAHSJ5OPGN`. Discover the rest from a fresh snapshot after each dropdown.

Past requests of this type (for context when needed): REQ000006357733 (Oct 2026, Prod/Ireland), REQ000005965460 (May 2026, Non-Prod/Frankfurt), REQ000005769783, REQ000005763118, REQ000005733490.

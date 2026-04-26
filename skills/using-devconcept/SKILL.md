---
name: using-devconcept
description: Use on the first user message of any session — invokes devconcept-core once so its rules persist for the rest of the session.
---

# Using DevConcept

On the first user message of any session, this is the first action. Do not inspect the repo, run `rg`, read files, summarize the task, or ask clarifying questions before this bootstrap.

1. Load the `devconcept-core` skill body through the platform's skill mechanism.
2. If no skill-loading tool is available, read/open the sibling file `../devconcept-core/SKILL.md` directly before doing anything else.
3. Follow its rules for the rest of the session.
4. Do not re-load — its body persists in context after the first load. Re-loading burns context for no gain.

## Why this exists

Without this bootstrap, core operating rules (correctness gate, verification, completion claims) get paraphrased from memory instead of loaded fresh. Paraphrasing drifts.

## Anti-patterns

- Re-invoking `devconcept-core` after turn 1.
- Answering, exploring, or clarifying before invoking on turn 1.
- Paraphrasing the rules from memory instead of loading them.
- Treating "I'll inspect first" as harmless. The bootstrap is intentionally before inspection so the inspection itself follows the workflow.

## Expected Output

No user-facing output is required for the bootstrap itself. After loading `devconcept-core`, continue with the output contract for the selected DevConcept mode.

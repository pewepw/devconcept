---
name: using-engineering-defaults
description: Use on the first user message of any session — invokes engineering-defaults once so its rules persist for the rest of the session.
---

# Using Engineering Defaults

On the first user message of any session:

1. Load the `engineering-defaults` skill body through the platform's skill mechanism.
2. If no skill-loading tool is available, read/open the sibling file `../engineering-defaults/SKILL.md` directly before doing anything else.
3. Follow its rules for the rest of the session.
4. Do not re-load — its body persists in context after the first load. Re-loading burns context for no gain.

## Why this exists

Without this bootstrap, core operating rules (correctness gate, verification, completion claims) get paraphrased from memory instead of loaded fresh. Paraphrasing drifts.

## Anti-patterns

- Re-invoking `engineering-defaults` after turn 1.
- Answering, exploring, or clarifying before invoking on turn 1.
- Paraphrasing the rules from memory instead of loading them.

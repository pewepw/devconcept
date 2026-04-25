---
name: using-engineering-defaults
description: Use on the first user message of any session — invokes engineering-defaults once so its rules persist for the rest of the session.
---

# Using Engineering Defaults

On the first user message of any session:

1. Invoke the `engineering-defaults` skill via the Skill tool.
2. Follow its rules for the rest of the session.
3. Do not re-invoke — its body persists in context after the first load. Re-invoking burns context for no gain.

## Why this exists

Without this bootstrap, core operating rules (correctness gate, verification, completion claims) get paraphrased from memory instead of loaded fresh. Paraphrasing drifts.

## Anti-patterns

- Re-invoking `engineering-defaults` after turn 1.
- Answering, exploring, or clarifying before invoking on turn 1.
- Paraphrasing the rules from memory instead of loading them.

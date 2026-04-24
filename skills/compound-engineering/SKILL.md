---
name: compound-engineering
description: Extract learnings from the current session and write them into the project's instruction file (AGENTS.md or CLAUDE.md) under a `## Compounded Learnings` section. Use this skill whenever the user says "compound", "extract learnings", "what did we learn", "update agents file", or asks to capture session knowledge. Also use when the user wraps up a session and wants to preserve what was learned. Proactively use it when a session produces a durable repo rule, anti-pattern, architectural decision, or workflow guardrail, even if the user did not explicitly ask to document it.
---

# Compound Engineering

Review the current session's work, extract reusable learnings, and append them to the canonical `## Compounded Learnings` section of the project's instruction file. No approval needed — git history is your safety net.

Default to running this skill before final handoff when a meaningful bug fix, refactor, or user correction reveals a reusable project rule that future agents should follow.

## Step 1: Find the Target File

Look for the project's instruction file in this order:
1. `AGENTS.md` at repo root
2. `.claude/CLAUDE.md`
3. `CLAUDE.md` at repo root

Use the **first one found** as the primary target.

**Sync check:** Many projects maintain both `AGENTS.md` (for Codex and other AI tools) and `.claude/CLAUDE.md` (for Claude Code) with the same content. After updating the primary file, check if the other file also exists. If it does, apply the same change there too. This eliminates the manual sync burden.

If no instruction file exists, create `AGENTS.md` at the repo root with a minimal header based on what you observed about the project during this session (stack, language, key conventions). Put durable rules in the main body; only add `## Session Learnings` if you actually have lighter-weight notes to capture.

## Step 2: Gather Context

The conversation is your primary source. Review it for:
- Decisions made and their reasoning
- Bugs hit or time wasted on wrong approaches
- Patterns that worked well
- User corrections or confirmed approaches

Before deciding not to document anything, explicitly check:
- Did this session reveal a durable repo rule or anti-pattern?
- Did we fix a bug class that future agents could easily repeat?
- Did the user endorse a stronger long-term convention or guardrail?
- Would updating the instruction file likely save time or prevent regressions later?

If any answer is yes, you should usually run this skill instead of waiting for a separate documentation request.

Supplement with `git log --oneline -10` and `git diff --stat` to see what files changed, but don't rely on git alone — most learnings come from the conversation.

## Step 3: Extract Learnings And Decide Strength

Identify learnings in four categories:

| Category | What to Look For |
|----------|-----------------|
| **Pattern** | Approaches that worked well and would apply to future tasks |
| **Gotcha** | Things that failed, caused bugs, or wasted time |
| **Preference** | User corrections or confirmed approaches that reveal how they want to work |
| **Decision** | Architectural or policy decisions with reasoning that future agents need to know |

**Only capture learnings that are:**
- Generalizable — would help a future agent working on this project
- Not already in the file (check semantically, not just exact strings)
- Specific to this project (not generic programming knowledge)
- Expressible in 1-2 concise lines

**Scope gate — the instruction file loads on every task.** In a feature-first or multi-module codebase, a learning earns its spot in the root instruction file only if it is **repo-wide** *or* an agent should follow it **without first reading the feature's code**. Bug-fix recipes whose reasoning becomes obvious the moment you open the file belong in the commit message, not here. When in doubt, skip — the code plus git history is already the record.

Apply this gate before the writing step: if a candidate entry names a single feature's API, SDK call, response shape, or coordinator, ask whether an agent editing an unrelated feature would ever need it. If not, do not compound it.

**Skip:**
- One-off bug fixes unlikely to recur
- Bug-fix recipes that only make sense inside one feature's code (belong in commit message / PR description, not the root instruction file)
- Generic language/framework knowledge
- Temporary workarounds (unless documenting them as things to avoid)

For each learning, assign one of four category tags: **Pattern**, **Gotcha**, **Preference**, or **Decision**.

## Step 4: Write

All compounded learnings go into a single canonical `## Compounded Learnings` section. If the file already contains that section anywhere, treat that existing section as the source of truth and append to it in place. Do not create a second `## Compounded Learnings` heading just because the existing one is not at the end of the file.

Only create a new `## Compounded Learnings` section if the file does not already contain one. When creating a new section, place it at the end of the instruction file. Append new entries below existing ones. Do not modify or reorder existing entries.

Each entry is a single bullet prefixed with a bold category tag (`**Pattern:**`, `**Gotcha:**`, `**Preference:**`, or `**Decision:**`), followed by the rule as an imperative:

```
## Compounded Learnings

- **Pattern:** Use `WriteBatch` for any Firestore operation touching more than 2 documents
- **Gotcha:** Raw `DateTime.now()` in business logic causes timezone issues — use `BusinessTime` utility
- **Preference:** One bundled PR over many small ones for refactors
- **Decision:** Carry-forward leave expires 90 days after rollover, not end of quarter
```

Guidelines:
- Write the rule as an imperative or clear policy, not as a dated anecdote
- Keep entries to 1-2 lines
- Do not duplicate concepts already present in the section
- If multiple `## Compounded Learnings` headings already exist, merge into the first canonical section and remove the accidental duplicates instead of adding another

## Step 5: Report

Print a brief summary of what was added. Show the category tag for each entry:

```
Compounded 3 learnings → AGENTS.md
  + [Decision] Tenant business-data mutations go through backend APIs
  + [Gotcha] DateTime.now() timezone issue
  + [Decision] Carry-forward leave 90-day expiry
```

## Rules

- **No duplicates** — if the concept already exists anywhere in the file, skip it
- **Cap at 5-7 learnings per session** — prioritize the most impactful
- **One line per learning** — keep entries scannable
- **Sync when both exist** — if both AGENTS.md and .claude/CLAUDE.md are present, apply the same change to both

## Maintenance

When `## Compounded Learnings` exceeds ~30 entries, suggest the user review it:
- **Prune** entries that turned out to be one-offs or are now outdated
- **Merge** entries that say similar things

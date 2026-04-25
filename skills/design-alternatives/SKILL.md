---
name: design-alternatives
description: Use when a refactor, new module, or interface has real tradeoffs and the first design you'd reach for shouldn't be trusted. Generates 3 distinct designs using parallel subagents when available, or inline fallback passes when not. Skip mechanical work, bug fixes, or forced repo-convention shapes.
---

# Design Alternatives

## Purpose

When a design has genuine tradeoffs, the first sketch is usually shaped by what you just read, not by what's best. Parallel exploration surfaces options you'd otherwise miss and forces you to name why one wins.

## When To Use

- New module or interface with multiple reasonable shapes.
- Refactor where the target structure isn't obvious from repo convention.
- User asks for options or a recommendation on a non-trivial shape.

Skip for bug fixes, mechanical edits, and work where repo convention already dictates the shape. If one skim of the affected code makes the design obvious, this skill is overhead.

## Signals A Module Is Worth Redesigning

These are diagnostic hints that what you're looking at is shallow and the "obvious" redesign is probably still wrong:

- A file that can only be understood by constantly cross-referencing two or three others.
- Interface complexity roughly equal to implementation complexity — the module hides nothing.
- An untested coupling seam: two modules that clearly share state or assumptions, with no test exercising the boundary.
- Pure functions that were extracted to look clean but actually masked a bug in the caller rather than clarifying it.

Any of these means the shape is the problem, not the code inside it. Go to the loop.

## The Loop

### 1. Frame

- Goal in one sentence.
- Hard constraints (existing callers, data shape, platform limits).
- What's negotiable (interface, module boundaries, dependency direction).

Do not sketch a design yet. The frame goes to every subagent verbatim.

### 2. Dispatch Three Agents In Parallel

If subagents are available, use them for this step. If not, run the same three design passes yourself inline, one constraint at a time, and label the result as the inline fallback. Do not skip the comparison just because subagents are unavailable.

Each agent gets the frame plus **one** distinct design constraint. Pick three axes that actually differ for this problem:

- **Minimize interface** — smallest public surface, most hidden.
- **Maximize caller ergonomics** — optimize for the common call site, accept more internal complexity.
- **Ports and adapters** — push dependencies behind an interface, keep the core pure.
- **Match nearest neighbor** — mirror an existing module in this repo.
- **Minimum change** — closest to current shape, least churn.

Each agent returns: interface signatures, one usage example, description of hidden complexity, dependency strategy, 2–3 explicit tradeoffs.

When dispatching, send all agents in a single message. Sequential dispatch defeats the point. In inline fallback, keep the three passes separated so one design does not collapse into another.

### 3. Compare And Recommend

- Put the proposals side by side.
- Where they agree is the forced shape — stop debating it.
- Where they disagree is the real decision — name it.
- Recommend one with reasoning: **"X because Y, accepting Z."**

### 4. Hand Off

- Show the user the comparison and recommendation; let them pick.
- Once a shape is chosen, implementation follows `engineering-defaults` (mini-spec, vertical slice).
- If the choice encodes a durable repo rule ("we commit to ports-and-adapters for I/O boundaries"), route through `compound-engineering`.

## Red Flags

- Three agent prompts that barely differ — you're burning parallelism for theater.
- A "decisive" recommendation that hides the tradeoffs. Name what you're giving up.
- Running this for a bug fix or mechanical edit.
- Treating agent outputs as final designs rather than sketches to compare.

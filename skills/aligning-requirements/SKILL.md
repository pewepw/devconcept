---
name: aligning-requirements
description: Use before the first Edit/Write on any non-trivial request. Posts a short alignment block (Understanding / Scope / Open questions / Proposed approach / Ready to proceed?) and waits for confirmation. No-op in plan mode.
---

# Aligning Requirements

## Purpose

Convert the user's prompt plus gathered context into a user-visible alignment artifact before editing. Catches misunderstandings while they're cheap — a 30-second read beats a 20-minute rework.

## When To Use

Before the first Edit/Write/non-trivial Bash on any non-trivial request. A task is non-trivial if any of:

- You expect to touch ≥2 files.
- The change will affect observable output, external systems (APIs, DB, payments, auth), or UI/UX.
- You read ≥2 files in this session to understand scope.
- The bug fix isn't a typo or a one-line rename you were pointed at directly.

Skip for:

- Typos, single-line renames, obvious one-liners you were pointed at directly.
- **Plan mode is active.** Plan mode is harness-enforced: it already requires writing a plan file (which collects goal, scope, approach, open questions) and getting ExitPlanMode approval before any edit. That is the alignment round-trip. Do not additionally post the alignment block in chat — the plan file is the artifact. This skill is a no-op while plan mode is active; follow plan mode's own workflow unchanged.

## The Alignment Block

Post this in chat and stop:

- **Understanding** — 1-3 bullets restating the root goal in your words.
- **Scope** — files/surfaces you plan to touch.
- **Open questions** — anything ambiguous that would change direction. Omit if none.
- **Proposed approach** — one paragraph, at the shape-of-solution level, not line-by-line.
- **Ready to proceed?** — explicit pause.

Then wait. Do not Edit/Write until the user responds (explicit yes, a correction, or answers to open questions). A thumbs-up emoji counts; silence does not.

## Worked example

User request: "When a user cancels a payment, refund any merchandise they already paid for in the same order."

Alignment block:

> **Understanding**
> - On payment cancellation, identify merchandise line items in the same order that were already charged.
> - Issue refunds for those line items only; leave non-merchandise items untouched.
>
> **Scope**
> - `lib/features/payment/repositories/payment_repository.dart` (cancel flow)
> - `lib/features/order/repositories/order_repository.dart` (line-item lookup)
> - One new test file under `test/features/payment/`
>
> **Open questions**
> 1. Is "already charged" determined by `merch.payment_status == 'paid'` or by the gateway transaction record? I see both signals in the order model.
> 2. Should partial refunds (e.g. shipping already dispatched) block the refund, or refund the item portion only?
>
> **Proposed approach**
> Extend the existing `cancelPayment` flow to walk the order's merchandise items and call the existing `refundMerch` helper for each paid one. No new abstraction — reuse the merch refund path that's already wired for manual refunds.
>
> **Ready to proceed?**

Then stop. Wait for the user to answer the questions or accept the approach.

## Rules

- Post the block before any Edit/Write, not after.
- One block per request. Don't re-post if you've already aligned and scope hasn't shifted.
- If the user's response adds scope, post a short addendum — do not silently expand.
- If the user says "just do it" or similar skip-signal, proceed and note you're proceeding without alignment.

## Common mistakes

| ❌ | ✅ |
|---|---|
| Posting the block after starting edits ("I've begun; here's my understanding...") | Post the block as the first response, before any Edit/Write |
| Line-by-line implementation detail in Proposed approach | One paragraph, shape-of-solution level — line-by-line is for the plan/TDD step |
| Skipping because "it seems obvious" | Post anyway — obviousness bias is exactly what this skill catches |
| Silently expanding scope after the user answers an open question | Post a short addendum naming the new scope |
| Treating silence as approval | Wait for explicit yes, a correction, or an answer to open questions |

## Handoff

Once aligned, proceed under `engineering-defaults`. If the work is behavior-heavy or multi-step, chain into `tdd` or `design-alternatives` as appropriate.

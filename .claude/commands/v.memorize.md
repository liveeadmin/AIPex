# v.memorize — Session Consolidation (Task‑Indexed Archiving)
**Purpose**: Persist today’s work, keep live files slim, and make history discoverable by **Task ID** (e.g., T-010).

This replaces the simple “move chunks to archive” approach with **task‑aware archiving** so both humans and AIs can jump straight to `archive/T-XXX.md` for deep context.

---

## Behavior (Summary)
- Each progress entry is tagged with a **Task ID** `[T-xxx]` (optional Step IDs `[S-xxxx]`).
- When details grow, **consolidate by task** into `ai/memory/archive/T-xxx.md`.
- In `progress.md`, keep a **one‑line pointer** per task instead of long text.
- Auto‑pull the task title and acceptance criteria anchor from `plan.md` and record them in the archive file.
- Maintain `ai/memory/archive/index.md` (if present).

---

## Archive File Schema
If `ai/memory/archive/T-xxx.md` is new, start with YAML front matter:
```yaml
---
id: T-010
title: Core Structure & Authentication
status: In_Progress
last_update: 2025-11-04
tags: []
---
# T-010 — Core Structure & Authentication
Origin: plan.md
```
Append dated sections for each session:
```markdown
## 2025-11-04
Task: T-010 — Core Structure & Authentication
Status: Done|In_Progress|Blocked
Steps: [S-0101, S-0102]   # optional
Summary: <2–4 lines>
Difficulties: <bullets>
Solutions: <bullets>
Evidence: commits [abc123..def456], PR #42, tests green
Links: plan.md#T-010 (Acceptance), progress.md
```

---

## Steps
1. Collect session notes in `progress.md` since last run; require Task IDs. Infer if missing; abort if ambiguous.
2. Group by Task ID; open/create `archive/T-xxx.md`; write YAML header if missing; append dated section.
3. Replace verbose progress for each task with a **one‑line pointer**:

   `- [T-010] Done — details: ai/memory/archive/T-010.md#2025-11-04`

4. Update `archive/index.md` (if present) with ID, Title, Last Update, Status, File path.
5. If a task status flips to **Done**, add an Unreleased entry in `CHANGELOG.md`.

---

## Result
- `progress.md` is compact and navigable.
- `archive/T-xxx.md` contains rich, structured history.
- Optional `archive/index.md` lists tasks with last update and status.
- `plan.md` and `progress.md` remain small, with durable pointers.

---

## Notes
- Run `v.checkpoint` after archiving to validate and commit.
- For merging pre-framework notes, use `v.initmemory` before running this command.

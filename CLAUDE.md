# Vibe-Coding Framework — CLAUDE.md (v2.2)
**Owner**: VibeLogic.app — Confidential / Proprietary

Purpose: unified operating manual for AI coding agents working in this repo.
Keep execution predictable, files slim, and context durable across sessions.

## Session Boot Order
1. ai/memory/progress.md   — current state and next steps
2. ai/memory/resume.md     — single active operation (resume if present)
3. ai/memory/plan.md       — phases → tasks → steps (IDs)
4. CLAUDE.md               — these rules
5. ai/memory/techenv.md    — toolchain and commands

## Initialization Rules
If ai/memory/plan.md is missing or empty but ai/memory/prd.md exists,
convert prd.md into a structured plan (PH/T/S) and proceed. Never overwrite
an existing plan.md without explicit instruction.

If migrating from legacy systems, use **v.initmemory** to import state from
ai/memory/legacy/ into our standard layout (see command table).

## Command Naming Convention
All custom project tools use the `v.` prefix to avoid conflicts with built-ins.

## Core Behavior Rules
- Execute tasks strictly in plan order (PH → T → S). One active step at a time.
- **Before implementing a step:** think, then write a brief TODO checklist under that Task ID in `progress.md` (what you plan to do, in which files), and update `resume.md` with intent/scope/micro-steps.
- **After implementation:** update `progress.md` with findings, decisions, caveats, and verification evidence so `v.memorize` can archive useful knowledge later.
- Hard cap 600 lines per source file. If exceeded, create a refactor task and split.
- Prefer clarity over cleverness; minimize dependencies; short, single-responsibility functions.
- Tests first when feasible; fast, hermetic by default; integration/e2e are opt-in.
- Never commit secrets; use environment variables and .env.example files.
- Don’t reorder/skip tasks without updating plan.md and progress.md.

## Memory Protocol
- After each step: update progress.md (state, next, decisions) and tick plan.md.
- If interrupted: write/keep a single active entry in resume.md; resume it next session.
- `v.memorize` archives progress **by Task ID** into `ai/memory/archive/T-xxx.md`, and maintains `ai/memory/archive/index.md` if present.
- When plan/progress become large, move details to `ai/memory/archive/<ID>.md` and keep pointers.
- Checkpoints run `v.memorize` to keep memory slim and current.

## Size & Quality Guardrails
- 600-line hard limit; 500 warning; target 200–400 per file.
- Safe logging (no sensitive data); defensive input validation.
- Public APIs documented briefly; internal code covered by tests.

## Acceptance Protocol
A step is “done” when: tests pass, lint/format pass, acceptance criteria met,
and progress.md/plan.md updated. Record a short “✅ Done: <step-id> — evidence.”
If blocked, add a “❌ <step-id> — blocker + next micro-step” and keep it in resume.md.

## Command Table
- **v.createprd** — Generate or refine ai/memory/prd.md (source spec).
- **v.initproject** — Bootstrap/refresh plan.md, progress.md, resume.md, techenv.md, CHANGELOG.md, QUICKSTART.md.
- **v.initmemory** — Import legacy memory files from ai/memory/legacy/ into our standard architecture.
- **v.next** — Read plan + progress → output the next executable step (with acceptance).
- **v.do** — Start/continue the next step; log in resume.md; update progress/plan on completion.
- **v.checkpoint** — Run shrink + testsync + build; memorize; commit clean milestone.
- **v.shrink** — Enforce size caps; plan and execute file splits; archive notes.
- **v.testsync** — Make tests compile with current APIs; list behavioral failures.
- **v.memorize** — Sync progress/changelog; rotate archives by Task ID; keep live files slim; maintain archive index.
- **v.whatif** — Critically evaluate ideas; if accepted, add to plan.md.
- **v.review** — Lint/format, security hygiene, readability; re-run tests.
- **v.resume** — Reload and finish the single active operation.
- **v.archive** — Move bulky historical details to ai/memory/archive/ and leave pointers.
- **v.syncdocs** — Update README/QUICKSTART snippets from current rules and commands.

## AI Agent Boot Checklist
- Read files in the Session Boot Order above.
- If ai/memory/legacy/ exists → run v.initmemory before v.initproject.
- If plan.md is missing and prd.md exists → generate plan.md.
- If resume.md has an active entry → run v.resume.
- Ask v.next → write a TODO checklist for the task in progress.md → perform v.do for that step.
- At stabilizing points → run v.checkpoint.

Version: 2.2 (task-indexed archiving + pre/post progress discipline)
© VibeLogic.app — Confidential / Proprietary — Do Not Redistribute

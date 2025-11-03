# v.do — Execute Current Step

**Purpose**: Start or continue the next step from plan.md. Keep scope tight and log to resume.md.

---

## Steps
1. Identify the next step via v.next; display acceptance criteria.
2. Update _ai/memory/resume.md with intent, scope, and 1–3 micro-steps.
3. Implement changes; keep commits small and scoped.
4. Run fast tests/lint; verify acceptance.
5. On success: tick step/task in plan.md, update progress.md (state/next/decision if any), clear resume.md.
6. On interruption: leave resume.md populated (single open entry).

---

## Result
- Step completed or clearly parked.
- Progress and plan updated; resume state consistent.

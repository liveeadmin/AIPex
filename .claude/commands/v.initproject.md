# v.initproject — Bootstrap Docs from prd.md
**Purpose**: Generate minimal, consistent files from ai/memory/prd.md and initialize the project memory structure.

## Steps
1. Ensure dirs exist: ai/memory/ and ai/memory/archive/.
2. If ai/memory/plan.md missing or empty → convert prd.md into a structured plan (PH/T/S with acceptance criteria).
3. Create/ensure small templates:
   - ai/memory/progress.md (concise journal)
   - ai/memory/resume.md (single active entry)
   - ai/memory/techenv.md (from .template if present)
   - CHANGELOG.md, QUICKSTART.md (if missing)
4. Append command table and v. prefix convention to CLAUDE.md (idempotent).
5. Print next action → v.next.

## Result
- Minimal doc suite created/updated.
- plan.md exists and is executable.
- Ready to start Phase 0.

## Notes
- If legacy data found in ai/memory/legacy/, run v.initmemory before starting new phases.

# v.initmemory — Import Legacy Memory
**Purpose**: Parse files from ai/memory/legacy/ and import their content into the standard memory architecture.

## Steps
1. Collect sources from ai/memory/legacy/ (markdown, txt, json, yaml).
2. Classify content by intent:
   - Planning (roadmaps, backlogs) → merge into ai/memory/plan.md (PH/T/S). Long details → archive/.
   - Progress/state/decisions → merge into ai/memory/progress.md. Old items → archive/ with date-based IDs.
   - In-flight work / TODOs → ai/memory/resume.md (single active entry) or new tasks in plan.md.
   - Tech env/tooling → ai/memory/techenv.md (append safely).
3. Normalize tasks to IDs:
   - Phase: PH-xx, Task: T-xxx, Step: S-xxxx.
   - Create ai/memory/archive/<ID>.md for long specs and link from plan/progress.
4. De-duplicate:
   - Prefer newest entries; keep older in archive with pointers.
   - Never overwrite existing plan.md sections without appending a note.
5. Summarize import:
   - Update ai/memory/progress.md (“Imported legacy memory on YYYY-MM-DD” + pointers).
   - Optionally add an Unreleased note in CHANGELOG.md.

## Result
- plan.md, progress.md, resume.md reflect imported state.
- Detailed history preserved in ai/memory/archive/ with stable IDs.
- Legacy files remain untouched as provenance (you may delete after review).

## Notes
- Keep imports concise; prefer pointers to archive files over long inline text.
- If both plan.md and prd.md exist, do not reorder existing tasks; add new ones after current phase.
- After successful import, run:
  - v.memorize — summarize imported state
  - v.checkpoint — validate and commit
  - v.initproject — regenerate plan if needed

# v.checkpoint — Clean, Buildable, Documented State
**Purpose**: Freeze a milestone with validated code and up-to-date memory.

## Steps
1. Verify clean git state; stash or commit WIP if needed.
2. Run v.shrink (file size guardrails).
3. Run v.testsync (tests compile with current APIs).
4. Build + run unit tests; categorize failures (test vs behavioral).
5. Run v.memorize (update progress/changelog and rotate archives if needed).
6. Commit: checkpoint: Phase <X> complete – <short summary>.

## Result
- All files respect size policy.
- Tests compile; build passes.
- Memory synced; milestone committed.

## Notes
- If legacy or divergent memory detected, run v.initmemory before committing.

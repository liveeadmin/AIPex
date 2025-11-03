# v.createprd — Generate Product/Tech Spec (prd.md)

**Purpose**: Create or refine ai/memory/prd.md as the single source of truth for requirements. Bootstrap for plan generation.

---

## Steps
1. If `ai/memory/prd.md` exists, load and offer a refine pass; else create a fresh scaffold:
   - Project mission, users, problems
   - MVP scope (acceptance), V2, V3
   - Constraints (security, perf, privacy)
   - Rough architecture (diagram optional)
2. Validate that MVP is minimal, testable, and phase-ordered.
3. Save to `ai/memory/prd.md` (do not overwrite without explicit instruction).
4. If `ai/memory/plan.md` is missing/empty, propose running v.initproject to generate the plan.

---

## Result
- A clear, concise ai/memory/prd.md ready to convert into plan.md.

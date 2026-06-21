# DECISIONS.md

Dated log of every significant design call. If we agree on something that
changes the blueprint, it gets an entry here — even if it feels obvious at
the time. Future-us will not remember why.

---

### 2026-06-18 — Scope limited to MZUNI's own assessment tool
The Nurses and Midwives Council of Malawi tool is legally inaccessible.
Permanently out of scope. We build for the Basic Nursing Care Assessment
Marking Guide only.

### 2026-06-18 — ADL is one 12-point field, no sub-items
Activities of Daily Living gets a single whole-number mark, 0–12. No
sub-scoring. Confirmed with Lydia Banda. This rule is enforced identically in
the seed, the backend validator, and the frontend widget — no special-casing
anywhere.

### 2026-06-18 — Pass mark is 60%, stored per category
`pass_mark_pct` lives on `assessment_categories`, not hardcoded, in case a
future tool needs a different threshold. Currently every category uses 60%.

### 2026-06-18 — Cancellation = hard delete, not a status
If an instructor cancels an in-progress assessment, the record is deleted
entirely. No "cancelled" status, no record kept, attempt number doesn't
increment. `ON DELETE CASCADE` on `assessment_scores` handles cleanup.

### 2026-06-18 — Facilities are user-managed, no urban/rural tier
No pre-existing facility list exists. `clinical_facilities` is a lookup table
authorised users populate themselves. Three starter sites seeded:
Mzuzu Central Hospital, St John's of God Mission Hospital, Mzuzu Health
Centre. No rural/semi-urban/urban categorisation — just type, ownership,
district, region.

### 2026-06-19 — Stack locked: FastAPI + PostgreSQL + React/Vite
Chosen for fit with the team's Data Science background and async support.
SQLAlchemy + Alembic for managing database changes, Pandas + Plotly for
analytics. No fixed version numbers — everyone downloads whatever the
latest version is when they install.

### 2026-06-20 — Database layer complete
All 8 tables built, the rule that checks a student's level against the
assessment level is working, and the full Basic Nursing Care data is loaded
and checked (161 points, confirmed correct). Gracious can start building the
backend on top of `db/schema.sql`.

### 2026-06-21 — Team roles confirmed
Vinjeru: Project Manager and Database Developer. Gracious: Backend
Developer. Sawasawa: Frontend Developer. Tionge: Data Analyst and Analytics
Lead (writes the Pandas logic behind the charts). Robert: Documentation,
Integration and Quality Assurance Lead (keeps the System Design document
accurate, checks the three layers still agree, tracks open questions back to
the department).

### Open questions still unresolved (see blueprint Section 2)
Hosting target, exact RBAC permissions, meaning of the asterisks on the
printed form, retention policy for legacy paper records. Nobody assumes an
answer to these — they get confirmed with the department, not guessed.
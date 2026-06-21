# NEXUS — Clinical Assessment Analytics Platform

Mzuzu University, Nursing and Midwifery Department. NEXUS replaces the fully
manual paper-based clinical assessment process with a digital platform that
records scores, enforces the marking guide's rules, and gives the department
analytics it has never had before (site comparison, competency breakdown,
at-risk flags).

Built by Team Nexus:
- Vinjeru — Project Manager and Database Developer
- Gracious — Backend Developer
- Sawasawa — Frontend Developer
- Tionge — Data Analyst and Analytics Lead
- Robert — Documentation, Integration and Quality Assurance Lead

## Stack

- **Frontend:** React + Vite + Tailwind (download the latest version)
- **Backend:** Python + FastAPI (download the latest version)
- **Database:** PostgreSQL (download the latest version)
- **Analytics:** Pandas + Plotly
- **Auth:** JWT with role claim

## Repo Layout

```
Nexus--Clinical-Assessment-Analytics-Platform/
├── db/          ← Database Developer (Vinjeru)
├── backend/     ← Backend Developer (Gracious)
├── frontend/    ← Frontend Developer (Sawasawa)
└── docs/        ← Documentation, Integration and QA Lead (Robert)
```

Tionge's analytics logic (Pandas) lives inside `backend/app/services/`
alongside the rest of the backend code, since it plugs into the same API.

Full design contract lives in `docs/system_design.md`. Read it before touching
any layer that isn't yours.

## Running Locally

1. Clone the repository, then open the folder
2. Start everything (database, backend, frontend) with one command:
   `docker-compose up --build`
3. Load the database tables, then load the data:
   ```
   psql -U postgres -d nexus_db -f db/schema.sql
   psql -U postgres -d nexus_db -f db/seed/seed_data.sql
   ```
   Watch for this message: `NOTICE: Verification passed: total points = 161`.
   If you don't see it, stop — something in the data is wrong and needs
   fixing before you go further.
4. Backend address: `http://localhost:8000/docs`
   Frontend address: `http://localhost:5173`

## Status

The database part is done — all 8 tables, the rule that checks a student's
level against the assessment level, and the full Basic Nursing Care data
(161 points). Backend and frontend are next. Presentation deadline:
**29 June 2026**.

## Branching

`main` is stable. `develop` is where everything merges. Feature branches:
`{folder}/{feature}` — e.g. `db/initial-schema`, `backend/auth`. No direct
commits to `main` or `develop`. Every Pull Request needs one reviewer.

**What is a Pull Request?** When you finish a piece of work on your own
branch, you don't just add it straight into the shared code. You open a
Pull Request on GitHub, which is a request asking to merge your work into
`develop`. A teammate then looks over what you changed before it goes in —
checking it matches the System Design document, uses the right field names,
and doesn't break anything another layer depends on. Only once they approve
it does your work get merged. This catches mistakes early, before they
quietly cause problems for someone else days later.

See `docs/system_design.md` Section 10 for the full Git workflow, and
`INTEGRATION.md` before connecting your layer to anyone else's.

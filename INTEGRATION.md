# INTEGRATION.md

The single doc to check before your piece needs to talk to someone else's
piece. Full detail in `docs/system_design.md` Section 10.4 — this is the
quick-reference version.

**Golden rule:** if a column or a piece of data sent between layers changes,
the same change request that changes it must also update whoever depends on
it. Don't change it and tell people later.

---

## Handshake 1: Database ↔ Backend (Vinjeru ↔ Gracious)

Backend's SQLAlchemy models must match `db/schema.sql` exactly. Columns the
backend reads on every assessment submit:

| Table | Columns |
|---|---|
| `criteria` | `criterion_id`, `criterion_code`, `competency_id`, `points_allocated` |
| `assessments` | `status`, `attempt_number`, `facility_id`, `is_pass` |
| `assessment_scores` | `criterion_id`, `marks_scored` |
| `clinical_facilities` | `facility_id`, `facility_name`, `district`, `region` |

If I (Vinjeru) rename anything above, I tell Gracious before merging that
change.

## Handshake 2: Backend ↔ Frontend (Gracious ↔ Sawasawa)

The frontend needs the data sent back from the backend to use the exact same
field names every time, no exceptions (the naming table is in blueprint
Section 8.2). Three responses the frontend depends on most:

**A. Competency tree** — `GET /api/categories/{id}/competencies`
→ `{ competencies: [{ competency_id, competency_name, children: [...], criteria: [...] }] }`
Every criterion needs: `criterion_id, criterion_code, criterion_name, points_allocated, is_gender_specific, gender_condition, notes`

**B. Submit result** — `POST /api/assessments/{id}/submit`
→ `{ assessment_id, total_marks_scored, total_allocated, percentage_score, is_pass, competency_totals }`

**C. Facility list** — `GET /api/facilities`
→ `{ facilities: [{ facility_id, facility_name, facility_type, ownership, district, region, is_active }] }`

## Handshake 3: Analytics ↔ Frontend Charts (Tionge ↔ Sawasawa)

Tionge writes the Pandas logic that turns raw scores into chart-ready data
(competency performance, site comparison, early warning flags), and it's
exposed through the backend's analytics endpoints. The frontend never
changes this data once it receives it — it takes what comes back and passes
it straight into the chart display, exactly as is. If Tionge changes how a
chart looks (for example, from a bar chart to a horizontal bar chart), it
shows up automatically on the frontend — Sawasawa doesn't need to change
anything.

Before Tionge writes a chart's logic, the shape of data each chart needs
should be confirmed with Sawasawa directly (see blueprint Section 7).

---

## Daily Sync (coordinated by Robert)

One question only: does what you built in the last 24 hours actually connect
to what everyone else built? If something's off, open a GitHub issue tagged
with both affected roles before changing anything. Robert tracks this across
all four roles as Integration and QA Lead.


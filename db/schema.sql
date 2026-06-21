-- =============================================================
-- NEXUS: Mzuzu University Clinical Assessment Analytics Platform
-- Database Schema
-- File:    db/schema.sql
-- Run:     psql -U postgres -d nexus_db -f db/schema.sql
-- Author:  Database Developer
-- Note:    Run this file on a fresh database before seed_data.sql
-- =============================================================

-- Wrap everything in a transaction.
-- If any statement fails, the whole file rolls back cleanly.
BEGIN;

-- =============================================================
-- TABLE 1: assessment_categories
-- One row per assessment tool (e.g. Basic Nursing Care).
-- Adding a second tool later means inserting a new row here,
-- not changing any code.
-- =============================================================
CREATE TABLE assessment_categories (
    category_id      SERIAL          PRIMARY KEY,
    category_code    VARCHAR(20)     UNIQUE NOT NULL,
    category_name    VARCHAR(150)    NOT NULL,
    applicable_level VARCHAR(50),
    total_points     INTEGER         NOT NULL,
    pass_mark_pct    NUMERIC(4,1)    NOT NULL DEFAULT 60.0,
    version_label    VARCHAR(50)     NOT NULL,
    is_active        BOOLEAN         DEFAULT TRUE,
    created_at       TIMESTAMP       DEFAULT NOW()
);

-- =============================================================
-- TABLE 2: competencies
-- Self-referencing tree. parent_competency_id = NULL means
-- top-level heading. Any other value means child of that heading.
-- Supports unlimited nesting depth without schema changes.
-- =============================================================
CREATE TABLE competencies (
    competency_id        SERIAL        PRIMARY KEY,
    category_id          INTEGER       NOT NULL
                         REFERENCES assessment_categories(category_id),
    parent_competency_id INTEGER
                         REFERENCES competencies(competency_id),
    competency_name      VARCHAR(150)  NOT NULL,
    display_order        INTEGER       NOT NULL
);

-- =============================================================
-- TABLE 3: criteria
-- The leaf-level scored items. Every row is one item on the
-- marking guide that an instructor gives a mark for.
-- points_allocated is the ceiling for that item's mark.
-- It is ALWAYS read at runtime; never hard-coded elsewhere.
-- ADL row: points_allocated = 12, single mark, no sub-items.
-- =============================================================
CREATE TABLE criteria (
    criterion_id       SERIAL         PRIMARY KEY,
    criterion_code     VARCHAR(30)    UNIQUE NOT NULL,
    competency_id      INTEGER        NOT NULL
                       REFERENCES competencies(competency_id),
    criterion_name     VARCHAR(255)   NOT NULL,
    points_allocated   NUMERIC(4,1)   NOT NULL,
    display_order      INTEGER        NOT NULL,
    is_gender_specific BOOLEAN        DEFAULT FALSE,
    gender_condition   VARCHAR(10)
                       CHECK (gender_condition IN ('female', 'male')),
    notes              TEXT
);

-- =============================================================
-- TABLE 4: clinical_facilities
-- User-managed lookup table. No pre-existing list exists.
-- Authorised users add facilities through the UI.
-- Three starter facilities are inserted in seed_data.sql.
-- =============================================================
CREATE TABLE clinical_facilities (
    facility_id    SERIAL        PRIMARY KEY,
    facility_name  VARCHAR(150)  NOT NULL,
    facility_type  VARCHAR(50)   NOT NULL
                   CHECK (facility_type IN (
                       'Health Centre',
                       'Rural Hospital',
                       'District Hospital',
                       'Central Hospital',
                       'CHAM/ICAM Health Centre',
                       'CHAM/ICAM Hospital Centre',
                       'Other'
                   )),
    ownership      VARCHAR(20)   NOT NULL
                   CHECK (ownership IN ('Government', 'Private', 'Other')),
    district       VARCHAR(100)  NOT NULL,
    region         VARCHAR(20)   NOT NULL
                   CHECK (region IN ('Northern', 'Central', 'Southern')),
    is_active      BOOLEAN       DEFAULT TRUE,
    created_at     TIMESTAMP     DEFAULT NOW(),
    updated_at     TIMESTAMP     DEFAULT NOW()
);

-- =============================================================
-- TABLE 5: users
-- Clinical Instructors, Department Administrators,
-- Directors/HODs, and ICT Administrators only.
-- Students are NOT users of the system.
-- =============================================================
CREATE TABLE users (
    user_id       SERIAL        PRIMARY KEY,
    full_name     VARCHAR(150)  NOT NULL,
    email         VARCHAR(150)  UNIQUE NOT NULL,
    role          VARCHAR(30)   NOT NULL
                  CHECK (role IN (
                      'clinical_instructor',
                      'department_admin',
                      'director',
                      'ict_admin'
                  )),
    password_hash VARCHAR(255)  NOT NULL,
    is_active     BOOLEAN       DEFAULT TRUE,
    created_at    TIMESTAMP     DEFAULT NOW()
);

-- =============================================================
-- TABLE 6: students
-- Nursing students who are assessed.
-- gender drives which gender-conditional criteria appear
-- on the assessment form for that student.
-- =============================================================
CREATE TABLE students (
    student_id      SERIAL        PRIMARY KEY,
    registration_no VARCHAR(50)   UNIQUE NOT NULL,
    full_name       VARCHAR(150)  NOT NULL,
    level_of_study  VARCHAR(20)   NOT NULL
                    CHECK (level_of_study IN
                        ('Year 1', 'Year 2', 'Year 3', 'Year 4')),
    gender          VARCHAR(10)   NOT NULL
                    CHECK (gender IN ('male', 'female')),
    created_at      TIMESTAMP     DEFAULT NOW()
);

-- =============================================================
-- TABLE 7: assessments
-- One row per assessment session.
-- Cancellation rule: if an instructor cancels mid-assessment,
-- the in-progress row is hard-deleted. Nothing is stored.
-- attempt_number only increments on submitted assessments.
-- =============================================================
CREATE TABLE assessments (
    assessment_id      SERIAL        PRIMARY KEY,
    student_id         INTEGER       NOT NULL
                       REFERENCES students(student_id),
    category_id        INTEGER       NOT NULL
                       REFERENCES assessment_categories(category_id),
    instructor_id      INTEGER       NOT NULL
                       REFERENCES users(user_id),
    facility_id        INTEGER
                       REFERENCES clinical_facilities(facility_id),
    attempt_number     SMALLINT      NOT NULL DEFAULT 1
                       CHECK (attempt_number BETWEEN 1 AND 3),
    status             VARCHAR(20)   NOT NULL DEFAULT 'in_progress'
                       CHECK (status IN ('in_progress', 'submitted', 'reviewed')),
    date_assessed      DATE          NOT NULL,
    general_comments   TEXT,
    total_marks_scored NUMERIC(6,2),
    percentage_score   NUMERIC(5,2),
    is_pass            BOOLEAN
);

-- =============================================================
-- TRIGGER on assessments
-- Prevents a Year 2 assessment category being used
-- to assess a Year 1 student, and vice versa.
-- A plain CHECK constraint cannot compare columns across tables,
-- so a trigger is used instead.
-- The trigger is the guarantee; the backend route also
-- performs the same check to show a clean error in the UI.
-- =============================================================
CREATE OR REPLACE FUNCTION enforce_assessment_level_match()
RETURNS TRIGGER AS $$
DECLARE
    v_category_level VARCHAR(50);
    v_student_level  VARCHAR(20);
BEGIN
    SELECT applicable_level INTO v_category_level
    FROM assessment_categories
    WHERE category_id = NEW.category_id;

    SELECT level_of_study INTO v_student_level
    FROM students
    WHERE student_id = NEW.student_id;

    -- If applicable_level is NULL, the category applies to all levels.
    IF v_category_level IS NOT NULL AND v_category_level <> v_student_level THEN
        RAISE EXCEPTION
            'Assessment category level (%) does not match student level of study (%)',
            v_category_level, v_student_level;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enforce_assessment_level_match
BEFORE INSERT OR UPDATE OF category_id, student_id ON assessments
FOR EACH ROW
EXECUTE FUNCTION enforce_assessment_level_match();

-- =============================================================
-- TABLE 8: assessment_scores
-- One row per criterion per assessment.
-- ON DELETE CASCADE means cancelling (deleting) an in-progress
-- assessment automatically removes all its partial scores.
-- =============================================================
CREATE TABLE assessment_scores (
    score_id      SERIAL        PRIMARY KEY,
    assessment_id INTEGER       NOT NULL
                  REFERENCES assessments(assessment_id) ON DELETE CASCADE,
    criterion_id  INTEGER       NOT NULL
                  REFERENCES criteria(criterion_id),
    marks_scored  NUMERIC(4,1)  NOT NULL,
    comment       TEXT,
    UNIQUE (assessment_id, criterion_id)
);

COMMIT;
-- =============================================================
-- NEXUS: Seed Data
-- File:    db/seed/seed_data.sql
-- Run:     psql -U postgres -d nexus_db -f db/seed/seed_data.sql
-- Note:    Run schema.sql first. This file runs after it.
-- Note:    The unit test at the bottom asserts the total = 161.
-- =============================================================

BEGIN;

-- =============================================================
-- SECTION 1: Assessment Category
-- =============================================================
INSERT INTO assessment_categories
    (category_code, category_name, applicable_level,
     total_points, pass_mark_pct, version_label)
VALUES
    ('BNC', 'Basic Nursing Care Assessment', 'Year 1',
     161, 60.0, 'Revised September 2024');


-- =============================================================
-- SECTION 2: Top-Level Competencies (parent = NULL)
-- display_order uses multiples of 10 so items can be inserted
-- between them later without renumbering.
-- =============================================================
INSERT INTO competencies (category_id, parent_competency_id, competency_name, display_order)
VALUES
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     NULL, 'History Taking', 10),
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     NULL, 'Review of Systems', 20),
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     NULL, 'Physical Examination', 30),
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     NULL, 'Head to Toe Examination', 40),
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     NULL, 'Nursing Care Plan', 50);


-- =============================================================
-- SECTION 3: Sub-Competencies Under History Taking
-- =============================================================
INSERT INTO competencies (category_id, parent_competency_id, competency_name, display_order)
VALUES
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Personal Data', 11),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Chief Complaint', 12),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'History of Present Illness', 13),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Past Medical History', 14),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Past Surgical History', 15),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Drug History', 16),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Nutritional History', 17),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Social-Economic History', 18),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Gynaecology and Obstetric History', 19),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'General Reproductive History', 20),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Family and Environmental History', 21),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'History Taking'),
     'Sleep Pattern', 22);


-- =============================================================
-- SECTION 4: Sub-Competencies Under Physical Examination
-- =============================================================
INSERT INTO competencies (category_id, parent_competency_id, competency_name, display_order)
VALUES
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Physical Examination'),
     'General Survey', 31);

-- Vital signs is a single criterion scored directly under Physical Examination,
-- so no sub-competency row is needed for it.


-- =============================================================
-- SECTION 5: Sub-Competencies Under Head to Toe Examination
-- Some of these have their own children (Ears, Chest, Abdomen).
-- =============================================================
INSERT INTO competencies (category_id, parent_competency_id, competency_name, display_order)
VALUES
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Head and Neck', 41),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Eyes', 42),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Nose', 43),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Mouth', 44),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Ears', 45),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Upper Extremities', 46),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Chest', 47),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Abdomen', 48),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Lower Extremities', 49);


-- =============================================================
-- SECTION 6: Third-Level Competencies (Ears, Chest, Abdomen)
-- These are grandchildren of Head to Toe Examination.
-- =============================================================
INSERT INTO competencies (category_id, parent_competency_id, competency_name, display_order)
VALUES
    -- Under Ears
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears'),
     'Ears Inspection', 451),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears'),
     'Ears Palpation', 452),

    -- Under Chest
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest'),
     'Chest Inspection', 471),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest'),
     'Chest Auscultation', 472),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest'),
     'Chest Palpation', 473),

    -- Under Abdomen
    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen'),
     'Abdomen Inspection', 481),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen'),
     'Abdomen Auscultation', 482),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen'),
     'Abdomen Percussion', 483),

    ((SELECT category_id FROM assessment_categories WHERE category_code = 'BNC'),
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen'),
     'Abdomen Palpation', 484);


-- =============================================================
-- SECTION 7: Criteria Under Personal Data (History Taking)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-PD-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Name of patient', 1, 1101),
    ('BNC-HT-PD-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Age', 1, 1102),
    ('BNC-HT-PD-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Sex', 1, 1103),
    ('BNC-HT-PD-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Religion', 1, 1104),
    ('BNC-HT-PD-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Address', 1, 1105),
    ('BNC-HT-PD-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Next of kin', 1, 1106),
    ('BNC-HT-PD-07',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Marital status', 1, 1107),
    ('BNC-HT-PD-08',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Education level', 1, 1108),
    ('BNC-HT-PD-09',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Personal Data'),
     'Occupation', 1, 1109);


-- =============================================================
-- SECTION 8: Criterion Under Chief Complaint
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-CC-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chief Complaint'),
     'Chief complaint', 1, 1201);


-- =============================================================
-- SECTION 9: Criteria Under History of Present Illness
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-HPI-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'History of Present Illness'),
     'Onset of illness', 1, 1301),
    ('BNC-HT-HPI-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'History of Present Illness'),
     'Duration', 1, 1302),
    ('BNC-HT-HPI-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'History of Present Illness'),
     'Relieving or aggravating factors', 1, 1303),
    ('BNC-HT-HPI-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'History of Present Illness'),
     'Action taken to relieve the problem', 1, 1304),
    ('BNC-HT-HPI-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'History of Present Illness'),
     'Any improvement', 1, 1305);


-- =============================================================
-- SECTION 10: Criteria Under Past Medical History
-- (Including HIV status and childhood illnesses)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-PMH-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Malaria', 1, 1401),
    ('BNC-HT-PMH-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Anemia', 1, 1402),
    ('BNC-HT-PMH-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'TB', 1, 1403),
    ('BNC-HT-PMH-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Epilepsy', 1, 1404),
    ('BNC-HT-PMH-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Diabetes', 1, 1405),
    ('BNC-HT-PMH-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Hypertension', 1, 1406),
    ('BNC-HT-PMH-07',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Mental illness', 1, 1407),
    ('BNC-HT-PMH-08',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'STI including HIV', 1, 1408),
    ('BNC-HT-PMH-09',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Cancer', 1, 1409),
    ('BNC-HT-PMH-10',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Medical History'),
     'Asthma', 1, 1410);


-- =============================================================
-- SECTION 11: Criteria Under Past Surgical History
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-PSH-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Surgical History'),
     'Blood transfusion', 1, 1501),
    ('BNC-HT-PSH-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Surgical History'),
     'Operations', 1, 1502),
    ('BNC-HT-PSH-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Past Surgical History'),
     'Accidents', 1, 1503);


-- =============================================================
-- SECTION 12: Criterion Under Drug History (2 points, single item)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-DH-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Drug History'),
     'Drug history', 2, 1601);


-- =============================================================
-- SECTION 13: Criteria Under Nutritional History
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-NH-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nutritional History'),
     '24 hour dietary recall', 1, 1701),
    ('BNC-HT-NH-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nutritional History'),
     'Food availability', 1, 1702),
    ('BNC-HT-NH-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nutritional History'),
     'Problems affecting intake and absorption', 1, 1703);


-- =============================================================
-- SECTION 14: Criteria Under Social-Economic History
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-SEH-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Social-Economic History'),
     'Marital status', 1, 1801),
    ('BNC-HT-SEH-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Social-Economic History'),
     'Number of children', 1, 1802),
    ('BNC-HT-SEH-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Social-Economic History'),
     'Hobbies', 1, 1803),
    ('BNC-HT-SEH-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Social-Economic History'),
     'Source of income', 1, 1804);


-- =============================================================
-- SECTION 15: Gender-Conditional Criteria
-- GOH applies to female patients only.
-- GRH applies to male patients only.
-- Both are in the database; the application filters by gender.
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name, points_allocated,
     display_order, is_gender_specific, gender_condition)
VALUES
    ('BNC-HT-GOH-01',
     (SELECT competency_id FROM competencies
      WHERE competency_name = 'Gynaecology and Obstetric History'),
     'Gynaecology and Obstetric History (including STI and FP history)',
     3, 1901, TRUE, 'female'),

    ('BNC-HT-GRH-01',
     (SELECT competency_id FROM competencies
      WHERE competency_name = 'General Reproductive History'),
     'General reproductive history',
     3, 2001, TRUE, 'male');


-- =============================================================
-- SECTION 16: Family and Environmental History (3 points)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-FEH-01',
     (SELECT competency_id FROM competencies
      WHERE competency_name = 'Family and Environmental History'),
     'Family and Environmental history', 3, 2101);


-- =============================================================
-- SECTION 17: Sleep Pattern (1 point)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HT-SP-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Sleep Pattern'),
     'Sleep pattern', 1, 2201);


-- =============================================================
-- SECTION 18: Criteria Under Review of Systems
-- These are direct criteria under the top-level competency.
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-ROS-001',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'HEENT (headache, decreased hearing, blurred vision, sore throat)',
     1, 2301),
    ('BNC-ROS-002',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Nervous system (dizziness, fainting, seizures, weakness, numbness, tingling)',
     1, 2302),
    ('BNC-ROS-003',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Respiratory system (cough, hemoptysis, shortness of breath, wheezing, painful breathing)',
     1, 2303),
    ('BNC-ROS-004',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Cardiovascular/circulatory system (chest pain, palpitations, shortness of breath with activity, nocturnal dyspnoea, oedema)',
     1, 2304),
    ('BNC-ROS-005',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Gastro-intestinal or digestive (swallowing difficulty, heartburn, constipation, diarrhoea, jaundice, change in bowel habits)',
     1, 2305),
    ('BNC-ROS-006',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Urinary system (nocturia, incontinence, pain, frequency, haematuria)',
     1, 2306),
    ('BNC-ROS-007',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Musculo-skeletal system (muscle pain, joint pain, peripheral neuropathy)',
     1, 2307),
    ('BNC-ROS-008',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Immune (lymphatic) system',
     1, 2308),
    ('BNC-ROS-009',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Endocrine (heat or cold intolerance, polyuria, polydipsia, polyphagia, sweating)',
     1, 2309),
    ('BNC-ROS-010',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Integumentary (rashes, lumps, itching, dryness, colour changes)',
     1, 2310),
    ('BNC-ROS-011',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Reproductive (erectile dysfunction, dyspareunia, vaginal discharge)',
     1, 2311);


-- =============================================================
-- SECTION 19: ADL (12 points, single item, no sub-scores)
-- This is the highest-value single criterion in the guide.
-- The notes field drives the helper text shown in the UI.
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order, notes)
VALUES
    ('BNC-ROS-ADL-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Review of Systems'),
     'Activities of daily living',
     12, 2312,
     'Enter a single mark 0-12. No sub-scores.');


-- =============================================================
-- SECTION 20: Criteria Under General Survey (Physical Examination)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-PE-GS-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'General Survey'),
     'General condition', 1, 3101),
    ('BNC-PE-GS-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'General Survey'),
     'Level of consciousness', 1, 3102),
    ('BNC-PE-GS-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'General Survey'),
     'Cleanliness', 1, 3103),
    ('BNC-PE-GS-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'General Survey'),
     'Gait', 1, 3104),
    ('BNC-PE-GS-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'General Survey'),
     'Facial expressions', 1, 3105);


-- =============================================================
-- SECTION 21: Vital Signs (4 points, direct under Physical Examination)
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-PE-VS-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Physical Examination'),
     'Vital signs and interpretation', 4, 3201);


-- =============================================================
-- SECTION 22: Criteria Under Head and Neck
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-HN-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head and Neck'),
     'Shape', 1, 4101),
    ('BNC-HTE-HN-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head and Neck'),
     'Size', 1, 4102),
    ('BNC-HTE-HN-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head and Neck'),
     'Face (symmetry of facial features, scalp and hair)', 1, 4103),
    ('BNC-HTE-HN-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head and Neck'),
     'Range of motion (side, up, and down)', 1, 4104),
    ('BNC-HTE-HN-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head and Neck'),
     'Neck (lymph nodes, jugular vein, thyroid gland)', 1, 4105),
    ('BNC-HTE-HN-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head and Neck'),
     'Palpate tumours and swellings', 1, 4106);


-- =============================================================
-- SECTION 23: Criteria Under Eyes
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-EY-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Eyes'),
     'Symmetry and movement', 1, 4201),
    ('BNC-HTE-EY-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Eyes'),
     'Conjunctiva (discharge, redness)', 1, 4202),
    ('BNC-HTE-EY-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Eyes'),
     'Check pupils reaction to light', 1, 4203);


-- =============================================================
-- SECTION 24: Criteria Under Nose
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-NS-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nose'),
     'Discharges', 1, 4301),
    ('BNC-HTE-NS-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nose'),
     'Bleeding', 1, 4302),
    ('BNC-HTE-NS-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nose'),
     'Polyps', 1, 4303),
    ('BNC-HTE-NS-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nose'),
     'Swelling', 1, 4304),
    ('BNC-HTE-NS-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nose'),
     'Palpate the sinuses', 1, 4305);


-- =============================================================
-- SECTION 25: Criteria Under Mouth
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-MO-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Mouth'),
     'Lips (colour, dryness, sores)', 1, 4401),
    ('BNC-HTE-MO-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Mouth'),
     'Tongue (movement, swellings)', 1, 4402),
    ('BNC-HTE-MO-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Mouth'),
     'Teeth (number, hygiene, dentures, decay)', 1, 4403),
    ('BNC-HTE-MO-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Mouth'),
     'Membranes (moist, soft, pink)', 1, 4404),
    ('BNC-HTE-MO-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Mouth'),
     'View back of mouth (tonsils, uvula, pharynx)', 1, 4405),
    ('BNC-HTE-MO-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Mouth'),
     'Palate', 1, 4406);


-- =============================================================
-- SECTION 26: Criteria Under Ears Inspection
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-EAI-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Symmetry', 1, 4501),
    ('BNC-HTE-EAI-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Size', 1, 4502),
    ('BNC-HTE-EAI-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Shape', 1, 4503),
    ('BNC-HTE-EAI-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Drainage', 1, 4504),
    ('BNC-HTE-EAI-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Ear wax', 1, 4505),
    ('BNC-HTE-EAI-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Lesions', 1, 4506),
    ('BNC-HTE-EAI-07',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Mastoid bone (swelling, redness)', 1, 4507),
    ('BNC-HTE-EAI-08',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Inspection'),
     'Ear hygiene', 1, 4508);


-- =============================================================
-- SECTION 27: Criteria Under Ears Palpation
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-EAP-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Palpation'),
     'Ear lobe for tender areas', 1, 4521),
    ('BNC-HTE-EAP-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Palpation'),
     'Mastoid bone for tenderness', 1, 4522),
    ('BNC-HTE-EAP-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Ears Palpation'),
     'Pre-post auricular lymph nodes', 1, 4523);


-- =============================================================
-- SECTION 28: Criteria Under Upper Extremities
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-UE-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Symmetry and deformities', 1, 4601),
    ('BNC-HTE-UE-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Edema', 1, 4602),
    ('BNC-HTE-UE-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Capillary refill', 1, 4603),
    ('BNC-HTE-UE-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Finger clubbing', 1, 4604),
    ('BNC-HTE-UE-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Nail infection', 1, 4605),
    ('BNC-HTE-UE-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Hygiene', 1, 4606),
    ('BNC-HTE-UE-07',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Upper Extremities'),
     'Temperature', 1, 4607);


-- =============================================================
-- SECTION 29: Criteria Under Chest Inspection
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-CHI-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Inspection'),
     'Size and shape of chest', 1, 4701),
    ('BNC-HTE-CHI-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Inspection'),
     'Symmetry', 1, 4702),
    ('BNC-HTE-CHI-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Inspection'),
     'Scars, rash', 1, 4703),
    ('BNC-HTE-CHI-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Inspection'),
     'Movement', 1, 4704),
    ('BNC-HTE-CHI-05',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Inspection'),
     'Breasts', 1, 4705),
    ('BNC-HTE-CHI-06',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Inspection'),
     'Respiratory (rhythm, depth, quality, pattern)', 1, 4706);


-- =============================================================
-- SECTION 30: Criteria Under Chest Auscultation
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-CHA-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Auscultation'),
     'Heart sounds (aortic, pulmonic, mitral, tricuspid)', 1, 4721),
    ('BNC-HTE-CHA-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Auscultation'),
     'Lungs', 1, 4722);


-- =============================================================
-- SECTION 31: Criteria Under Chest Palpation
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-CHP-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Palpation'),
     'Thrill, heaves', 1, 4731),
    ('BNC-HTE-CHP-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Palpation'),
     'Apex pulse pulsation', 1, 4732),
    ('BNC-HTE-CHP-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Chest Palpation'),
     'Pulses (at all sites for rate and rhythm)', 1, 4733);


-- =============================================================
-- SECTION 32: Criteria Under Abdomen Inspection
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-ABI-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Inspection'),
     'Shape or contour', 1, 4801),
    ('BNC-HTE-ABI-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Inspection'),
     'Distention', 1, 4802),
    ('BNC-HTE-ABI-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Inspection'),
     'Size/scars', 1, 4803),
    ('BNC-HTE-ABI-04',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Inspection'),
     'Visible peristalsis', 1, 4804);


-- =============================================================
-- SECTION 33: Criterion Under Abdomen Auscultation
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-ABA-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Auscultation'),
     'Bowel sounds', 1, 4821);


-- =============================================================
-- SECTION 34: Criterion Under Abdomen Percussion
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-ABP-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Percussion'),
     'Percussion', 1, 4831);


-- =============================================================
-- SECTION 35: Criteria Under Abdomen Palpation
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-ABL-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Palpation'),
     'Spleen and liver', 1, 4841),
    ('BNC-HTE-ABL-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Palpation'),
     'Light palpation', 1, 4842),
    ('BNC-HTE-ABL-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Abdomen Palpation'),
     'Deep palpation', 1, 4843);


-- =============================================================
-- SECTION 36: Criteria Under Lower Extremities
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-LE-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Lower Extremities'),
     'Oedema', 1, 4901),
    ('BNC-HTE-LE-02',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Lower Extremities'),
     'Varicose veins', 1, 4902),
    ('BNC-HTE-LE-03',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Lower Extremities'),
     'Homan''s sign/DVT', 1, 4903);


-- =============================================================
-- SECTION 37: Genitalia and Interpretation of Findings
-- These are single items scored directly under
-- Head to Toe Examination (no sub-competency needed).
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order)
VALUES
    ('BNC-HTE-GEN-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Genitalia', 1, 5001),
    ('BNC-HTE-IOF-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Head to Toe Examination'),
     'Interpretation of findings', 5, 5002);


-- =============================================================
-- SECTION 38: Criteria Under Nursing Care Plan
-- All five items are worth 3 points each.
-- =============================================================
INSERT INTO criteria
    (criterion_code, competency_id, criterion_name,
     points_allocated, display_order, notes)
VALUES
    ('BNC-NCP-ND-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nursing Care Plan'),
     'Nursing Diagnoses', 3, 5101,
     'Minimum 3 diagnoses required.'),
    ('BNC-NCP-PG-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nursing Care Plan'),
     'Patient''s Goals (short and long term)', 3, 5102, NULL),
    ('BNC-NCP-NI-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nursing Care Plan'),
     'Nursing interventions', 3, 5103, NULL),
    ('BNC-NCP-SR-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nursing Care Plan'),
     'Scientific rationale', 3, 5104, NULL),
    ('BNC-NCP-EV-01',
     (SELECT competency_id FROM competencies WHERE competency_name = 'Nursing Care Plan'),
     'Evaluation', 3, 5105, NULL);


-- =============================================================
-- SECTION 39: Clinical Facilities (Starter Sites)
-- Confirmed in stakeholder interview with Lydia Banda.
-- =============================================================
INSERT INTO clinical_facilities
    (facility_name, facility_type, ownership, district, region)
VALUES
    ('Mzuzu Central Hospital',
     'Central Hospital', 'Government', 'Mzuzu City', 'Northern'),
    ('St John''s of God Mission Hospital',
     'CHAM/ICAM Hospital Centre', 'Private', 'Mzuzu City', 'Northern'),
    ('Mzuzu Health Centre',
     'Health Centre', 'Government', 'Mzuzu City', 'Northern');


-- =============================================================
-- SECTION 40: Verification
-- This query must return exactly 161.
-- If it does not, something in the seed data above is wrong.
-- Do not commit this file until this assertion passes.
-- =============================================================
DO $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT SUM(c.points_allocated)
    INTO v_total
    FROM criteria c
    JOIN competencies comp ON c.competency_id = comp.competency_id
    WHERE comp.category_id = (
        SELECT category_id FROM assessment_categories
        WHERE category_code = 'BNC'
    );

    IF v_total <> 161 THEN
        RAISE EXCEPTION
            'Seed data total is %. Expected 161. Check for missing or duplicate criteria.',
            v_total;
    END IF;

    RAISE NOTICE 'Verification passed: total points = %', v_total;
END;
$$;

COMMIT;
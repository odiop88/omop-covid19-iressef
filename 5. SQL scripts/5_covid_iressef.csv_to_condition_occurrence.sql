-- Créer et réinitialiser la séquence

-- Need to add condition_status_concept_id

CREATE SEQUENCE IF NOT EXISTS omop_staging.condition_occurrence_id_seq;
ALTER SEQUENCE omop_staging.condition_occurrence_id_seq RESTART WITH 1;

WITH dedup_person AS (
    SELECT DISTINCT ON (person_source_value)
        person_id,
        person_source_value
    FROM omop_staging.person
),
dedup_visit AS (
    SELECT DISTINCT ON (person_id, visit_start_date)
        visit_occurrence_id,
        person_id,
        visit_start_date
    FROM omop_staging.visit_occurrence
),
covid_with_ids AS (
    SELECT
        c.*,
        p.person_id,
        v.visit_occurrence_id
    FROM covid c
    JOIN dedup_person p ON c.national_id = p.person_source_value
    LEFT JOIN dedup_visit v ON p.person_id = v.person_id AND CAST(c.dov AS date) = v.visit_start_date -- Code for manage every visit
),
unpivoted_conditions AS (
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS condition_start_date, 'headache' AS symptom, 378253 AS concept_id
    FROM covid_with_ids WHERE headache = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'diarrhea', 196523 FROM covid_with_ids WHERE diarrhea = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'sore throat', 4036632 FROM covid_with_ids WHERE sore_throat = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'muscle pain', 442752 FROM covid_with_ids WHERE muscle_pain = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'cough', 4137801 FROM covid_with_ids WHERE cough = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'vomiting', 441408 FROM covid_with_ids WHERE vomiting = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'fever', 437663 FROM covid_with_ids WHERE fever = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'body aches', 4325423 FROM covid_with_ids WHERE body_aches = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'pain', 4329041 FROM covid_with_ids WHERE pain = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'joint pain', 77074 FROM covid_with_ids WHERE joint_pain = 'yes'
)

INSERT INTO omop_staging.condition_occurrence (
    condition_occurrence_id,
    person_id,
    condition_concept_id,
    condition_start_date,
    condition_start_datetime,
    condition_end_date,
    condition_end_datetime,
    condition_type_concept_id,
    condition_status_concept_id,
    stop_reason,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    condition_source_value,
    condition_source_concept_id,
    condition_status_source_value
)
SELECT
    NEXTVAL('omop_staging.condition_occurrence_id_seq'),
    person_id,
    concept_id,
    condition_start_date,
    CAST(NULL AS timestamp),
    condition_start_date, --condition_end_date
    CAST(NULL AS timestamp),
    32817,  -- EHR record
    32899, -- Preliminary diagnosis
    NULL,
    0,
    visit_occurrence_id,
    0,
    symptom,
    NULL,
    NULL
FROM unpivoted_conditions;

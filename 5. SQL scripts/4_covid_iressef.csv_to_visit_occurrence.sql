-- Créer et réinitialiser la séquence
CREATE SEQUENCE IF NOT EXISTS omop_staging.visit_occurrence_id_seq;
ALTER SEQUENCE omop_staging.visit_occurrence_id_seq RESTART WITH 1;

WITH dedup_person AS (
    SELECT DISTINCT ON (person_source_value)
        person_id,
        person_source_value
    FROM omop_staging.person
),
dedup_care_site AS (
    SELECT DISTINCT ON (care_site_source_value)
        care_site_id,
        care_site_source_value
    FROM omop_staging.care_site
)

INSERT INTO omop_staging.visit_occurrence
(
    visit_occurrence_id,
    person_id,
    visit_concept_id,
    visit_start_date,
    visit_start_datetime,
    visit_end_date,
    visit_end_datetime,
    visit_type_concept_id,
    provider_id,
    care_site_id,
    visit_source_value,
    visit_source_concept_id,
    admitted_from_concept_id,
    admitted_from_source_value,
    discharged_to_concept_id,
    discharged_to_source_value,
    preceding_visit_occurrence_id
)
SELECT
    NEXTVAL('omop_staging.visit_occurrence_id_seq') AS visit_occurrence_id,

    p.person_id,

    CASE
        WHEN c.hospitalization = 'yes' THEN 8717   -- Inpatient
        WHEN c.hospitalization = 'no' THEN 32036   -- Laboratory visit
        ELSE 0
    END AS visit_concept_id,

    CAST(c.dov AS date) AS visit_start_date,
    NULL AS visit_start_datetime,
    CAST(c.dov AS date) AS visit_end_date,
    NULL AS visit_end_datetime,

    44818517 AS visit_type_concept_id, -- EHR

    NULL AS provider_id,
    cs.care_site_id,

    reason_visit AS visit_source_value,
    NULL AS visit_source_concept_id,
    NULL AS admitted_from_concept_id,
    NULL AS admitted_from_source_value,
    NULL AS discharged_to_concept_id,
    NULL AS discharged_to_source_value,
    NULL AS preceding_visit_occurrence_id

FROM covid c
LEFT JOIN dedup_person p
    ON c.national_id = p.person_source_value
LEFT JOIN dedup_care_site cs
    ON c.sample_site = cs.care_site_source_value;

-- Get patients who have a visit occurrence > 1 or more than 1 visit

--SELECT COUNT(*) AS count_patients_more_visits
--FROM (
  --  SELECT person_id
    --FROM omop_staging.visit_occurrence
    --GROUP BY person_id
    --HAVING COUNT(*) > 1
--) AS patients_multi_visites;

-- Get patients who have a more than 1 visit and count them
-- This query will return the person_id and the count of visits for each person
-- This can be useful to identify patients with multiple visits
--SELECT person_id, COUNT(*) AS nb_visites
--FROM omop_staging.visit_occurrence
--GROUP BY person_id
--HAVING COUNT(*) > 1
--ORDER BY nb_visites DESC;
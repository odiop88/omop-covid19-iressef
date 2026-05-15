-- Créer une vue des patients uniques
WITH dedup_person AS (
    SELECT DISTINCT ON (person_source_value)
        person_id,
        person_source_value
    FROM omop_staging.person
)

-- Insérer uniquement les décès
INSERT INTO omop_staging.death (
    person_id,
    death_date,
    death_datetime,
    death_type_concept_id, -- EHR = 32817
    cause_concept_id,
    cause_source_value,
    cause_source_concept_id
)
SELECT
    p.person_id,
    CAST(c.dov AS DATE) AS death_date,
    NULL AS death_datetime,
    32817 AS death_type_concept_id,       -- EHR system
    4306655 AS cause_concept_id,          -- "Death" SNOMED
    'deceased' AS cause_source_value,
    0 AS cause_source_concept_id
FROM covid c
JOIN dedup_person p ON c.national_id = p.person_source_value
WHERE LOWER(c.disease_outcome) = 'deceased';

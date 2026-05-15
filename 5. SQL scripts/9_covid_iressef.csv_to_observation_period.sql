-- Créer et réinitialiser la séquence
CREATE SEQUENCE IF NOT EXISTS omop_staging.observation_period_id_seq;
ALTER SEQUENCE omop_staging.observation_period_id_seq RESTART WITH 1;

WITH dedup_person AS (
    SELECT DISTINCT ON (person_source_value)
        person_id,
        person_source_value
    FROM omop_staging.person
)

INSERT INTO "omop_staging".observation_period
(
    observation_period_id,
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    period_type_concept_id -- EHR = 32817
)
SELECT
 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NEXTVAL('omop_staging.observation_period_id_seq') AS observation_period_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    p.person_id,

 -- [MAPPING COMMENT] First visit 
    CAST(c.dov AS date) AS observation_period_start_date,

 -- [MAPPING COMMENT] For several visits 
    CAST(c.dov AS date) AS observation_period_end_date,

 -- EHR
    32817 AS period_type_concept_id

FROM covid c
LEFT JOIN dedup_person p
    ON c.national_id = p.person_source_value
;
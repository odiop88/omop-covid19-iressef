-- Créer et réinitialiser la séquence pour care_site
CREATE SEQUENCE IF NOT EXISTS omop_staging.specimen_id_seq;
ALTER SEQUENCE omop_staging.care_site_id_seq RESTART WITH 1;

WITH dedup_person AS (
    SELECT DISTINCT ON (person_source_value)
        person_id,
        person_source_value
    FROM omop_staging.person
)


INSERT INTO omop_staging.specimen
(
    specimen_id,
    person_id,
    specimen_concept_id, -- 4122259 - Nasopharyngeal swab 42600142- Nasal swab => Good 4119519-Throat swab 4121219 - Nasopharyngeal aspirate => Good
    specimen_type_concept_id, -- 32817=EHR
    specimen_date,
    specimen_datetime,
    quantity,
    unit_concept_id,
    anatomic_site_concept_id,
    disease_status_concept_id,
    specimen_source_id,
    specimen_source_value,
    unit_source_value,
    anatomic_site_source_value,
    disease_status_source_value
)
SELECT
 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NEXTVAL('omop_staging.specimen_id_seq') AS specimen_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    p.person_id,

-- Mapping du SPECIMEN_CONCEPT_ID
    CASE
        WHEN c.sample_type = 'Nasal_throat_Nasopharyngeal_swab' THEN 4122259
        WHEN c.sample_type = 'Nasopharyngeal aspiration' THEN 4121219
        ELSE 0
    END AS specimen_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    32817 AS specimen_type_concept_id,

    CAST(c.dov AS date) AS specimen_date,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS specimen_datetime,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    0 AS quantity,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    0 AS unit_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS anatomic_site_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS disease_status_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS specimen_source_id,

    c.sample_type AS specimen_source_value,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS unit_source_value,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS anatomic_site_source_value,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS disease_status_source_value

FROM covid c
LEFT JOIN dedup_person p
    ON c.national_id = p.person_source_value;
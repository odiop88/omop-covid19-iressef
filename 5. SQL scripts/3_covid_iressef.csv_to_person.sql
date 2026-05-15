-- Créer et réinitialiser la séquence
CREATE SEQUENCE IF NOT EXISTS omop_staging.person_id_seq;
ALTER SEQUENCE omop_staging.person_id_seq RESTART WITH 1;

-- CTE pour récupérer une seule ligne par patient
WITH unique_persons AS (
    SELECT 
        national_id,
        gender,
        age,
        dov,
        address,
        sample_site,
        ROW_NUMBER() OVER (PARTITION BY national_id ORDER BY dov ASC) AS rn
    FROM covid
),

-- CTE pour dédupliquer les adresses dans la table location
dedup_location AS (
    SELECT DISTINCT ON (address_1)
        location_id,
        address_1
    FROM omop_staging.location
),

-- CTE pour dédupliquer les sites dans la table care_site
dedup_care_site AS (
    SELECT DISTINCT ON (care_site_name)
        care_site_id,
        care_site_name
    FROM omop_staging.care_site
)

-- Insertion dans la table person
INSERT INTO omop_staging.person
(
    person_id,
    gender_concept_id,
    year_of_birth,
    birth_datetime,
    race_concept_id,
    ethnicity_concept_id,
    location_id,
    provider_id,
    care_site_id,
    person_source_value,
    gender_source_value,
    gender_source_concept_id,
    race_source_value,
    race_source_concept_id,
    ethnicity_source_value,
    ethnicity_source_concept_id
)
SELECT
    NEXTVAL('omop_staging.person_id_seq') AS person_id,

    -- Mapping du genre
    CASE
        WHEN up.gender = 'Male' THEN 8507
        WHEN up.gender = 'Female' THEN 8532
        ELSE 0
    END AS gender_concept_id,

    -- Calcul de l'année de naissance
    EXTRACT(YEAR FROM CAST(up.dov AS date)) - up.age AS year_of_birth,

    NULL AS birth_datetime, -- Tu peux dériver si tu veux une date approximative

    38003600 AS race_concept_id,        -- African
    38003564 AS ethnicity_concept_id,   -- Not Hispanic

    dl.location_id AS location_id,
    0 AS provider_id,
    dcs.care_site_id AS care_site_id,

    up.national_id AS person_source_value,
    up.gender AS gender_source_value,
    0 AS gender_source_concept_id,
    NULL AS race_source_value,
    0 AS race_source_concept_id,
    NULL AS ethnicity_source_value,
    0 AS ethnicity_source_concept_id

FROM unique_persons up
LEFT JOIN dedup_location dl
    ON up.address = dl.address_1
LEFT JOIN dedup_care_site dcs
    ON up.sample_site = dcs.care_site_name
WHERE up.rn = 1;

CREATE SEQUENCE IF NOT EXISTS omop_staging.location_id_seq;

-- Reset la séquence avant insertion
ALTER SEQUENCE omop_staging.location_id_seq RESTART WITH 1;

-- Insérer les données dans la table location
INSERT INTO "omop_staging".location
(
    location_id,
    address_1,
    address_2,
    city,
    state,
    zip,
    county,
    location_source_value,
    country_concept_id, -- Senegal=4071848
    country_source_value,
    latitude, -- For Senegal
    longitude -- For Senegal
)
SELECT
 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NEXTVAL('omop_staging.location_id_seq') AS location_id,

    unique_locations.patient_address AS address_1,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS address_2,

 -- Update after Rachel and Reipeinter feedback
    unique_locations.location_source_value AS city,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS state,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS zip,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS county,

   -- Default covid_iressef.csv.patient_region AS location_source_value,
    unique_locations.location_source_value AS location_source_value,

 -- Senegal concept_id
    4071848 AS country_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    'Senegal' AS country_source_value,

 -- Later need to update with actual latitude and longitude values can do it directly in the table
    latitude_region AS latitude,

  -- Later need to update with actual latitude and longitude values, can do it directly in the table
    longitude_region AS longitude

FROM (
    SELECT DISTINCT
        --region AS city,
        patient_region AS location_source_value,
        address AS patient_address,
        latitude_region,
        longitude_region

    FROM covid
) AS unique_locations;


--Code for testing the insertion
--SELECT DISTINCT address_1, location_source_value FROM omop_staging.location
--ORDER BY address_1

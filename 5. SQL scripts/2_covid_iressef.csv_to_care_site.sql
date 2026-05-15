-- Créer et réinitialiser la séquence pour care_site
CREATE SEQUENCE IF NOT EXISTS omop_staging.care_site_id_seq;
ALTER SEQUENCE omop_staging.care_site_id_seq RESTART WITH 1;

-- Insertion dans la table care_site avec jointure sur location
INSERT INTO omop_staging.care_site
(
    care_site_id,
    care_site_name,
    place_of_service_concept_id,
    location_id,
    care_site_source_value,
    place_of_service_source_value
)
SELECT
    NEXTVAL('omop_staging.care_site_id_seq') AS care_site_id,
    unique_care_site.care_site_source_value AS care_site_name,
    0 AS place_of_service_concept_id,
    l.location_id,
    unique_care_site.care_site_source_value AS care_site_source_value,
    NULL AS place_of_service_source_value
FROM (
    SELECT DISTINCT
        sample_site AS care_site_source_value,
        patient_region -- ou une autre variable permettant de faire le lien
    FROM covid
) AS unique_care_site
LEFT JOIN omop_staging.location l
    ON l.location_source_value = unique_care_site.patient_region;


-- Get Count of care sites
--SELECT COUNT(DISTINCT care_site_id) AS nombre_structures
--FROM omop_staging.care_site;

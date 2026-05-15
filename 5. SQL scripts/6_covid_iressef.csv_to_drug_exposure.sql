-- Créer et réinitialiser la séquence
CREATE SEQUENCE IF NOT EXISTS omop_staging.drug_exposure_id_seq;
ALTER SEQUENCE omop_staging.drug_exposure_id_seq RESTART WITH 1;

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
unpivoted_drugs AS (
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS exposure_start_date, 'perfalgan' AS drug, 43834892 AS drug_concept_id
    FROM covid_with_ids WHERE perfalgan = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'efferalgan', 43146071 FROM covid_with_ids WHERE efferalgan = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'doliprane', 43212028 FROM covid_with_ids WHERE doliprane = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'azicure', 36853655 FROM covid_with_ids WHERE azicure = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'azithromycin', 1734104 FROM covid_with_ids WHERE azithromycin = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'paracetamol', 41144113 FROM covid_with_ids WHERE paracetamol = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'vitamine_c', 19008339 FROM covid_with_ids WHERE vitamine_c = 'yes'
    UNION ALL -- Vaccines
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'sinopharm', 0 FROM covid_with_ids WHERE covid_vaccine_type_dose1 = 'sinopharm' OR covid_vaccine_type_dose2 = 'sinopharm'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'astrazeneca', 0 FROM covid_with_ids WHERE covid_vaccine_type_dose1 = 'astrazeneca' OR covid_vaccine_type_dose2 = 'astrazeneca'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'pfizer', 0 FROM covid_with_ids WHERE covid_vaccine_type_dose1 = 'pfizer' OR covid_vaccine_type_dose2 = 'pfizer'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date), 'johnson', 0 FROM covid_with_ids WHERE covid_vaccine_type_dose1 = 'johnson' OR covid_vaccine_type_dose2 = 'johnson'

   
)

INSERT INTO omop_staging.drug_exposure
(
    drug_exposure_id,
    person_id,
    drug_concept_id,
    drug_exposure_start_date,
    drug_exposure_start_datetime,
    drug_exposure_end_date,
    drug_exposure_end_datetime,
    verbatim_end_date,
    drug_type_concept_id,
    stop_reason,
    refills,
    quantity,
    days_supply,
    sig,
    route_concept_id,
    lot_number,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    drug_source_value,
    drug_source_concept_id,
    route_source_value,
    dose_unit_source_value
)
SELECT
    NEXTVAL('omop_staging.drug_exposure_id_seq'),
    person_id,
    drug_concept_id,
    exposure_start_date,
    CAST(NULL AS timestamp),
    exposure_start_date, -- exposure_end date not available we choose epsoure_start_date
    CAST(NULL AS timestamp),
    NULL,
    32817, -- EHR
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    visit_occurrence_id,
    NULL,
    drug,
    0,
    NULL,
    NULL
FROM unpivoted_drugs;

-- CHECKING result SQL command and excel file filter into perfalgan to check if we have the same count
--SELECT COUNT(*) FROM omop_staging.drug_exposure
--WHERE drug_source_value='perfalgan'
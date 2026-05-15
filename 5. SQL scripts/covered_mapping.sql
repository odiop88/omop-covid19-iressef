-- Mapping Rate for person.gender_concept_id
SELECT 
  COUNT(*) AS total,
  COUNT(gender_concept_id) AS mapped,
  COUNT(*) - COUNT(gender_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(gender_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.person;


-- Concept_id Rate not mapped by table

--location.location_id
SELECT 
  COUNT(*) AS total_location,
  COUNT(country_concept_id) AS mapped,
  COUNT(*) - COUNT(country_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(country_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.location;


--person.person_id for gender
SELECT 
  COUNT(*) AS total_person,
  COUNT(gender_concept_id) AS mapped,
  COUNT(*) - COUNT(gender_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(gender_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.person;


--visit_occurrence.visit_concept_id
SELECT 
  COUNT(*) AS total_visit_occurrence,
  COUNT(visit_concept_id) AS mapped,
  COUNT(*) - COUNT(visit_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(visit_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.visit_occurrence;


--condition_occurrence.condition_concept_id
SELECT 
  COUNT(*) AS total_conditions,
  COUNT(condition_concept_id) AS mapped,
  COUNT(*) - COUNT(condition_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(condition_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.condition_occurrence;


--drug_exposure.drug_concept_id
SELECT 
  COUNT(*) AS total_drug,
  COUNT(drug_concept_id) AS mapped,
  COUNT(*) - COUNT(drug_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(drug_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.drug_exposure;

-- OR

SELECT 
  COUNT(*) AS total_drug,
  COUNT(CASE WHEN drug_concept_id != 0 THEN 1 END) AS mapped,
  COUNT(CASE WHEN drug_concept_id = 0 THEN 1 END) AS unmapped,
  ROUND(
    100.0 * COUNT(CASE WHEN drug_concept_id != 0 THEN 1 END) / COUNT(*),
    2
  ) AS mapping_rate_pct
FROM omop_staging.drug_exposure;


--measurement.measurement_concept_id
SELECT 
  COUNT(*) AS total_measurement,
  COUNT(measurement_concept_id) AS mapped,
  COUNT(*) - COUNT(measurement_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(measurement_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.measurement;

-- OR

SELECT 
  COUNT(*) AS total_measurement,
  COUNT(CASE WHEN measurement_concept_id != 0 THEN 1 END) AS mapped,
  COUNT(CASE WHEN measurement_concept_id = 0 THEN 1 END) AS unmapped,
  ROUND(
    100.0 * COUNT(CASE WHEN measurement_concept_id != 0 THEN 1 END) / COUNT(*),
    2
  ) AS mapping_rate_pct
FROM omop_staging.measurement;



--observation.observation_concept_id
SELECT 
  COUNT(*) AS total_observation,
  COUNT(observation_concept_id) AS mapped,
  COUNT(*) - COUNT(observation_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(observation_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.observation;

--OR

SELECT 
  COUNT(*) AS total_observation,
  COUNT(CASE WHEN observation_concept_id != 0 THEN 1 END) AS mapped,
  COUNT(CASE WHEN observation_concept_id = 0 THEN 1 END) AS unmapped,
  ROUND(
    100.0 * COUNT(CASE WHEN observation_concept_id != 0 THEN 1 END) / COUNT(*),
    2
  ) AS mapping_rate_pct
FROM omop_staging.observation;


--procedure_occurence.procedure_concept_id
SELECT 
  COUNT(*) AS total_procedure,
  COUNT(procedure_concept_id) AS mapped,
  COUNT(*) - COUNT(procedure_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(procedure_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.procedure_occurrence;

--death.cause_concept_id
SELECT 
  COUNT(*) AS total_death,
  COUNT(cause_concept_id) AS mapped,
  COUNT(*) - COUNT(cause_concept_id) AS unmapped,
  ROUND(100.0 * COUNT(cause_concept_id) / COUNT(*), 2) AS mapping_rate_pct
FROM omop_staging.death;










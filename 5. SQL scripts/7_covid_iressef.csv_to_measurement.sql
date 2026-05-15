-- 1) Séquence measurement_id (inchanged)
ALTER SEQUENCE omop_staging.measurement_id_seq RESTART WITH 1;

WITH
dedup_person AS (
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
  JOIN dedup_person p
    ON c.national_id = p.person_source_value
  LEFT JOIN dedup_visit v
    ON p.person_id = v.person_id
   AND CAST(c.dov AS date) = v.visit_start_date
),

-- Map texte → concept_id standard pour le résultat
result_map(txt, concept_id) AS (
    VALUES
      -- POSITIF
      ('Positif',4126681::bigint), -- Detected

      -- NEGATIF
      ('Negatif',9190::bigint), -- Not detected

      -- Equivocal
      ('Inconclusive',0),   -- Indeterminate

     -- Doubtful
      ('Doubtful',  0)   -- Indeterminate
),

unpivoted_measurement AS (

  /* ----  A) Température axillaire : valeur numérique  ---- */
  SELECT
    person_id,
    visit_occurrence_id,
    CAST(dov AS date)                        AS measurement_date,
    36716470                                  AS measurement_concept_id,  -- Axillary body temperature
    CAST(axillary_temperature AS float)       AS value_as_number,
    NULL::bigint                              AS value_as_concept_id,
    NULL::text                                AS measurement_source_value,
    '°C'                                      AS unit_source_value,
    NULL::text                                AS value_source_value
  FROM covid_with_ids
  WHERE axillary_temperature IS NOT NULL

  UNION ALL

  /* ----  B) PCR SARS-CoV-2 : qualitatif (valeur catégorielle)  ----
     Utilise 94309-2 (RT-PCR SARS-CoV-2 Presence) si tu préfères LOINC standard.
     Ici je garde tes IDs 40482792/4246053 si ton ETL les exploite déjà.
  */
  SELECT
    person_id,
    visit_occurrence_id,
    CAST(dov AS date)                         AS measurement_date,
    40482792                                  AS measurement_concept_id,  -- PCR (ton ID existant)
    NULL::float                               AS value_as_number,
    rm.concept_id                             AS value_as_concept_id,     -- Detected / Not detected / Indeterminate ...
    'PCR'                                     AS measurement_source_value,
    NULL::text                                AS unit_source_value,
    test_result                               AS value_source_value        -- texte brut conservé
  FROM covid_with_ids c
  LEFT JOIN result_map rm
    ON rm.txt = LOWER(TRIM(c.test_result))
  WHERE LOWER(TRIM(c.test_type)) = 'pcr'
    AND c.test_result IS NOT NULL

  UNION ALL

  /* ----  C) Sérologie SARS-CoV-2 : qualitatif  ---- */
  SELECT
    person_id,
    visit_occurrence_id,
    CAST(dov AS date)                         AS measurement_date,
    4246053                                   AS measurement_concept_id,  -- Sérologie (ton ID existant)
    NULL::float                               AS value_as_number,
    rm.concept_id                             AS value_as_concept_id,
    'Serology'                                AS measurement_source_value,
    NULL::text                                AS unit_source_value,
    test_result                               AS value_source_value
  FROM covid_with_ids c
  LEFT JOIN result_map rm
    ON rm.txt = LOWER(TRIM(c.test_result))
  WHERE LOWER(TRIM(c.test_type)) = 'serology'
    AND c.test_result IS NOT NULL
)

INSERT INTO omop_staging.measurement (
  measurement_id,
  person_id,
  measurement_concept_id,
  measurement_date,
  measurement_datetime,
  measurement_time,
  measurement_type_concept_id,
  operator_concept_id,
  value_as_number,
  value_as_concept_id,
  unit_concept_id,
  range_low,
  range_high,
  provider_id,
  visit_occurrence_id,
  visit_detail_id,
  measurement_source_value,
  measurement_source_concept_id,
  unit_source_value,
  unit_source_concept_id,
  value_source_value,
  measurement_event_id,
  meas_event_field_concept_id
)
SELECT
  NEXTVAL('omop_staging.measurement_id_seq'),
  person_id,
  measurement_concept_id,
  measurement_date,
  NULL,
  NULL,
  32817,               -- EHR record (garde la cohérence avec ton ETL)
  NULL,
  value_as_number,
  value_as_concept_id,
  NULL,
  NULL,
  NULL,
  NULL,
  visit_occurrence_id,
  NULL,
  measurement_source_value,
  NULL,
  unit_source_value,
  NULL,
  value_source_value,
  NULL,
  NULL
FROM unpivoted_measurement;

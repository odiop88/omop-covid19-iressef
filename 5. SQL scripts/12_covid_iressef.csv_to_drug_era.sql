-- Exemple simple pour créer la table drug_era à partir de drug_exposure
-- Tu peux adapter le gap selon ton besoin (ici 30 jours)

WITH ingredient_level AS (
  SELECT
    person_id,
    drug_concept_id,
    drug_exposure_start_date AS start_date,
    COALESCE(drug_exposure_end_date, drug_exposure_start_date + INTERVAL '1 day') AS end_date
  FROM omop_staging.drug_exposure
),

ordered_events AS (
  SELECT
    *,
    LAG(end_date) OVER (PARTITION BY person_id, drug_concept_id ORDER BY start_date) AS previous_end
  FROM ingredient_level
),

flag_new_era AS (
  SELECT *,
    CASE
      WHEN previous_end IS NULL OR start_date > previous_end + INTERVAL '30 day' THEN 1
      ELSE 0
    END AS new_era_flag
  FROM ordered_events
),

era_groups AS (
  SELECT *,
    SUM(new_era_flag) OVER (PARTITION BY person_id, drug_concept_id ORDER BY start_date ROWS UNBOUNDED PRECEDING) AS era_id
  FROM flag_new_era
),

drug_era_final AS (
  SELECT
    person_id,
    drug_concept_id,
    MIN(start_date) AS drug_era_start_date,
    MAX(end_date) AS drug_era_end_date,
    COUNT(*) AS drug_exposure_count
  FROM era_groups
  GROUP BY person_id, drug_concept_id, era_id
)

INSERT INTO omop_staging.drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count)
SELECT
  ROW_NUMBER() OVER () AS drug_era_id,
  person_id,
  drug_concept_id,
  drug_era_start_date,
  drug_era_end_date,
  drug_exposure_count
FROM drug_era_final;

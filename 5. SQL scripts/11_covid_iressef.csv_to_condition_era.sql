WITH condition_dates AS (
  SELECT
    person_id,
    condition_concept_id,
    condition_start_date,
    COALESCE(condition_end_date, condition_start_date + INTERVAL '1 day') AS condition_end_date
  FROM omop_staging.condition_occurrence
),

ordered_conditions AS (
  SELECT *,
    LAG(condition_end_date) OVER (PARTITION BY person_id, condition_concept_id ORDER BY condition_start_date) AS prev_end_date
  FROM condition_dates
),

flag_new_era AS (
  SELECT *,
    CASE
      WHEN prev_end_date IS NULL OR condition_start_date > prev_end_date + INTERVAL '30 days' THEN 1
      ELSE 0
    END AS new_era
  FROM ordered_conditions
),

era_grouping AS (
  SELECT *,
    SUM(new_era) OVER (PARTITION BY person_id, condition_concept_id ORDER BY condition_start_date ROWS UNBOUNDED PRECEDING) AS era_id
  FROM flag_new_era
),

aggregated_eras AS (
  SELECT
    person_id,
    condition_concept_id,
    MIN(condition_start_date) AS condition_era_start_date,
    MAX(condition_end_date) AS condition_era_end_date,
    COUNT(*) AS condition_occurrence_count
  FROM era_grouping
  GROUP BY person_id, condition_concept_id, era_id
)

INSERT INTO omop_staging.condition_era (
  condition_era_id,
  person_id,
  condition_concept_id,
  condition_era_start_date,
  condition_era_end_date,
  condition_occurrence_count
)
SELECT
  ROW_NUMBER() OVER () AS condition_era_id,
  person_id,
  condition_concept_id,
  condition_era_start_date,
  condition_era_end_date,
  condition_occurrence_count
FROM aggregated_eras;

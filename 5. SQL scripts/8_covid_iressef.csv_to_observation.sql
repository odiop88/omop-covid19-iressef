-- Créer et réinitialiser la séquence
CREATE SEQUENCE IF NOT EXISTS omop_staging.observation_id_seq;
ALTER SEQUENCE omop_staging.observation_id_seq RESTART WITH 1;

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

unpivoted_observations AS (
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'student' AS observation_name, 4277918 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'student'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'housekeeper' AS observation_name, 4050045 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'housekeeper'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'merchant' AS observation_name, 4010439 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'merchant'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'retired' AS observation_name, 37016772 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'retired'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'education sector' AS observation_name, 4146801 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'education sector'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'finance professional' AS observation_name, 4270911 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'finance professional'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'medical staff' AS observation_name, 4145395 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'medical staff'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'laborer' AS observation_name, 4026886 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'laborer'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'transportation' AS observation_name, 4202166 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'transportation'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'public service' AS observation_name, 4213565 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'public service'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'technician' AS observation_name, 4024738 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'technician'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'engineer' AS observation_name, 4023457 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'engineer'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'mechanic' AS observation_name, 4119472 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'mechanic'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'security services' AS observation_name, 4202006 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'security services'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'salesperson' AS observation_name, 4012060 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'salesperson'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'agriculture' AS observation_name, 4023490 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'agriculture'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'IT specialist' AS observation_name, 4341519 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'IT specialist'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'industrial worker' AS observation_name, 4146330 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'industrial worker'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'construction sector' AS observation_name, 4023808 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'construction sector'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'agent' AS observation_name, 4010804 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'agent'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'executive manager' AS observation_name, 37151735 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'executive_manager'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'manager' AS observation_name, 4025521 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'manager'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'catering restaurant' AS observation_name, 4050342 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'catering_restaurant'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'electronics' AS observation_name, 4097082 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'electronics'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'journalist' AS observation_name, 4105610 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'journalist'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'hairdresser' AS observation_name, 4204483 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'hairdresser'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'religious worker' AS observation_name, 4024857 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'religious worker'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'entrepreneur' AS observation_name, 4143813 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'entrepreneur'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'economist' AS observation_name, 4024160 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'economist'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'police officer' AS observation_name, 4031180 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'police officer'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'laboratory worker' AS observation_name, 4010785 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'laboratory worker'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'electricity electrical services' AS observation_name, 4119472 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'electricity_electrical services'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'welder' AS observation_name, 4208244 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'welder'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'secretary' AS observation_name, 4202007 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'secretary'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'military police' AS observation_name, 4031180 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'military police'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'employee' AS observation_name, 4023811 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'employee'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'livestock farming' AS observation_name, 4180249 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'livestock farming'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'artist' AS observation_name, 4011579 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'artist'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'hospitality' AS observation_name, 4266235 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'hospitality'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'aviation worker' AS observation_name, 4147399 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'aviation worker'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'assistant' AS observation_name, 4009550 AS observation_concept_id
    FROM covid_with_ids WHERE occupation = 'assistant'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'sore throat' AS observation_name, 4036632 AS observation_concept_id
    FROM covid_with_ids WHERE sore_throat = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'sheep' AS observation_name, 4051827 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'sheep'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'chicken' AS observation_name, 3053366 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'chicken'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'dogs' AS observation_name, 3267122 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'dogs'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'cat' AS observation_name, 45882565 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'cat'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'goat' AS observation_name, 36662455 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'goat'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'horse' AS observation_name, 36662346 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'horse'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'beef' AS observation_name, 4037235 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'beef'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'pork' AS observation_name, 4037243 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'pork'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'duck' AS observation_name, 42065133 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'duck'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'fish' AS observation_name, 42539493 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'fish'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'donkey' AS observation_name, 42596036 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_1 = 'donkey'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'sheep' AS observation_name, 4051827 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'sheep'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'chicken' AS observation_name, 3053366 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'chicken'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'dog' AS observation_name, 3267122 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'dog'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'goat' AS observation_name, 36662455 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'goat'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'donkey' AS observation_name, 42596036 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'donkey'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'pigeon' AS observation_name, 40345910 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'pigeon'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'horse' AS observation_name, 36662346 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'horse'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'beef' AS observation_name, 4037235 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'beef'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'bird' AS observation_name, 4037235 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_2 = 'bird'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'sheep' AS observation_name, 4051827 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'sheep'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'chicken' AS observation_name, 3053366 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'chicken'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'dogs' AS observation_name, 3267122 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'dogs'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'cat' AS observation_name, 45882565 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'cat'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'goat' AS observation_name, 36662455 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'goat'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'horse' AS observation_name, 36662346 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'horse'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'beef' AS observation_name, 4037235 AS observation_concept_id
    FROM covid_with_ids WHERE animal_type_3 = 'beef'
    
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Seen by traditional medicine practitioner' AS observation_name, 764647
    AS observation_concept_id
    FROM covid_with_ids WHERE traditional_healer_consulted = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Close contact with confirmed COVID-19 case patient' AS observation_name, 756077
    AS observation_concept_id
    FROM covid_with_ids WHERE contact_with_case = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Recent air travel' AS observation_name, 40481621
    AS observation_concept_id
    FROM covid_with_ids WHERE recent_travel = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Married' AS observation_name, 4338692
    AS observation_concept_id
    FROM covid_with_ids WHERE marital_status = 'married'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Single' AS observation_name, 4053842
    AS observation_concept_id
    FROM covid_with_ids WHERE marital_status = 'single'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Widowed' AS observation_name, 4143188
    AS observation_concept_id
    FROM covid_with_ids WHERE marital_status = 'widowed'
    UNION ALL    
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Divorced' AS observation_name, 4069297
    AS observation_concept_id
    FROM covid_with_ids WHERE marital_status = 'divorced'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Engaged' AS observation_name, 4204399
    AS observation_concept_id
    FROM covid_with_ids WHERE marital_status = 'engaged'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Loss of taste' AS observation_name, 4289517
    AS observation_concept_id
    FROM covid_with_ids WHERE ageusia = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Loss of sense of smell' AS observation_name, 4185711
    AS observation_concept_id
    FROM covid_with_ids WHERE anosmia = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Loss of appetite' AS observation_name, 442165
    AS observation_concept_id
    FROM covid_with_ids WHERE anorexia = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Dizziness present' AS observation_name, 4012520
    AS observation_concept_id
    FROM covid_with_ids WHERE dizziness = 'yes'
    UNION ALL

    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Nasal discharge present' AS observation_name, 4149990
    AS observation_concept_id
    FROM covid_with_ids WHERE runny_nose = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Coughing' AS observation_name, 4137801
    AS observation_concept_id
    FROM covid_with_ids WHERE cough = 'yes'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Pet ownership - finding' AS observation_name, 4267363
    AS observation_concept_id
    FROM covid_with_ids WHERE contact_with_animals = 'yes'

    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Suspected' AS observation_name, 37311060
    AS observation_concept_id
    FROM covid_with_ids WHERE case_type = 'suspected'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Contact' AS observation_name, 756077
    AS observation_concept_id
    FROM covid_with_ids WHERE case_type = 'contact'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Confirmed Covid' AS observation_name, 36310513
    AS observation_concept_id
    FROM covid_with_ids WHERE case_type = 'confirmed SAD'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Confirmed Covid' AS observation_name, 36310513
    AS observation_concept_id
    FROM covid_with_ids WHERE case_type = 'confirmed SCTE'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Outbound Traveler' AS observation_name, 0
    AS observation_concept_id
    FROM covid_with_ids WHERE case_type = 'outbound traveler'
    UNION ALL
    SELECT person_id, visit_occurrence_id, CAST(dov AS date) AS observation_date, 'Inbound Traveler' AS observation_name, 0
    AS observation_concept_id
    FROM covid_with_ids WHERE case_type = 'inbound traveler'

)

INSERT INTO "omop_staging".observation
(
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_source_value,
    observation_datetime,
    observation_type_concept_id,
    value_as_number,
    value_as_string,
    value_as_concept_id,
    qualifier_concept_id,
    unit_concept_id,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    observation_source_concept_id,
    unit_source_value,
    qualifier_source_value,
    value_source_value,
    observation_event_id,
    obs_event_field_concept_id
)
SELECT
 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NEXTVAL('omop_staging.observation_id_seq') AS observation_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    person_id,

    observation_concept_id,

    observation_date,

    observation_name AS observation_source_value,

    CAST(NULL AS timestamp) AS observation_datetime,

 -- EHR
    32817 AS observation_type_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    0 AS value_as_number,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS value_as_string,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    0 AS value_as_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS qualifier_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS unit_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS provider_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    visit_occurrence_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS visit_detail_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS observation_source_concept_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    0 AS unit_source_value,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS qualifier_source_value,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS value_source_value,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS observation_event_id,

 -- [!WARNING!] no source column found. See possible comment at the INSERT INTO
    NULL AS obs_event_field_concept_id

FROM unpivoted_observations
;


-- CHECKING result SQL command and excel file filter into marital_status married to check if we have the same count
-- Test 1 Done = 9400
--SELECT COUNT(*) AS "Married" FROM omop_staging.observation
--WHERE observation_source_value='Married'

-- Test 2 done = 7320
--SELECT COUNT(*) AS "Cough" FROM omop_staging.observation
--WHERE observation_source_value='Coughing'

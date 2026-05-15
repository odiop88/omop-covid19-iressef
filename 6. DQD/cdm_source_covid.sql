INSERT INTO omop_staging.cdm_source
(
    cdm_source_name, 
    cdm_source_abbreviation, 
    cdm_holder,
    source_description,
    source_documentation_reference,
    cdm_etl_reference,
    source_release_date,
    cdm_release_date,
    cdm_version,
    cdm_version_concept_id,
    vocabulary_version
)
VALUES ('Covid 19 Surveillance', --Alter this according to your project
		'Covid 19', --Alter this according to your project
		'IRESSEF', --Alter this according to your organization
		NULL, --Do Not change this
		NULL, --Alter this according to your organiztion website or NULL or Github link
        NULL, --Do Not change this
        TO_DATE('2025-08-04', 'YYYY-MM-DD'), --Alter this according to your source release date
        TO_DATE('2025-07-25', 'YYYY-MM-DD'), --Alter this according to your cdm release date. should be a date after source release date
       'v5.4', --Do Not change this
       756265, --Do Not change this
       'v5.0 29-FEB-24' --Alter this according to your vocabulary version
	   );

SELECT * FROM omop_staging.cdm_source;


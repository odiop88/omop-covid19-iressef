-- Ces requetes sont importantes pour pouvoir importer le vocabulaire OMOP dans PostgreSQL

-- TABLE vocabulary
ALTER TABLE omop_staging.vocabulary ALTER COLUMN vocabulary_id TYPE TEXT;
ALTER TABLE omop_staging.vocabulary ALTER COLUMN vocabulary_name TYPE TEXT;
ALTER TABLE omop_staging.vocabulary ALTER COLUMN vocabulary_reference TYPE TEXT;
ALTER TABLE omop_staging.vocabulary ALTER COLUMN vocabulary_version TYPE TEXT;

-- TABLE concept
ALTER TABLE omop_staging.concept ALTER COLUMN concept_name TYPE TEXT;
ALTER TABLE omop_staging.concept ALTER COLUMN concept_code TYPE TEXT;

-- TABLE concept_relationship
ALTER TABLE omop_staging.concept_relationship ALTER COLUMN relationship_id TYPE TEXT;

-- TABLE relationship
ALTER TABLE omop_staging.relationship ALTER COLUMN relationship_id TYPE TEXT;
ALTER TABLE omop_staging.relationship ALTER COLUMN relationship_name TYPE TEXT;

-- TABLE concept_class
ALTER TABLE omop_staging.concept_class ALTER COLUMN concept_class_id TYPE TEXT;
ALTER TABLE omop_staging.concept_class ALTER COLUMN concept_class_name TYPE TEXT;

-- TABLE domain
ALTER TABLE omop_staging.domain ALTER COLUMN domain_id TYPE TEXT;
ALTER TABLE omop_staging.domain ALTER COLUMN domain_name TYPE TEXT;

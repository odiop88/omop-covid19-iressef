-- CONCEPT COPY TO POSTGRESQL
\copy omop_staging.concept FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned/CONCEPT_clean.csv' WITH DELIMITER E'\t' CSV HEADER;

-- VOCABULARY COPY TO POSTGRESQL
\copy omop_staging.vocabulary FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned/VOCABULARY_clean.csv' WITH DELIMITER E'\t' CSV HEADER;

-- RELATIONSHIP COPY TO POSTGRESQL
\copy omop_staging.relationship FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned/RELATIONSHIP_clean.csv' WITH DELIMITER E'\t' CSV HEADER;

-- DOMAIN COPY TO POSTGRESQL
\copy omop_staging.domain FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned/DOMAIN_clean.csv' WITH DELIMITER E'\t' CSV HEADER;

-- CONCEPT_CLASS COPY TO POSTGRESQL
\copy omop_staging.concept_class FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned/CONCEPT_CLASS_clean.csv' WITH DELIMITER E'\t' CSV HEADER;

-- CONCEPT_RELATIONSHIP COPY TO POSTGRESQL
\copy omop_staging.concept_relationship FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned/CONCEPT_RELATIONSHIP_clean.csv' WITH DELIMITER E'\t' CSV HEADER;

-- CONCEPT_ANCESTOR COPY TO POSTGRESQL
\copy omop_staging.concept_ancestor FROM 'C:/Users/Lenovo/OneDrive - IRESSEF/Documents/DSWB/Project/data/DTM/my_omop/docs/vocab/voc/cleaned//CONCEPT_ANCESTOR_clean.csv' WITH DELIMITER E'\t' CSV HEADER;


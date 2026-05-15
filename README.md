# OMOP CDM Standardization of COVID-19 Surveillance Data from Senegal

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20218885.svg)](https://doi.org/10.5281/zenodo.20218885)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This repository contains all Extract–Transform–Load (ETL) materials, semantic mapping specifications, SQL scripts, data quality assessment outputs, and ATLAS characterization results used to convert a heterogeneous multi-source COVID-19 surveillance dataset from Senegal into the **Observational Medical Outcomes Partnership Common Data Model (OMOP CDM) version 5.4**.

This work is described in the following publication:

> Diop O, Odhiambo R, Momanyi R, Ochola M, Diouf O, Diallo AS, et al. Standardizing multi-source COVID-19 surveillance data into the OMOP Common Data Model: a first implementation case study from Senegal. *PLOS ONE*. 2026. *(submitted)*

## Context

During the COVID-19 pandemic, Senegal collected large volumes of health data through national diagnostic and surveillance activities coordinated by public health authorities, research institutes, and authorized laboratories. The source dataset comprised **72 variables** covering sociodemographic characteristics, clinical symptoms, RT-PCR laboratory results, comorbidities, treatments, and outcomes for **13,090 individuals** tested between **March 2020 and April 2022**.

This repository provides a fully documented and reproducible ETL pipeline that transforms these heterogeneous, real-world surveillance data into a standardized OMOP CDM v5.4 database, representing — to our knowledge — the **first fully documented OMOP CDM implementation on COVID-19 surveillance data in Senegal and francophone West Africa**.

## Repository Structure

```
omop-covid19-iressef/
│
├── 1. Scan report/           # WhiteRabbit scan report of the source dataset
│                              # Automated profiling of source variables, data types,
│                              # value distributions, and missingness patterns
│
├── 2. Source Code list/       # Source variable codebook and value dictionaries
│                              # Original French-language variable labels and categories
│                              # used in the COVID-19 surveillance registry
│
├── 3. Usagi concept code list/ # Usagi semi-automated concept mapping outputs
│                              # Mappings from source terms to OMOP standard concepts
│                              # (SNOMED CT, LOINC, RxNorm) with match scores
│
├── 4. Mapping/                # Rabbit-in-a-Hat mapping specifications
│                              # Graphical and tabular documentation of source-to-OMOP
│                              # table and field-level mappings (CDM v5.4)
│
├── 5. SQL scripts/            # SQL loading and transformation scripts
│                              # Scripts for populating OMOP CDM tables in PostgreSQL:
│                              # person, visit_occurrence, measurement,
│                              # condition_occurrence, observation, drug_exposure,
│                              # procedure_occurrence, death, location, care_site,
│                              # observation_period
│
├── 6. DQD/                    # Data Quality Dashboard results
│                              # OHDSI DQD v2.6.1 assessment outputs
│                              # (97% overall pass rate, 98% corrected)
│
├── 7. Atlas/                  # ATLAS characterization outputs
│                              # Descriptive cohort analyses: demographics, symptom
│                              # prevalence, drug exposure patterns, mortality
│
└── LICENSE                    # MIT License
```

## ETL Pipeline Overview

The standardization followed the OHDSI methodological framework:

1. **Profiling** — WhiteRabbit scan of the source flat file to characterize variable distributions, data types, and completeness
2. **Mapping design** — Rabbit-in-a-Hat graphical documentation of source-to-OMOP table mappings
3. **Semantic standardization** — ATHENA vocabulary lookup and Usagi semi-automated concept matching, with manual expert validation of all mappings (SNOMED CT for conditions, LOINC for measurements, RxNorm for drugs)
4. **Transformation** — Python and SQL scripts for data cleaning, normalization, French-to-English translation, and OMOP record generation
5. **Loading** — Bulk insertion into a PostgreSQL database configured with the official OMOP CDM v5.4 schema
6. **Quality assessment** — OHDSI Data Quality Dashboard (conformance, completeness, plausibility) and Achilles automated characterization
7. **Descriptive analysis** — ATLAS platform for cohort exploration and standardized indicator generation

## Key Results

| OMOP Table | Record Count |
|---|---|
| Person | 13,090 |
| Measurement (RT-PCR) | 13,403 |
| Condition Occurrence + Observation | 22,025 |
| Death | 52 |
| DQD Overall Pass Rate | 97% |
| DQD Corrected Pass Rate | 98% |

## Software and Tools

| Tool | Version | Purpose |
|---|---|---|
| [WhiteRabbit](https://ohdsi.github.io/WhiteRabbit/) | — | Source data profiling |
| [Rabbit-in-a-Hat](https://ohdsi.github.io/WhiteRabbit/) | — | ETL mapping design |
| [ATHENA](https://athena.ohdsi.org) | — | OMOP vocabulary repository |
| [Usagi](https://ohdsi.github.io/Usagi/) | — | Semi-automated concept mapping |
| [PostgreSQL](https://www.postgresql.org/) | — | OMOP CDM database |
| [Data Quality Dashboard](https://ohdsi.github.io/DataQualityDashboard/) | 2.6.1 | Data quality assessment |
| [Achilles](https://ohdsi.github.io/Achilles/) | — | Automated data characterization |
| [ATLAS](https://github.com/OHDSI/Atlas) | — | Cohort exploration and analysis |
| Python | 3.x | ETL scripting |
| SQL | — | Data loading and transformation |

## Data Availability

The **source surveillance data** cannot be shared publicly due to ethical and legal restrictions related to Senegalese personal data protection legislation (Loi n° 2008-12 du 25 janvier 2008) and the conditions of approval by the Comité National d'Éthique pour la Recherche en Santé (CNERS) of Senegal. Access requests from qualified researchers may be directed to the Data Management Department, IRESSEF, Dakar, Senegal (contact: ousmane.diop@iressef.org).

All **ETL materials, mapping specifications, SQL scripts, and data quality outputs** are publicly available in this repository under the MIT license to enable methodological reproducibility and reuse.

## How to Cite

If you use or adapt these materials, please cite both the publication and this repository:

**Publication:**
> Diop O, Odhiambo R, Momanyi R, Ochola M, Diouf O, Diallo AS, et al. Standardizing multi-source COVID-19 surveillance data into the OMOP Common Data Model: a first implementation case study from Senegal. *PLOS ONE*. 2026. *(submitted)*

**Repository:**
> Diop O, Odhiambo R, Momanyi R, Ochola M, Diouf O, Diallo AS, et al. OMOP CDM Standardization of COVID-19 Surveillance Data from Senegal — ETL Materials and Scripts (v1.0). Zenodo. 2026. https://doi.org/10.5281/zenodo.20218885

## Ethics

This study was reviewed and approved by the Comité National d'Éthique pour la Recherche en Santé (CNERS) of the Republic of Senegal. All personally identifiable information was removed prior to standardization in accordance with Senegalese Law No. 2008-12 on the Protection of Personal Data.

## Contributing

Contributions, suggestions, and feedback are welcome. If you are implementing OMOP CDM on surveillance data in a similar context (particularly in francophone Africa), we encourage you to open an issue or contact us to explore collaboration opportunities.

## License

This project is licensed under the [MIT License](LICENSE).

## Authors

- **Ousmane Diop** — IRESSEF, Dakar, Senegal *(corresponding author: ousmane.diop@iressef.org)*
- Rachel Odhiambo — APHRC, Nairobi, Kenya
- Reipeinter Momanyi — APHRC, Nairobi, Kenya
- Michael Ochola — APHRC, Nairobi, Kenya
- Ousmane Diouf — IRESSEF, Dakar, Senegal
- Abdoulaye Samba Diallo — IRESSEF, Dakar, Senegal
- Abdou Padane — IRESSEF, Dakar, Senegal
- Agnes Kiragga — APHRC, Nairobi, Kenya
- Moussa Sarr — IRESSEF, Dakar, Senegal
- Souleymane Mboup — IRESSEF, Dakar, Senegal
- Aminata Mboup — IRESSEF, Dakar, Senegal

## Acknowledgments

The team acknowledges with gratitude the support of their respective institutions and the Data Science Without Borders (DSWB) project.

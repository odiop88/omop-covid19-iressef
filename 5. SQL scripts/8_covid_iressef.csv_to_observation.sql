-- Personnes uniques attendues
SELECT 'person' AS table_name, COUNT(DISTINCT national_id) AS expected FROM public.covid;

-- Visites attendues (une par test)
SELECT 'visit_occurrence', COUNT(*) FROM public.covid;

-- Mesures attendues (une par test avec résultat)
SELECT 'measurement',
  COUNT(CASE WHEN test_result IS NOT NULL THEN 1 END)  -- résultat qualitatif
  + COUNT(CASE WHEN axillary_temperature IS NOT NULL THEN 1 END) -- température
  -- + ajouter Ct value si tu l'as intégrée
FROM public.covid;


-- Décès attendus
SELECT 'death', COUNT(*) FROM public.covid WHERE disease_outcome = 'deceased';

-- Symptômes positifs (condition_occurrence) — il faut sommer chaque colonne
SELECT 'condition_occurrence',
  SUM(CASE WHEN headache = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN diarrhea = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN muscle_pain = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN vomiting = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN fever = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN body_aches = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN pain = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN joint_pain = 'yes' THEN 1 ELSE 0 END) +

  SUM(CASE WHEN dyspnea = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN asthma = 'yes' THEN 1 ELSE 0 END)
  -- ajouter les autres symptômes qui vont dans condition_occurrence
FROM public.covid;

-- Observations
SELECT 'observation',
  -- Symptômes domaine Observation
  SUM(CASE WHEN ageusia = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN anosmia = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN anorexia = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN dizziness = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN runny_nose = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN cough = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN sore_throat = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN contact_with_animals = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN traditional_healer_consulted = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN contact_with_case = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN recent_travel = 'yes' THEN 1 ELSE 0 END) +
  -- Variables contextuelles et démographiques
  COUNT(CASE WHEN occupation IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN animal_type_1 IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN animal_type_2 IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN animal_type_3 IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN marital_status IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN clinical_severity IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN case_type IS NOT NULL THEN 1 END) +
  COUNT(CASE WHEN  disease_outcome IS NOT NULL THEN 1 END)
  -- ... ajouter les autres variables que ton ETL charge dans observation
FROM public.covid;


-- Observation_period
SELECT 'observation_period', 
 COUNT(CASE WHEN dov IS NOT NULL THEN 1 END)
 FROM public.covid;

-- Review
-- Traitements (drug_exposure) — même logique
SELECT 'drug_exposure',
  SUM(CASE WHEN cac_1000 = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN perfalgan = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN efferalgan = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN doliprane = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN azicure = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN azithromycin = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN paracetamol = 'yes' THEN 1 ELSE 0 END) +
  SUM(CASE WHEN vitamine_c = 'yes' THEN 1 ELSE 0 END)
  -- ajouter les autres médicaments
FROM public.covid;


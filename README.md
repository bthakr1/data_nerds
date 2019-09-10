# data_nerds
For datadriven competition through HBAP

# Problem description

## Your goal is to predict the binary class heart_disease_present, which represents whether or not a patient has heart disease:


-0 represents no heart disease present

-1 represents heart disease present


***There are 14 columns in the dataset, where the patient_id column is a unique and random identifier.***

The remaining 13 features are described in the section below.

1. slope_of_peak_exercise_st_segment (type: int): the slope of the peak exercise ST segment, an electrocardiography read out indicating quality of blood flow to the heart 
2. thal (type: categorical): results of thallium stress test measuring blood flow to the heart, with possible values normal, fixed_defect, reversible_defect
3. resting_blood_pressure (type: int): resting blood pressure
4. chest_pain_type (type: int): chest pain type (4 values)
5. num_major_vessels (type: int): number of major vessels (0-3) colored by flourosopy
6. fasting_blood_sugar_gt_120_mg_per_dl (type: binary): fasting blood sugar > 120 mg/dl
7. resting_ekg_results (type: int): resting electrocardiographic results (values 0,1,2)
8. serum_cholesterol_mg_per_dl (type: int): serum cholestoral in mg/dl
9. oldpeak_eq_st_depression (type: float): oldpeak = ST depression induced by exercise relative to rest, a measure of abnormality in electrocardiograms
10. sex (type: binary): 0: female, 1: male
11. age (type: int): age in years
12. max_heart_rate_achieved (type: int): maximum heart rate achieved (beats per minute)
13. exercise_induced_angina (type: binary): exercise-induced chest pain (0: False, 1: True)


## Submission format

The format for the submission file is two columns with the patient_id and heart_disease_present. 
This competition uses log loss as its evaluation metric, so the heart_disease_present values you should submit are the probabilities that a patient has heart disease (not the binary label).

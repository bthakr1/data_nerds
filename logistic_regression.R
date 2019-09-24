# Get Libraries
library(curl)
library(data.table)
library(dummies)
library(ggplot2)
library(GGally)
library(dplyr)

# To check the skewness

library(e1071)

# For Tree Model

library(rpart)
library(rpart.plot)

# For correlation plot

library(corrplot)

# For running k nearest neighbor

library(class)



# Get Test Values using data.table

test_values <- fread('https://s3.amazonaws.com/drivendata/data/54/public/test_values.csv')

# Get Train values

train_values <- fread('https://s3.amazonaws.com/drivendata/data/54/public/train_values.csv')

# Get train labels 

train_labels <- fread('https://s3.amazonaws.com/drivendata/data/54/public/train_labels.csv')

# Joining train_labels and train_values for easy analysis 

train <- merge(x = train_labels, y = train_values,by = "patient_id")

# Making Patient ID non existent

train$patient_id <- NULL

# Converting certain integer variables to factors

train$slope_of_peak_exercise_st_segment <- as.factor(train$slope_of_peak_exercise_st_segment)
train$heart_disease_present <- as.factor(train$heart_disease_present)
train$fasting_blood_sugar_gt_120_mg_per_dl <- as.factor(train$fasting_blood_sugar_gt_120_mg_per_dl)
train$sex <- as.factor(train$sex)
train$exercise_induced_angina <- as.factor(train$exercise_induced_angina)
train$chest_pain_type <- as.factor(train$chest_pain_type)
train$num_major_vessels <- as.factor(train$num_major_vessels)
train$resting_ekg_results <- as.factor(train$resting_ekg_results)

# Converting "thal" to factor
# first converting it into normal numeric variable

mapping <- c("normal"=1, "fixed_defect"=2, "reversible_defect"=3)

train$thal_changed <- mapping[train$thal]

train$thal_changed <- as.factor(train$thal_changed)

# Removing original "thal" variable

train$thal <- NULL

# Looking at the histogram of all the continous variables

hist(train$resting_blood_pressure)
hist(train$serum_cholesterol_mg_per_dl)
hist(train$age)
hist(train$oldpeak_eq_st_depression)

# Calculate skew
# if its too away from zero than possible modification
# If skewness value lies above +1 or below -1, data is highly skewed. If it lies between +0.5 to -0.5, 
# it is moderately skewed. If the value is 0, then the data is symmetric

skewness(train$resting_blood_pressure)
skewness(train$serum_cholesterol_mg_per_dl)
skewness(train$age)
skewness(train$oldpeak_eq_st_depression)

# first logistic model 

log_model <- glm(heart_disease_present ~ slope_of_peak_exercise_st_segment + thal_changed + chest_pain_type + 
                   num_major_vessels + resting_ekg_results + oldpeak_eq_st_depression + sex + age + max_heart_rate_achieved + 
                   exercise_induced_angina, data = train, family = "binomial" )

# Making test data useful for prediction
# Same operations on test data 

test <- test_values

# Making Patient ID non existent

test$patient_id <- NULL

# Converting certain integer variables to factors

test$slope_of_peak_exercise_st_segment <- as.factor(test$slope_of_peak_exercise_st_segment)
test$fasting_blood_sugar_gt_120_mg_per_dl <- as.factor(test$fasting_blood_sugar_gt_120_mg_per_dl)
test$sex <- as.factor(test$sex)
test$exercise_induced_angina <- as.factor(test$exercise_induced_angina)
test$chest_pain_type <- as.factor(test$chest_pain_type)
test$num_major_vessels <- as.factor(test$num_major_vessels)
test$resting_ekg_results <- as.factor(test$resting_ekg_results)

# Converting "thal" to factor
# first converting it into normal numeric variable

mapping <- c("normal"=1, "fixed_defect"=2, "reversible_defect"=3)

test$thal_changed <- mapping[test$thal]

test$thal_changed <- as.factor(test$thal_changed)

# Removing original "thal" variable

test$thal <- NULL

# Applying predictions based on the model variables

log_glm_pred <- predict(log_model,newdata = test,type = "response")

# converting to data frame

log_glm_pred <- as.data.frame(log_glm_pred)

# get patient id

test_values_1 <- as.data.frame(test_values[,1])

# convert to data frame

prediction_made <- cbind(test_values_1,log_glm_pred)

# adding interaction effect of oldpeak and chest pain to log_model

log_model2<-glm(heart_disease_present~exercise_induced_angina+sex+thal_changed+chest_pain_type+oldpeak_eq_st_depression+num_major_vessels+exercise_induced_angina:oldpeak_eq_st_depression+thal_changed:chest_pain_type+chest_pain_type:oldpeak_eq_st_depression,train,family = "binomial")
step(log_model2)
summary(log_model2)



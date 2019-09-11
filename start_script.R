# Get Libraries
library(curl)
library(data.table)
library(dummies)
library(ggplot2)

# Get Test Values using data.table

test_values <- fread('https://s3.amazonaws.com/drivendata/data/54/public/test_values.csv')

# Get Train values

train_values <- fread('https://s3.amazonaws.com/drivendata/data/54/public/train_values.csv')

# Get train labels 

train_labels <- fread('https://s3.amazonaws.com/drivendata/data/54/public/train_labels.csv')

# Joining train_labels and train_values for easy analysis 

train <- merge(x = train_labels, y = train_values,by = "patient_id")

# Converting integer to factor where needed

train$heart_disease_present <- as.factor(train$heart_disease_present)
train$fasting_blood_sugar_gt_120_mg_per_dl <- as.factor(train$fasting_blood_sugar_gt_120_mg_per_dl)
train$sex <- as.factor(train$sex)
train$exercise_induced_angina <- as.factor(train$exercise_induced_angina)

# Creating dummy variable for "thal"
# Not done where the number of factors are less than 3 or precisely 2

train_1 <- dummy.data.frame(train,names = c('thal'),sep="_")

# Change the data set name

train <- train_1

# Histogram of various variables or features

# Resting Blood Pressure

hist(train$resting_blood_pressure, xlab = "Resting Blood Pressure", main = 'Resting Blood Pressure', 
     probability = TRUE, labels = TRUE)

# Serum Cholestrol

hist(train$serum_cholesterol_mg_per_dl, xlab = "Serum Cholestrol", main = 'Serum Cholestrol', 
     probability = TRUE, labels = TRUE)

# Age 

hist(train$age, xlab = "Age", main = 'Histogram of Age', probability = TRUE, labels = TRUE)

# Max heart rate achieved

hist(train$max_heart_rate_achieved, xlab = "Heart Rate", main = 'Histogram of Main Heart Achieved', 
     probability = TRUE, labels = TRUE)

# Old Peak Depression

hist(train$oldpeak_eq_st_depression, xlab = "Old Peak Depression", main = 'Histogram of Old Peak Depression', 
     probability = TRUE, labels = TRUE)

# Now to barplots
# Starting with whether heart disease present or not

ggplot(data = train, aes(x=train$heart_disease_present)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Heart Disease Present")

# Quality of Blood Flow to heart

ggplot(data = train, aes(x=train$slope_of_peak_exercise_st_segment)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Quality of Blood Flow to Heart")

# Chest Pain Type

ggplot(data = train, aes(x=train$chest_pain_type)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Chest Pain Type")

# Number of Major Blood Vessels

ggplot(data = train, aes(x=train$num_major_vessels)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Number of Major Blood Vessels")

# Fasting Blood Sugar greater than 120mg/dl

ggplot(data = train, aes(x=train$fasting_blood_sugar_gt_120_mg_per_dl)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1)
+ xlab("Fasting Blood Sugar greater than 120mg/dl")

# Resting EKG Result (0,1,2)

ggplot(data = train, aes(x=train$resting_ekg_results)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Resting electrocardiographic result")

# Distribution of Sex (0: Female , 1 :Male)

ggplot(data = train, aes(x=train$sex)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Distribution of Sex")

# Exercise Induced Pain 
# 0 : false, 1 : True

ggplot(data = train, aes(x=train$exercise_induced_angina)) + geom_bar() 
+ geom_text(stat = 'count', aes(label=..count..), vjust=-1) 
+ xlab("Distribution of Exercise Induce Pain where 0 : False and 1 : True")

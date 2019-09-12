# Get Libraries
library(curl)
library(data.table)
library(dummies)
library(ggplot2)
library(GGally)

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

# Identifying relationship between Heart Disease and all the continous features
# The continous features are on Y Axis

# Resting Blood Pressure

ggplot(data = train, aes(x=heart_disease_present,y=resting_blood_pressure)) + geom_boxplot() 
+ scale_x_discrete(name='Heart Disease Present') 
+ scale_y_continuous(name='Resting Blood Pressure') + ggtitle("Boxplot of Heart Disease Present by Resting Blood Pressure")

# Maximum Heart Rate Achieved

ggplot(data = train, aes(x=heart_disease_present,y=max_heart_rate_achieved)) + geom_boxplot() 
+ scale_x_discrete(name='Heart Disease Present') + scale_y_continuous(name='Maximum Heart Rate Achieved') 
+ ggtitle("Boxplot of Heart Disease Present by Max Heart Rate Achieved")

# By looking at the boxplot we can see that heart rate achieved is higher when heart diseases is 0 i.e. None

# Age

ggplot(data = train, aes(x=heart_disease_present,y=age)) + geom_boxplot() 
+ scale_x_discrete(name='Heart Disease Present') + scale_y_continuous(name='Age') 
+ ggtitle("Boxplot of Heart Disease Present by Age")

# Similar for age , with age higher the chances of heart attack is higher

# Serum Cholestrol present

ggplot(data = train, aes(x=heart_disease_present,y=serum_cholesterol_mg_per_dl)) + geom_boxplot() 
+ scale_x_discrete(name='Heart Disease Present') + scale_y_continuous(name='Serum Cholestrol') 
+ ggtitle("Boxplot of Heart Disease Present by Serum Cholestrol")

# Getting the relationship between all the continous factors

train_cont <- subset(train,select = c('resting_blood_pressure','serum_cholesterol_mg_per_dl','oldpeak_eq_st_depression',
                                      'age','max_heart_rate_achieved'))

ggpairs(train_cont)

# Converting all "thal" variables to factors

train$thal_fixed_defect <- as.factor(train$thal_fixed_defect)
train$thal_normal <- as.factor(train$thal_normal)
train$thal_reversible_defect <- as.factor(train$thal_reversible_defect)

# Finding all factor variables

train_factor_variables <- names(Filter(is.factor,train))

# Train dataset with factors only 
# To be used for t test later

train_factors_only <- train[train_factor_variables]

# Identify relationship between two factorial variables
# Chi Square Test

# Between Heart Disease and thal_fixed_defect

chisq.test(table(train_factors_only$heart_disease_present,train_factors_only$thal_fixed_defect),correct = F)

# p-value is 0.7463 hence we fail to reject null hypothesis and assume that relationship is by chance only

# Between Heart Disease and thal_normal

chisq.test(table(train_factors_only$heart_disease_present,train_factors_only$thal_normal),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship

# Between Heart Disease and thal_reversible effect

chisq.test(table(train_factors_only$heart_disease_present,train_factors_only$thal_reversible_defect),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship

# Between Heart Disease and Fasting blood sugar level

chisq.test(table(train_factors_only$heart_disease_present,train_factors_only$fasting_blood_sugar_gt_120_mg_per_dl),correct = F)

# p-value is 0.9638 hence we fail to reject null hypothesis and assume that relationship is by chance only

# Between Heart disease and Sex

chisq.test(table(train_factors_only$heart_disease_present,train_factors_only$sex),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship

# Between Heart Disease and Exercise Induced Pain

chisq.test(table(train_factors_only$heart_disease_present,train_factors_only$exercise_induced_angina),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship

# Forgot to bring more variables as factors

train$slope_of_peak_exercise_st_segment <- as.factor(train$slope_of_peak_exercise_st_segment)

train$chest_pain_type <- as.factor(train$chest_pain_type)

train$resting_ekg_results <- as.factor(train$resting_ekg_results)

# Between Heart Disease and Slope of Peak Exercise Segment

chisq.test(table(train$heart_disease_present,train$slope_of_peak_exercise_st_segment),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship

# Between Heart Disease and Chest Pain Type

chisq.test(table(train$heart_disease_present,train$chest_pain_type),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship

# Between Heart Disease and Resting EKG Result

chisq.test(table(train$heart_disease_present,train$resting_ekg_results),correct = F)

# p-value is very small and hence reject null hypothesis , there might be some relationship




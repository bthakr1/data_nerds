# Get Libraries
library(curl)
library(data.table)
library(dummies)
library(ggplot2)
library(GGally)
library(dplyr)

# For Tree Model

library(rpart)
library(rpart.plot)

# For correlation plot

library(corrplot)


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

hist(train$resting_blood_pressure, xlab = "Resting Blood Pressure", main = 'Resting Blood Pressure', probability = TRUE, labels = TRUE)

# Serum Cholestrol

hist(train$serum_cholesterol_mg_per_dl, xlab = "Serum Cholestrol", main = 'Serum Cholestrol', probability = TRUE, labels = TRUE)

# Age 

hist(train$age, xlab = "Age", main = 'Histogram of Age', probability = TRUE, labels = TRUE)

# Max heart rate achieved

hist(train$max_heart_rate_achieved, xlab = "Heart Rate", main = 'Histogram of Main Heart Achieved',probability = TRUE, labels = TRUE)

# Old Peak Depression

hist(train$oldpeak_eq_st_depression, xlab = "Old Peak Depression", main = 'Histogram of Old Peak Depression', probability = TRUE, labels = TRUE)

# Now to barplots
# Starting with whether heart disease present or not

ggplot(data = train, aes(x=train$heart_disease_present)) + geom_bar() + 
  geom_text(stat = 'count', aes(label=..count..), vjust=-1) + xlab("Heart Disease Present")

# Quality of Blood Flow to heart

ggplot(data = train, aes(x=train$slope_of_peak_exercise_st_segment)) + geom_bar() + geom_text(stat = 'count', aes(label=..count..), vjust=-1) + 
  xlab("Quality of Blood Flow to Heart")

# Chest Pain Type

ggplot(data = train, aes(x=train$chest_pain_type)) + geom_bar() + geom_text(stat = 'count', aes(label=..count..), vjust=-1) + xlab("Chest Pain Type")

# Number of Major Blood Vessels

ggplot(data = train, aes(x=train$num_major_vessels)) + geom_bar() + 
  geom_text(stat = 'count', aes(label=..count..), vjust=-1) + 
  xlab("Number of Major Blood Vessels")

# Fasting Blood Sugar greater than 120mg/dl

ggplot(data = train, aes(x=train$fasting_blood_sugar_gt_120_mg_per_dl)) + geom_bar() + 
  geom_text(stat = 'count', aes(label=..count..), vjust=-1) + 
  xlab("Fasting Blood Sugar greater than 120mg/dl")

# Resting EKG Result (0,1,2)

ggplot(data = train, aes(x=train$resting_ekg_results)) + geom_bar() + geom_text(stat = 'count', aes(label=..count..), vjust=-1) + 
  xlab("Resting electrocardiographic result")

# Distribution of Sex (0: Female , 1 :Male)

ggplot(data = train, aes(x=train$sex)) + geom_bar() + geom_text(stat = 'count', aes(label=..count..), vjust=-1) + 
  xlab("Distribution of Sex")

# Exercise Induced Pain 
# 0 : false, 1 : True

ggplot(data = train, aes(x=train$exercise_induced_angina)) + geom_bar() + geom_text(stat = 'count', aes(label=..count..), vjust=-1) + 
  xlab("Distribution of Exercise Induce Pain where 0 : False and 1 : True")

# Identifying relationship between Heart Disease and all the continous features
# The continous features are on Y Axis

# Resting Blood Pressure

ggplot(data = train, aes(x=heart_disease_present,y=resting_blood_pressure)) + geom_boxplot() + 
  scale_x_discrete(name='Heart Disease Present') + 
  scale_y_continuous(name='Resting Blood Pressure') + ggtitle("Boxplot of Heart Disease Present by Resting Blood Pressure")

# Maximum Heart Rate Achieved

ggplot(data = train, aes(x=heart_disease_present,y=max_heart_rate_achieved)) + geom_boxplot() + 
  scale_x_discrete(name='Heart Disease Present') + 
  scale_y_continuous(name='Maximum Heart Rate Achieved') + ggtitle("Boxplot of Heart Disease Present by Max Heart Rate Achieved")

# By looking at the boxplot we can see that heart rate achieved is higher when heart diseases is 0 i.e. None

# Age

ggplot(data = train, aes(x=heart_disease_present,y=age)) + geom_boxplot() + 
  scale_x_discrete(name='Heart Disease Present') + scale_y_continuous(name='Age') + ggtitle("Boxplot of Heart Disease Present by Age")

# Similar for age , with age higher the chances of heart attack is higher

# Serum Cholestrol present

ggplot(data = train, aes(x=heart_disease_present,y=serum_cholesterol_mg_per_dl)) + geom_boxplot() + 
  scale_x_discrete(name='Heart Disease Present') + scale_y_continuous(name='Serum Cholestrol') + 
  ggtitle("Boxplot of Heart Disease Present by Serum Cholestrol")

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


# Tree Model

tree_model <- rpart(heart_disease_present ~ slope_of_peak_exercise_st_segment + thal_fixed_defect + thal_normal + thal_reversible_defect + resting_blood_pressure + chest_pain_type + num_major_vessels + fasting_blood_sugar_gt_120_mg_per_dl + resting_ekg_results + serum_cholesterol_mg_per_dl +  serum_cholesterol_mg_per_dl + oldpeak_eq_st_depression + sex + age + max_heart_rate_achieved + exercise_induced_angina, data = train, method = "class")

# seems like Thal_normal is highly important based on variable importance

tree_model <- rpart(heart_disease_present ~ slope_of_peak_exercise_st_segment + thal_fixed_defect + thal_reversible_defect + resting_blood_pressure + chest_pain_type + num_major_vessels + fasting_blood_sugar_gt_120_mg_per_dl + resting_ekg_results + serum_cholesterol_mg_per_dl +  serum_cholesterol_mg_per_dl + oldpeak_eq_st_depression + sex + age + max_heart_rate_achieved + exercise_induced_angina, data = train, method = "class")

prp(tree_model)

# Logistic Model

logit_model <- glm(heart_disease_present ~ slope_of_peak_exercise_st_segment + thal_fixed_defect + thal_normal + thal_reversible_defect + resting_blood_pressure + chest_pain_type + num_major_vessels + fasting_blood_sugar_gt_120_mg_per_dl + resting_ekg_results + serum_cholesterol_mg_per_dl +  serum_cholesterol_mg_per_dl + oldpeak_eq_st_depression + sex + age + max_heart_rate_achieved + exercise_induced_angina, data = train, family = binomial(link = 'logit'))

# Adding the "Thal" variable again from the "train_values" dataframe

train_values_1 <- train_values[,c(1,3)]

# Merging the files i.e. train_values_1 and train

train_2 <- merge(train,train_values_1,by = 'patient_id')

# Renaming train_2 to train again

train <- train_2

# Converting thal to categorical. For some reason it did not come as categorical while merging

train$thal <- as.factor(train$thal)

# changing "thal" alpha to numeric

mapping <- c("normal"=1, "fixed_defect"=2, "reversible_defect"=3)

train$Thal_changed <- mapping[train$thal]

train$Thal_changed <- as.factor(train$Thal_changed)

# Apllying k-Nearest Neighbour Classification
# We will break the "train" data into again training and testing

# First remove the "thal" and "Thal_changed" variables

train_k_nearest <- train[,c(2:17)]

# Create normalized function for numeric data only

train_k_normalized <- train_k_nearest %>% mutate_each_(list(~scale(.) %>% as.vector),
                                                            vars = c("resting_blood_pressure","serum_cholesterol_mg_per_dl","oldpeak_eq_st_depression","age","max_heart_rate_achieved"))

# Creating 90 % of data for training and rest for testing

ran <- sample(1:nrow(train_k_normalized), 0.9 * nrow(train_k_normalized))

# Generating training data

k_train <- train_k_normalized[ran,]

# Generating testing data

k_test <- train_k_normalized[-ran,]

# Generating category for both training and testing

k_train_category <- train_k_normalized[ran,1]
k_Test_category <- train_k_normalized[-ran,1]

# Removing the target variable from k_train and k_test

k_train$heart_disease_present <- NULL
k_test$heart_disease_present <- NULL

# Running k nearest neighbor

library(class)

# K as 13 is approximate square root of 162 i.e. the number of obs in training data

pr <- knn(k_train,k_test,cl = k_train_category,k=20)

tab <- table(pr,k_Test_category)

tab 

accuracy <- function(x){sum(diag(x)/sum(rowSums(x)))*100}

accuracy(tab)

# Tessting the k nearest neighbor on test data
# First treating the test values with same methods as train

# Converting integer to factor where needed

test_values$fasting_blood_sugar_gt_120_mg_per_dl <- as.factor(test_values$fasting_blood_sugar_gt_120_mg_per_dl)
test_values$sex <- as.factor(test_values$sex)
test_values$exercise_induced_angina <- as.factor(test_values$exercise_induced_angina)

 # changing "thal" to dummy variables by one hot coding

test_values_1 <- dummy.data.frame(test_values,names = c('thal'),sep="_")

test_values <- test_values_1

# Removing patient_id

test_values <- test_values[,c(2:16)]

# normalizing the columns in test_values df

test_values_normalized <- test_values %>% mutate_each_(list(~scale(.) %>% as.vector),
                                                       vars = c("resting_blood_pressure","serum_cholesterol_mg_per_dl","oldpeak_eq_st_depression","age","max_heart_rate_achieved"))

# Running the k nearest neighbor on true test values

pr <- knn(k_train,test_values_normalized,cl = k_train_category,k=20)

# Not sure if we can use K nearest neighbor since "log loss" is not available in kNN

# Using logistic regression again with normalized variable
# we will use the "train_k_normalized" data

# Getting correlation plot (only for numerical variables)

correlation <- cor(train_k_normalized[,c(names(dplyr::select_if(train_k_normalized,is.numeric)))])

corrplot(correlation,method = "circle")

# Creating train and test dataset

log_train <- train_k_normalized[ran,]

log_test <- train_k_normalized[-ran,]

# first tiny model

glm.fit <- glm(heart_disease_present ~ slope_of_peak_exercise_st_segment + age + sex  , data = log_train, family = binomial)

# look at the summary

summary(glm.fit)

# predict on the test data

glm.probs <- predict(glm.fit, newdata = log_test[,2:16], type = "response")

# convert to 0 and 1 to see the accuracy

glm.pred <- ifelse(glm.probs>0.5,1,0)

table(glm.pred,log_test[,1])

# using AIC to select the most important model

glm.fit.step <- glm(heart_disease_present ~ . , data = log_train, family = binomial)

glm.fit.step.1 <- step(glm.fit.step)

summary(glm.fit.step.1)

glm.fit.step.1$anova














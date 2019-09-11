# Get Libraries
library(curl)
library(data.table)
library(dummies)

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

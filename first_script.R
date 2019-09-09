# Get Libraries
library(curl)
library(data.table)

# Get Test Values using data.table

test_values <- fread('https://s3.amazonaws.com/drivendata/data/54/public/test_values.csv')
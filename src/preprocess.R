
library(tidyverse)

data <- read_csv("./data/kc_house_data.csv") %>%
  select(price, bedrooms, bathrooms, sqft_living, grade, zipcode) %>%
  drop_na() %>%
  mutate(zipcode = as.factor(zipcode))

# Standardize numeric predictors
data <- data %>%
  mutate(across(c(bedrooms, bathrooms, sqft_living, grade), scale))

saveRDS(data, file = "data/processed_data.rds")

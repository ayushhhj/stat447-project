library(tidyverse)
library(GGally)

data <- read_csv("./data/kc_house_data.csv") %>%
  drop_na() %>%
  mutate(zipcode = as.factor(zipcode))

numeric_data <- data %>%
  select(
    price,
    bedrooms,
    bathrooms,
    sqft_living,
    sqft_above,
    sqft_basement,
    grade,
    view,
    condition,
    yr_built
  ) %>%
  mutate(across(everything(), as.numeric))

ggpairs(
  numeric_data,
  title = "Pairwise Scatterplot Matrix of Selected Housing Features",
  upper = list(continuous = wrap("cor", size = 3))
)

ggplot(data, aes(x = reorder(zipcode, price, FUN = median), y = price)) +
  geom_boxplot(outlier.shape = NA, fill = "skyblue", alpha = 0.6) +
  coord_flip() +
  labs(title = "Distribution of House Prices by Zip Code",
       x = "Zip Code", y = "Price")

data <- data %>%
  mutate(across(c(sqft_living, grade, bathrooms), scale))

saveRDS(data, file = "data/processed_data.rds")
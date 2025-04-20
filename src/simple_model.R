
library(rstan)
data <- readRDS("data/processed_data.rds")

X <- model.matrix(~ bathrooms + sqft_living + grade, data)[, -1]
y <- data$price

stan_data <- list(
  N = nrow(X),
  K = ncol(X),
  X = X,
  y = y
)

fit_simple <- stan(
  file = "stan/simple_model.stan",
  data = stan_data,
  iter = 1000,
  chains = 3,
  seed = 123
)

#print(fit_simple)
saveRDS(fit_simple, "results/fit_simple.rds")

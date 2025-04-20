
library(rstan)
data <- readRDS("data/processed_data.rds")

X <- model.matrix(~ bedrooms + bathrooms + sqft_living + grade, data)[, -1]
y <- data$price
zip <- as.integer(data$zipcode)
J <- length(unique(zip))

stan_data_hier <- list(
  N = nrow(X),
  K = ncol(X),
  X = X,
  y = y,
  zip = zip,
  J = J
)

fit_hier <- stan(
  file = "stan/hierarchical_model.stan",
  data = stan_data_hier,
  iter = 2000,
  chains = 4,
  seed = 123
)

#print(fit_hier)
saveRDS(fit_hier, "results/fit_hierarchical.rds")

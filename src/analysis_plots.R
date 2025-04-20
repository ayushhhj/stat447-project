library(bayesplot)
library(rstan)
library(loo)

fit_simple <- readRDS("results/fit_simple.rds")
fit_hier <- readRDS("results/fit_hierarchical.rds")

fit_simple_array <- as.array(fit_simple)
fit_hier_array <- as.array(fit_hier)

# Traceplots
mcmc_trace(fit_simple_array, pars = c("beta[1]", "alpha", "sigma"))
mcmc_trace(fit_hier_array, pars = c("beta[1]", "mu_alpha", "sigma_alpha", "sigma"))

# Posterior predictive checks
y_pred_simple <- extract(fit_simple)$y_pred
y_pred_hier <- extract(fit_hier)$y_pred
y_obs <- readRDS("data/processed_data.rds")$price

ppc_dens_overlay(y_obs, y_pred_simple[1:100, ])
ppc_dens_overlay(y_obs, y_pred_hier[1:100, ])

mcmc_rank_hist(fit_simple_array, pars = c("beta[1]", "alpha", "sigma")) + 
  ggtitle("MCMC Rank Hist: Simple Model")

mcmc_rank_hist(fit_hier_array, pars = c("beta[1]", "mu_alpha", "sigma_alpha", "sigma")) + 
  ggtitle("MCMC Rank Hist: Hierarchical Model")

# LOO comparison
log_lik_simple <- extract_log_lik(fit_simple)
log_lik_hier <- extract_log_lik(fit_hier)

loo_simple <- loo(log_lik_simple)
loo_hier <- loo(log_lik_hier)

print(compare(loo_simple, loo_hier))

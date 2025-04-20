data {
  int<lower=0> N;
  int<lower=0> K;
  int<lower=1> J;
  int<lower=1,upper=J> zip[N];
  matrix[N, K] X;
  vector[N] y;
}

parameters {
  vector[K] beta;
  vector[J] z_alpha;               
  real mu_alpha;
  real<lower=0> sigma_alpha;
  real<lower=0> sigma;
}

transformed parameters {
  vector[J] alpha_zip;
  alpha_zip = mu_alpha + sigma_alpha * z_alpha;
}

model {
  // Priors
  beta ~ normal(0, 2);
  mu_alpha ~ normal(0, 2);
  sigma_alpha ~ exponential(1);
  sigma ~ exponential(1);

  // Non-centered prior
  z_alpha ~ normal(0, 1);

  // Likelihood
  y ~ normal(X * beta + alpha_zip[zip], sigma);
}

generated quantities {
  vector[N] y_pred;
  vector[N] log_lik;

  for (n in 1:N) {
    y_pred[n] = normal_rng(alpha_zip[zip[n]] + X[n] * beta, sigma);
    log_lik[n] = normal_lpdf(y[n] | alpha_zip[zip[n]] + X[n] * beta, sigma);
  }
}


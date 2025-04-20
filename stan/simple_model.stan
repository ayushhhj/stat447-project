
data {
  int<lower=0> N;
  int<lower=0> K;
  matrix[N, K] X;
  vector[N] y;
}
parameters {
  vector[K] beta;
  real alpha;
  real<lower=0> sigma;
}
model {
  beta ~ normal(0, 5); 
  alpha ~ normal(0, 5);
  sigma ~ cauchy(0, 2.5);
  y ~ normal(X * beta + alpha, sigma);
}
generated quantities {
  vector[N] y_pred;
  vector[N] log_lik;

  for (n in 1:N) {
    y_pred[n] = normal_rng(alpha + X[n] * beta, sigma);
    log_lik[n] = normal_lpdf(y[n] | alpha + X[n] * beta, sigma);
  }
}

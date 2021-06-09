// Stan model for simple total flowers regression

data {
  int <lower = 1> N_germ; // number of observations
  int y_germ2[N_germ]; // number of flowers produced in year t (natural number)
  int<lower=1> trials_germ2[N_germ]; // plot
}
parameters {
  real < lower = 1> phi;
  real beta0; //intercept
  real beta1;
  real < lower = 0 > sigma; // Error SD
  real <lower = 0> N;
}
transformed parameters{
  vector[N_germ] mu; //linear predictor for the mean
  for(i in 1:N_germ){
   	mu[i] = beta0;
  }
}
model {
  // Model
  beta0 ~ normal(0,100); // intercept distribution
  for(i in 1:N_germ){
    y_germ2[i] ~ binomial_logit(trials_germ2[i], (mu[i]));
  }
}
generated quantities {
  int<lower = 0> y_rep[N_germ] = binomial_rng(trials_germ2, inv_logit(mu));
  real<lower = 0> mean_y_rep = mean(to_vector(y_rep));
  real<lower = 0> sd_y_rep = sd(to_vector(y_rep));
} 


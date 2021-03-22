// Stan model for simple total flowers regression
data {
 int < lower = 1 > N_flower; // Sample size
 int <lower = 0> good[N_flower]; // Number of viable seeds
 int <lower = 1> N_ant; // number of ant states
 int <lower = 1, upper = N_ant> ant_flower[N_flower]; // the list of ant species 
 int<lower=0> tot[N_flower]; // number of trials
 int<lower=0> abort[N_flower];
 vector[N_flower] vol_flower;	//size_t
 int<lower=1> N_Year; //number of plots
  int<lower=1> N_Plot; //number of years
  int<lower=1, upper=N_Plot> plot_flower[N_flower]; // plot
  int<lower=1, upper=N_Year> year_flower[N_flower]; // year
}
parameters {
  real <lower = 0, upper = 1> beta0[N_ant]; // probability of viability for each bud
  real <lower = 0, upper = 1> beta1[N_ant]; // probability of viability for each bud

  //
  vector[N_Plot] u; //subject intercepts
  vector[N_Year] w; //item intercepts
  real < lower = 0 > sigma; // Error SD
  real < lower = 0 > sigma_u; // plot SD
  real < lower = 0 > sigma_w; // year SD
}
transformed parameters{
  real<lower=0> mu[N_flower]; // proportion viable for each plant?
  // Prediction for seed viability
  for(i in 1:N_flower){
    mu[i] = beta0[ant_flower[i]]; //+ beta1[ant_flower[i]] * vol_flower[i];
  }
}
model {
 // Priors
  beta0 ~ normal(0,100); // intercept distribution
  beta1 ~ normal(0,100); // intercept distribution
  //Model Statements
  u ~ normal(0, sigma_u); // plot random effects
  w ~ normal(0, sigma_w); // year random effects
  
  good ~ binomial_logit(tot, mu);
}
generated quantities {
  int<lower = 0> y_rep[N_flower] = binomial_logit_rng(tot,mu);
  real<lower = 0> mean_y_rep = mean(to_vector(y_rep));
  real<lower = 0> sd_y_rep = sd(to_vector(y_rep));
}


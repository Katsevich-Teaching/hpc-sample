# Compute the training and test errors of a natural cubic spline fit with k 
# degrees of freedom, where k is passed as a command-line argument.

# load libraries
library(tibble)
library(splines)

# read the number of degrees of freedom from the command line
k <- as.integer(commandArgs(trailingOnly = TRUE)[1])

# set the problem parameters
f <- function(x) sin(3 * x)            # underlying function
n <- 50                                # training sample size
N <- 500                               # test sample size
sigma <- 1                             # noise level
B <- 10000                             # number of repetitions

# set the random seed for reproducibility
set.seed(1)

# generate the test data
test_data <- tibble(
  x = seq(0, 2 * pi, length.out = N),
  y = f(x) + rnorm(N, sd = sigma)
)

# loop over the number of repetitions
train_errors <- vector("double", length = B)
test_errors <- vector("double", length = B)
for (b in seq_len(B)) {
  # print progress
  if(b %% 100 == 0) cat(sprintf("Working on b = %d of %d...\n", b, B))
  
  # generate the training data
  train_data <- tibble(
    x = seq(0, 2 * pi, length.out = n),
    y = f(x) + rnorm(n, sd = sigma)
  )
  
  # fit the natural cubic spline
  spline_fit <- lm(y ~ ns(x, df = k), data = train_data)
  
  # compute the training and test errors
  train_errors[b] <- mean((train_data$y - predict(spline_fit))^2)
  test_errors[b] <- mean((test_data$y - predict(spline_fit, test_data))^2)
}

# get the mean training and test errors
mean_train_error <- mean(train_errors)
mean_test_error <- mean(test_errors)

# create a data frame with the results
results <- tibble(
  df = k,
  mean_train_error = mean_train_error,
  mean_test_error = mean_test_error
)

# write the results to disk
if(!dir.exists("results")) dir.create("results")
saveRDS(results, sprintf("results/results_%d.rds", k))
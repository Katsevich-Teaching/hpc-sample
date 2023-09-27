# Collect the simulation results into a single file.

# load libraries
library(dplyr)

# read each of the files into a single tibble
results <- list.files("results", full.names = TRUE) |>
  lapply(readRDS) |>
  bind_rows()

# save merged results to disk
saveRDS(results, "sim_results.rds")

# remove the individual files
file.remove(list.files("results", full.names = TRUE))
file.remove("results")
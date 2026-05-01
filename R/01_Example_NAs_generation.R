#R version 4.3.1 (2023-06-16 ucrt) -- "Beagle Scouts"
#Copyright (C) 2023 The R Foundation for Statistical Computing
#Platform: x86_64-w64-mingw32/x64 (64-bit)


# =============================================================================
# 1. Generate NAs for method evaluation
# =============================================================================

dataset <- read.csv("data/example/example_complete.csv", 
                    check.names = FALSE, sep = ";")

# Separate variables (exclude SAMPLE and Group)
vars <- dataset[, -c(1, 2)]

# Function to introduce missing values
introduce_missing <- function(data, percentage) {
  mat <- as.matrix(data)
  n_missing <- round(length(mat) * percentage / 100)
  positions <- sample(1:length(mat), n_missing)
  mat[positions] <- NA
  as.data.frame(mat)
}

# Generate datasets with 5, 10, 20 and 30% missing values
set.seed(123)  # for reproducibility
vars_10 <- introduce_missing(vars, 10)
vars_20 <- introduce_missing(vars, 20)
vars_30 <- introduce_missing(vars, 30)

# Add SAMPLE and Group back
dataset_10 <- cbind(dataset[, c(1,2)], vars_10)
dataset_20 <- cbind(dataset[, c(1,2)], vars_20)
dataset_30 <- cbind(dataset[, c(1,2)], vars_30)

# Export
write.csv(dataset_10, "data/example/example_missing_10.csv", row.names = FALSE)
write.csv(dataset_20, "data/example/example_missing_20.csv", row.names = FALSE)
write.csv(dataset_30, "data/example/example_missing_30.csv", row.names = FALSE)
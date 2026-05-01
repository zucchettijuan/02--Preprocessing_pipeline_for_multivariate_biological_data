#R version 4.3.1 (2023-06-16 ucrt) -- "Beagle Scouts"
#Copyright (C) 2023 The R Foundation for Statistical Computing
#Platform: x86_64-w64-mingw32/x64 (64-bit)


# =============================================================================
# 1. Load and prepare data
# =============================================================================

library(tidyverse)

#Upload data

dataset_complete <- read.csv("data/example/example_complete.csv", check.names = FALSE, sep=";") 
dataset_imputed <- read.csv("outputs/processed/dataset_imputed_20_MCAR.csv", check.names = FALSE)
dataset_missing <- read.csv("data/example/example_missing_20.csv", check.names = FALSE)
variables <- colnames(dataset_complete[, -c(1,2)])

# =============================================================================
# 2. Identify imputed positions
# =============================================================================

na_positions <- is.na(dataset_missing[, variables])

real_values <- as.matrix(dataset_complete[, variables])[na_positions]
imputed_values <- as.matrix(dataset_imputed[, variables])[na_positions]

# =============================================================================
# 3. Validation and error measurement
# =============================================================================

RMSE <- function(real, imputed){
  data <- as.data.frame(cbind(real,imputed))
  data <- data %>%  mutate(SE=((real-imputed)**2))
  n <- length(data$real)
  sum <- sum(data$SE)
  rmse <- sqrt(sum/n)
  return(rmse)
}

data_plot <- data.frame(real = real_values, imputed = imputed_values)
rmse <- RMSE(real_values,
             imputed_values)
rmse_relativo <- rmse / sd(real_values)
correlation <- cor(imputed_values,real_values)

# =============================================================================
# 4. Visual representation
# =============================================================================

ggplot(data_plot, aes(x = imputed, y = real)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  annotate("text", x = min(imputed_values), y = max(real_values),
           label = paste("r =", round(correlation, 2)),
           hjust = 0) +
  annotate("text", x = min(imputed_values), y = max(real_values) * 0.9,
           label = paste("RMSE =", round(rmse, 2)),
           hjust = 0) +
  annotate("text", x = min(imputed_values), y = max(real_values) * 0.8,
           label = paste("relative RMSE =", round(rmse_relativo, 2)),
           hjust = 0)


#R version 4.3.1 (2023-06-16 ucrt) -- "Beagle Scouts"
#Copyright (C) 2023 The R Foundation for Statistical Computing
#Platform: x86_64-w64-mingw32/x64 (64-bit)


# =============================================================================
# 1. Load and prepare data
# =============================================================================

library(tidyverse)

data_imputed <- read.csv("outputs/processed/dataset_imputed_10_MCAR.csv", check.names = FALSE)
variables <- colnames(data_imputed[, -c(1,2)])


# =============================================================================
# 2. Data normalization
# =============================================================================

dataset_transformed <- data_imputed
dataset_transformed[,variables] <- sqrt(data_imputed[,variables])


# =============================================================================
# 3. Data scaling
# =============================================================================

dataset_scale <- dataset_transformed
dataset_scale[,variables] <- scale(dataset_transformed[,variables])


# =============================================================================
# 4. distribution visualization
# =============================================================================

data_long <- dataset_scale[, variables] %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value")

png("outputs/figures/distribution_plot.png", width = 800, height = 600, res = 120)
ggplot(data_long, aes(x = value)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30) +
  geom_density(color = "blue", linewidth = 1)
dev.off()

# =============================================================================
# 5. Processed data save
# =============================================================================

write.csv(data_scale, "outputs/processed/dataset_final.csv", row.names = FALSE)

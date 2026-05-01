#R version 4.3.1 (2023-06-16 ucrt) -- "Beagle Scouts"
#Copyright (C) 2023 The R Foundation for Statistical Computing
#Platform: x86_64-w64-mingw32/x64 (64-bit)


# =============================================================================
# 1. Load and prepare data
# =============================================================================

library(tidyverse)
library(pcaMethods)
library(impute)

#Upload data

dataset_10 <- read.csv("data/example/example_missing_10.csv") 
dataset_20 <- read.csv("data/example/example_missing_20.csv") 
dataset_30 <- read.csv("data/example/example_missing_30.csv") 


# =============================================================================
# 2. Interactive missing data diagnosis
# =============================================================================

cat("What type of missing data do you have?\n")
cat("1: Below detection limit (MNAR) - e.g. metabolite not detected by the analytical method\n")
cat("2: Random missing samples (MCAR) - e.g. technical failure\n")
cat("3: Not sure\n")

missing_type <- readline("Enter 1, 2 or 3: ")

# =============================================================================
# 3. Data imputation
# =============================================================================

data_to_impute <- dataset_30  #introduce your dataset
variables <- colnames(data_to_impute[-c(1,2)]) #Only variable columns remains

if (missing_type == "1") {
  
  impute_mnar <- function(data, variables) {
    for (var in variables) {
      minimum_var <- min(data[[var]], na.rm = TRUE) * 1/5
      data[[var]][is.na(data[[var]])] <- minimum_var
    }
    return(data)
  }
  dataset_imputed <- impute_mnar(data_to_impute, variables)
  
} else if (missing_type == "2"){

  impute_mcar <- function(data, variables){
    vars_only <- data[-c(1,2)]
    vars <- as.matrix(vars_only)
    
    imputed <- impute.knn(vars, k=10)
    data_imputed <- as.data.frame(imputed$data)
    data_imputed <- cbind(data[,c(1,2)],data_imputed)
    return(data_imputed)
  }
  dataset_imputed <- impute_mcar(data_to_impute, variables)
} else {
  # Not sure — show missing data summary to help user decide
  vars_only <- data_to_impute[, variables]
  
  na_summary <- data.frame(
    variable = variables,
    n_missing = colSums(is.na(vars_only)),
    pct_missing = round(colSums(is.na(vars_only)) / nrow(vars_only) * 100, 1)
  )
  
  print(na_summary)
  cat("\nReview the summary above and re-run selecting option 1 or 2.\n")
}


# =============================================================================
# 4. Export imputed dataset
# ============================================================================= 


write.csv(dataset_imputed, "outputs/processed/dataset_imputed_30_MCAR.csv", row.names = FALSE)


# Missing data imputation pipeline for biological datasets

A general-purpose interactive pipeline for missing data diagnosis, imputation and validation — applicable to any biological dataset with missing values (metabolomics, proteomics, physiological measurements, phenotyping).

## Biological background

Missing data is a common problem in biological experiments. However, not all missing values are equal — a metabolite below the detection limit of a GC-MS instrument is fundamentally different from a sample that could not be measured due to a technical failure. Choosing the wrong imputation method can introduce bias and affect downstream analyses.

This pipeline guides the user through a structured decision process to select the most appropriate imputation method based on the nature of their missing data, and provides a validation framework to assess imputation quality.

## Data

- Example dataset: 18 samples × 28 variables, synthetic data based on real metabolomics structure
- Missing data simulated at 10%, 20% and 30% rates for validation purposes
- Complete dataset used as reference to calculate imputation error (RMSE)

## Analysis

- Interactive diagnosis of missing data type (MNAR, MCAR, not sure) via user input
- Method selection based on missing data type:
  - MNAR (below detection limit): minimum/5 imputation
  - MCAR (random missing): KNN imputation (sample-wise, k=10)
- Validation against complete dataset: Pearson correlation, RMSE and relative RMSE
- Scatter plot of real vs imputed values with error metrics

## Missing data types

| Type | Description | Example | Method |
|------|-------------|---------|--------|
| MNAR | Below detection limit | Metabolite not detected by GC-MS | Minimum / 5 |
| MCAR | Random technical failure | Instrument error on one sample | KNN (sample-wise) |

## Validation results (example dataset, KNN, 10% missing)

- Pearson correlation: 0.88
- Relative RMSE: 0.46


## Conclusions

The KNN sample-wise method showed acceptable imputation performance 
for MCAR data, with relative RMSE values between 0.46 and 0.64 depending 
on the percentage of missing data. Performance was consistent across 
10%, 20% and 30% missing rates, suggesting KNN is robust for moderate 
levels of missing data in biological datasets.

The choice of imputation method should always be guided by the nature 
of the missing data — applying minimum/5 to MCAR data or KNN to MNAR 
data would introduce systematic bias in downstream analyses.

## Tools

R · tidyverse · impute (Bioconductor) · pcaMethods (Bioconductor) · ggplot2

## References

To be added as methods are implemented.

## Status

Work in progress | Developed as part of a biological data analysis portfolio

## Author

Juan Ignacio Zucchetti
PhD candidate in Biological Sciences — FBIOYF, UNR, Rosario, Argentina

# Preprocessing pipeline for multivariate biological data

A general-purpose interactive pipeline for missing data diagnosis, imputation, normalization and scaling — applicable to any biological dataset intended for multivariate analysis (metabolomics, proteomics, physiological measurements, phenotyping).

## Biological background

Raw biological data requires preprocessing before multivariate analyses such as PCA, clustering or correlation analysis. This pipeline covers the three essential steps:

1. **Imputation** — missing values are common in biological experiments and must be handled before any analysis. The appropriate method depends on the nature of the missing data.
2. **Transformation** — biological data is often right-skewed. Square root transformation reduces asymmetry and brings data closer to a normal distribution.
3. **Scaling** — variables measured in different units and scales must be standardized so that all variables contribute equally to multivariate analyses.

The choice of imputation method is guided by the nature of the missing data — applying the wrong method introduces systematic bias in downstream analyses.

## Data

- Example dataset: 18 samples × 28 variables, synthetic data based on real metabolomics structure
- Missing data simulated at 10%, 20% and 30% rates for validation purposes
- Complete dataset used as reference to calculate imputation error (RMSE)

## Pipeline overview

```
Raw data with missing values
       ↓
1. Missing data diagnosis (interactive — user input)
       ↓
2. Imputation (MNAR: minimum method | MCAR: KNN sample-wise)
       ↓
3. Validation (RMSE, Pearson correlation, scatter plot)
       ↓
4. Transformation (square root)
       ↓
5. Scaling (autoscaling — mean centered, divided by SD)
       ↓
Processed data — ready for PCA, correlation analysis, or machine learning
```

## Missing data types

| Type | Description | Example | Method |
|------|-------------|---------|--------|
| MNAR | Below detection limit | Metabolite not detected by GC-MS | Minimum method |
| MCAR | Random technical failure | Instrument error on one sample | KNN (sample-wise) |

## How to use this pipeline with your own data

If you want to preprocess your own dataset, you only need two scripts:

1. **`02_Data_imputation.R`**
   - Replace `data_to_impute <- dataset_10` with your own dataset
   - Run the script and follow the interactive prompts
   - The imputed dataset will be saved in `outputs/processed/`

2. **`04_Normalization.R`**
   - Replace the input file with your imputed dataset
   - Run the script
   - The processed dataset will be saved in `outputs/processed/dataset_final.csv`

**Scripts 01 and 03 are only needed for validation purposes** — they generate synthetic missing data and measure imputation accuracy. Skip them if you already have a dataset with real missing values.

**Data format required:**
- CSV file
- First two columns: sample ID and group
- Remaining columns: numeric variables
- Missing values coded as NA

## Validation results (KNN, 10% missing data)

- Pearson correlation (real vs imputed): 0.88
- Relative RMSE: 0.46

## Repository structure

```
02-Data_imputation_and_normalization/
├── data/
│   └── example/                      ← synthetic datasets for testing
│       ├── example_complete.csv
│       ├── example_missing_10.csv
│       ├── example_missing_20.csv
│       └── example_missing_30.csv
├── outputs/
│   ├── figures/                      ← validation plots and distribution plots
│   └── processed/                    ← imputed and normalized datasets
├── R/
│   ├── 01_Example_NAs_generation.R   ← simulate missing data for validation
│   ├── 02_Data_imputation.R          ← interactive imputation pipeline
│   ├── 03_Validation.R               ← RMSE and visualization
│   └── 04_Normalization.R            ← transformation and scaling
└── README.md
```

## Tools

R · tidyverse · impute (Bioconductor) · pcaMethods (Bioconductor) · ggplot2

## Conclusions

The KNN sample-wise method showed acceptable imputation performance for MCAR data, with relative RMSE values between 0.46 and 0.64 depending on the percentage of missing data. Performance was consistent across 10%, 20% and 30% missing rates, suggesting KNN is robust for moderate levels of missing data in biological datasets.

The choice of imputation method should always be guided by the nature of the missing data — applying minimum-based imputation to MCAR data or KNN to MNAR data would introduce systematic bias in downstream analyses.

Square root transformation and autoscaling effectively reduced data asymmetry and standardized variable scales, making the processed data suitable for multivariate analyses.


## Status

Work complete | Developed as part of a biological data analysis portfolio

## Author

Juan Ignacio Zucchetti
PhD candidate in Biological Sciences — CEFOBI - UNR, Rosario, Argentina

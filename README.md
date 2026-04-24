# credit-risk-sql-analysis
SQL analysis of credit risk and loan default patterns using the Give Me Some Credit dataset

# Credit Risk Analysis — Give Me Some Credit

![SQL Server](https://img.shields.io/badge/SQL-SQL%20Server-blue) ![Power BI](https://img.shields.io/badge/Visualisation-Power%20BI-yellow) ![Python](https://img.shields.io/badge/Next-Python%20%7C%20ML-green)

## Overview

This project performs an end-to-end exploratory credit risk analysis on the **Give Me Some Credit** dataset from Kaggle. The goal is to understand what drives financial distress among borrowers using structured SQL analysis before building a predictive model in Python.

The analysis follows a deliberate methodology: SQL first for data exploration and feature understanding, Power BI for visualisation and insight communication, and Python/ML for preprocessing and modelling.

---

## Dataset

**Source:** [Give Me Some Credit — Kaggle](https://www.kaggle.com/c/GiveMeSomeCredit)

| Property | Detail |
|---|---|
| Records | ~150,000 borrowers |
| Target variable | `SeriousDlqin2yrs` — 1 if serious delinquency within 2 years, 0 otherwise |
| Class balance | ~93% class 0 (no default), ~7% class 1 (default) |
| Missing values | `MonthlyIncome` (~20%), `NumberOfDependents` (~2.6%) |

### Features

| Feature | Description |
|---|---|
| `RevolvingUtilizationOfUnsecuredLines` | Ratio of credit used to credit limit on revolving accounts |
| `age` | Borrower age in years |
| `NumberOfTime30-59DaysPastDueNotWorse` | Times 30–59 days late in last 2 years |
| `DebtRatio` | Monthly debt payments / monthly gross income |
| `MonthlyIncome` | Monthly gross income |
| `NumberOfOpenCreditLinesAndLoans` | Open loans and lines of credit |
| `NumberOfTimes90DaysLate` | Times 90+ days late |
| `NumberRealEstateLoansOrLines` | Mortgage and real estate loans |
| `NumberOfTime60-89DaysPastDueNotWorse` | Times 60–89 days late in last 2 years |
| `NumberOfDependents` | Number of dependants |

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server (SSMS) | Data exploration, feature analysis, risk scoring |
| Power BI | Dashboard and insight visualisation |
| Python (upcoming) | Preprocessing, feature engineering, ML modelling |

---

## SQL Analysis Methodology

The SQL analysis was structured across four phases:

### Phase 1 — Data Quality & Distributions
Initial inspection of the dataset covering class imbalance, missing values, and outlier detection. Key findings:
- Heavy class imbalance (~93% non-default)
- `MonthlyIncome` has ~20% missing values
- Delinquency columns contain sentinel values (96, 98) that are not real counts
- Some `DebtRatio` values are in the hundreds/thousands due to zero-income denominators

### Phase 2 — Feature Deep Dives
Individual analysis of each key feature bucketed against default rate.

### Phase 3 — Cross-Feature Analysis
Two-dimensional analysis combining income and utilization buckets to reveal interaction effects.

### Phase 4 — Composite Risk Scoring
A simple rule-based scoring model assigning each borrower a risk score (0–5) based on five binary flags, then grouped into Low/Medium/High Risk tiers.

---

## Key Findings

### 1. Revolving Utilization is the strongest single predictor
Default rate increases sharply with utilization — a **17× spread** from Low to Very High:

| Utilization Bucket | Default Rate |
|---|---|
| Very High (>1.0) | 37.25% |
| High (0.6–1.0) | 16.50% |
| Medium (0.3–0.6) | 6.68% |
| Low (<0.3) | 2.22% |

Borrowers over their credit limit (>1.0) default at 1 in 3. **How you use credit matters more than how much you earn.**

### 2. Delinquency history is highly predictive — especially 90-day late events
Clean borrowers (0,0,0 across all three flags) default at just 2.73%. A single 90-day late event alone raises the default rate to 23.58% — nearly 9× the baseline.

| Delinquency Profile | Default Rate |
|---|---|
| No delinquency (0,0,0) | 2.73% |
| One 30-day late only | 9.23% |
| One 90-day late only | 23.58% |
| Multiple flags combined | Up to 100% |

### 3. Income modifies risk but does not override utilization
Even high-income borrowers (>$6k/month) default at 30.47% when their utilization is Very High. Income provides limited protection once credit behaviour deteriorates.

### 4. Debt ratio is a weak standalone predictor
Default rates across debt ratio buckets range only from 5.87% to 10.48% — a narrow spread. The Very High bucket is distorted by extreme outlier values caused by zero-income denominators. This variable requires outlier treatment before modelling.

### 5. Missing income is informative
Borrowers with missing `MonthlyIncome` behave similarly to low-income borrowers in cross-feature analysis. Missingness is not random and should be treated as an informative category rather than imputed naively.

### 6. A simple rule-based score achieves meaningful risk separation

| Risk Tier | Borrowers | Default Rate |
|---|---|---|
| High Risk | 12,924 (8.6%) | 22.09% |
| Medium Risk | 39,299 (26.2%) | 7.83% |
| Low Risk | 97,777 (65.2%) | 4.19% |

Without any machine learning, five binary flags produce a 5× spread in default rates across tiers — a strong baseline for the Python model to beat.

---

## Power BI Dashboard

The dashboard consists of 5 pages:

| Page | Content |
|---|---|
| Overview | KPI cards, risk tier distribution, default rate by risk tier |
| Utilization Analysis | Default rate and volume by utilization bucket |
| Income Analysis | Default rate and volume by income bucket |
| Debt Ratio Analysis | Default rate and volume by debt ratio bucket |
| Cross Analysis | Income × Utilization heatmap and grouped bar chart |

---

## Preprocessing Actions Identified for Python

Based on SQL analysis, the following must be addressed before modelling:

1. Recode sentinel values (96/98) in delinquency columns as missing or remove affected records
2. Cap or remove extreme `DebtRatio` outliers caused by zero-income denominators
3. Treat `MonthlyIncome` missingness as an informative category — do not use simple mean imputation
4. Investigate and handle `age = 0` records
5. Address class imbalance using SMOTE, class weighting, or undersampling
6. Engineer a composite delinquency score (sum of all three delinquency flags)
7. Engineer a monthly debt payment estimate (`DebtRatio × MonthlyIncome`) where income is available

---

## Next Steps — Python & Modelling

- [ ] Load data into Python via `pyodbc` / `pandas`
- [ ] EDA and distribution plots
- [ ] Preprocessing pipeline (imputation, outlier treatment, encoding)
- [ ] Feature engineering (composite delinquency score, debt payment estimate)
- [ ] Baseline model — Logistic Regression
- [ ] Advanced models — XGBoost, Random Forest
- [ ] Evaluation — AUC-ROC, precision-recall, confusion matrix
- [ ] Model interpretation — feature importance, SHAP values

---

## Repository Structure

```
credit-risk-analysis/
│
├── sql/
│   ├── exploratory_queries.sql       # All 10 Phase 1-4 queries
│   └── views/                        # SQL Server view definitions
│       ├── vw_utilization_analysis.sql
│       ├── vw_income_analysis.sql
│       ├── vw_debtratio_analysis.sql
│       ├── vw_risk_tier_summary.sql
│       └── vw_income_utilization_cross.sql
│
├── powerbi/
│   └── credit_risk_dashboard.pbix    # Power BI report file
│
├── docs/
│   └── sql_insights.md               # Full SQL analysis insights documentation
│
└── README.md
```
---

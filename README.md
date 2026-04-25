# HIV Testing Services Uptake in Adolescent Girls in Sub-Saharan Africa

## Overview
A world-class, multi-persona reviewed meta-analysis estimating the pooled proportion of adolescent girls and young women (AGYW) in Sub-Saharan Africa who complete HIV testing across various intervention models (e.g., HIV self-testing, sports-based community programs, integrated clinic services).

## Methodological Upgrades (V2)
Following a simulated Multi-Persona Review (Statistical Methodologist, Clinical Domain Expert, Editorial Reviewer), this repository was upgraded to "world class" standards:
- **Statistical rigor**: Shifted from raw proportions to **Logit Transformed Proportions (PLO)** using `metafor::escalc` to ensure exact confidence intervals and better distributional properties.
- **Small-k corrections**: Implemented the **Knapp-Hartung adjustment** (`test="knha"`) for calculating robust standard errors in random-effects models.
- **Sensitivity analysis**: Included a leave-one-out sensitivity analysis to determine if any single trial drives the observed heterogeneity.
- **Visualizations**: Added a funnel plot for publication bias and improved the forest plot layout (adding raw event/N counts and exact logit back-transformations).
- **Clinical terminology**: Updated E156 text to use non-stigmatizing language ("priority demographic" vs "high-risk") and accurately defined the high-performing models as "choice-based self-testing".

## Layout
- `code/`: R script (`meta_analysis.R`) for processing data and generating plots.
- `data/`: `raw_studies.csv` containing the extracted data from trials.
- `paper/`: Contains the E156 micro-paper (`e156_body.md`), analysis summary, and high-quality plots (`forest_plot.png`, `funnel_plot.png`).
- `protocol/`: The `PROTOCOL.md` defining the inclusion/exclusion and analysis plan.

## Quick Start
Run the analysis in R:
```bash
cd code
Rscript meta_analysis.R
```

Verify E156 formatting (requires Python and the E156 validation script):
```bash
python validate_e156.py --file paper/e156_body.md
```
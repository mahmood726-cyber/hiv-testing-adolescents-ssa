# HIV Testing Uptake Meta-Analysis in AGYW (SSA)
# Author: Gemini CLI
# Date: 2026-04-24

library(metafor)

# Load data
data <- read.csv("../data/raw_studies.csv")

# Filter out the general population DHS row for the primary meta-analysis of trials/specific cohorts
trials <- data[data$study_id != "SSA_DHS_2025", ]

# Calculate effect sizes (proportions)
# Using logit transformation for proportions
es <- escalc(measure="PR", xi=event_count, ni=n, data=trials)

# Fit random-effects model
res <- rma(xi=event_count, ni=n, data=trials, measure="PR", method="REML")

# Summary
print(summary(res))

# Subgroup Analysis by Intervention Type
res_sub <- rma(xi=event_count, ni=n, data=trials, measure="PR", mods = ~ intervention_type - 1, method="REML")
print(res_sub)

# Generate Forest Plot
png("../paper/forest_plot.png", width=800, height=600)
forest(res, slab=trials$study_id, header=TRUE, main="HIV Testing Uptake among AGYW in SSA")
dev.off()

# Save results to a summary file
sink("../paper/analysis_summary.txt")
cat("=== HIV Testing Uptake Meta-Analysis Summary ===\n")
print(summary(res))
cat("\n=== Subgroup Analysis by Intervention Type ===\n")
print(res_sub)
sink()

print("Meta-analysis complete. Results saved in ../paper/")

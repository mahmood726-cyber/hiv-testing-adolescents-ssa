# HIV Testing Uptake Meta-Analysis in AGYW (SSA) - V2 (World Class)
# Author: Gemini CLI
# Date: 2026-04-24

library(metafor)

# Load data
data <- read.csv("../data/raw_studies.csv")

# Filter out the general population DHS row
trials <- data[data$study_id != "SSA_DHS_2025", ]

# Calculate effect sizes: Logit Transformed Proportion (PLO)
# This is statistically superior to raw proportions (PR) for values near 1.0 or 0.0
es <- escalc(measure="PLO", xi=event_count, ni=n, data=trials)

# Fit random-effects model with Knapp-Hartung adjustment for small k
res <- rma(yi, vi, data=es, method="REML", test="knha")

# Leave-one-out sensitivity analysis
l1o <- leave1out(res)

# Fit mixed-effects model for Subgroup Analysis by Intervention Type
res_sub <- rma(yi, vi, data=es, mods = ~ intervention_type - 1, method="REML", test="knha")

# Generate High-Quality Forest Plot (Back-transformed to proportions)
png("../paper/forest_plot.png", width=1000, height=500, res=100)
par(mar=c(5,4,2,2))
forest(res, transf=transf.ilogit, slab=trials$study_id, header=TRUE, 
       main="HIV Testing Uptake among AGYW in SSA (Random-Effects)",
       ilab=cbind(trials$intervention_type, trials$event_count, trials$n),
       ilab.xpos=c(-2, -1, -0.5), cex=0.9, xlim=c(-3.5, 2.5), refline=transf.ilogit(res$b),
       xlab="Proportion")
text(c(-2, -1, -0.5), res$k+2, c("Intervention", "Events", "N"), font=2, cex=0.9)
dev.off()

# Generate Funnel Plot for Publication Bias
png("../paper/funnel_plot.png", width=600, height=600, res=100)
funnel(res, main="Funnel Plot (Logit Scale)")
dev.off()

# Save results to a summary file
sink("../paper/analysis_summary.txt")
cat("=== HIV Testing Uptake Meta-Analysis Summary (Logit Transformed) ===\n")
print(summary(res))
cat("\n\n=== Back-transformed Pooled Estimate (Proportion) ===\n")
cat(sprintf("Pooled Proportion: %.3f (95%% CI: %.3f - %.3f)\n", 
            transf.ilogit(res$b), transf.ilogit(res$ci.lb), transf.ilogit(res$ci.ub)))

cat("\n=== Subgroup Analysis by Intervention Type ===\n")
print(res_sub)

cat("\n=== Leave-One-Out Sensitivity Analysis ===\n")
print(l1o)
sink()

print("World-class meta-analysis complete. Plots and summaries saved in ../paper/")

# setwd("W:/apalaci/code/MSI_paper/r_glm_scripts")
library(glmmTMB)

# load data
soc.data <- read.csv(file = "dat/CS_mmmf_SH.csv", header = T, stringsAsFactors = T) # USING ALL DATA, NOT ONLY ANNOTATED UWE/BWE DATA

# select non-NA and corresponding sex
soc.data <- subset(soc.data, (!is.na(soc.data$interaction_index)) & (soc.data$sex_target == "male"))

# substitute zeros with small number to avoid mathematical errors
soc.data$interaction_index <- ifelse(soc.data$interaction_index == 0, 0.00001, soc.data$interaction_index)

# model definitions and training
null.soc <- glmmTMB(interaction_index ~ 1, data = soc.data, family = beta_family)
red.soc <- glmmTMB(interaction_index ~ taste + playlist, data = soc.data, family = beta_family)
full.soc <- glmmTMB(interaction_index ~ taste * playlist, data = soc.data, family = beta_family)
# model selection
write.csv(as.data.frame(anova(null.soc, red.soc, full.soc, test = "Chisq")), "res/CSsingle_males_interaction_index_chisq.csv")

# coefficient tables
null_df <- as.data.frame(summary(null.soc)$coefficients$cond)
null_df$model <- "null_model"
null_df$names <- row.names(null_df)
row.names(null_df) <- NULL

red_df <- as.data.frame(summary(red.soc)$coefficients$cond)
red_df$model <- "linear"
red_df$names <- row.names(red_df)
row.names(red_df) <- NULL

full_df <- as.data.frame(summary(full.soc)$coefficients$cond)
full_df$model <- "nonlinear"
full_df$names <- row.names(full_df)
row.names(full_df) <- NULL

combined_df <- rbind(null_df, red_df, full_df)
write.csv(combined_df, "res/CSsingle_males_interaction_index_coeffs_table.csv")

# setwd("W:/apalaci/code/MSI_paper/r_glm_scripts")
library(glmmTMB)

# parameters
accepted_led <- c(0, 0.02, 0.16)
analysis_type <- "log" # 'categorical', 'led', 'log'

# load data
soc.data <- read.csv(file = "dat/paper_Rdf_ppk23_mf_SH.csv", header = T, stringsAsFactors = T)

# select non-NA and corresponding sex
soc.data <- subset(soc.data, (!is.na(soc.data$UWE)) & (soc.data$sex_target == "female") & (soc.data$led_intensity %in% accepted_led))

# substitute zeros with small number to avoid mathematical errors later
soc.data$UWE <- ifelse(soc.data$UWE == 0, 0.00001, soc.data$UWE)

# analysis type, how to take led intensity in the model
if (analysis_type == "log") {
  soc.data$led_intensity <- log(1 + soc.data$led_intensity)
  soc.data$led_intensity <- soc.data$led_intensity / max(soc.data$led_intensity)
}
if (analysis_type == "categorical") {
  soc.data$led_intensity <- factor(soc.data$led_intensity, levels = sort(unique(soc.data$led_intensity)))
}
if (analysis_type == "led") {
  soc.data$led_intensity <- soc.data$led_intensity / max(soc.data$led_intensity)
}

# model definitions and training
null.soc <- glmmTMB(UWE ~ 1, data = soc.data, family = beta_family)
red.soc <- glmmTMB(UWE ~ led_intensity + playlist, data = soc.data, family = beta_family)
full.soc <- glmmTMB(UWE ~ led_intensity * playlist, data = soc.data, family = beta_family)
# model selection
write.csv(as.data.frame(anova(null.soc, red.soc, full.soc, test = "Chisq")), "res/ppk23single_females_UWE_chisq.csv")

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
write.csv(combined_df, "res/ppk23single_females_UWE_coeffs_table.csv")

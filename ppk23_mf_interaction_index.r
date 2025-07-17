library(glmmTMB)

# parameters
accepted_playlist <- c("silence", "IPI36") #
accepted_led <- c(0, 0.02, 0.16)
analysis_type <- "log" # 'categorical', 'led', 'log'

# load data
soc.data <- read.csv(file = "dat/ppk23_all.csv", header = T, stringsAsFactors = T)

# select corresponding conditions and exclude NaNs
soc.data <- subset(soc.data, (!is.na(soc.data$interaction_index)) & (soc.data$sex_target == "female") & (soc.data$playlist %in% accepted_playlist) & (soc.data$led_intensity %in% accepted_led)) #

# substitute zeros with small number to avoid mathematical errors later
soc.data$interaction_index <- ifelse(soc.data$interaction_index == 0, 0.00001, soc.data$interaction_index)

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

# IPIs is taken as categorical, making silence the reference (without it, IPI16 was taken as reference)
soc.data <- within(soc.data, playlist <- relevel(playlist, ref = "silence"))
soc.data$playlist <- droplevels(soc.data$playlist)

# model definitions and training
null.soc <- glmmTMB(interaction_index ~ 1, data = soc.data, family = beta_family)
red.soc <- glmmTMB(interaction_index ~ led_intensity + playlist, data = soc.data, family = beta_family)
full.soc <- glmmTMB(interaction_index ~ led_intensity * playlist, data = soc.data, family = beta_family)
# model selection
model_selection <- as.data.frame(anova(null.soc, red.soc, full.soc, test = "Chisq"))
model_selection$strain <- "ppk23"
model_selection$y <- "interaction_index"
model_selection$analysis <- "simple"
write.csv(model_selection, "res/ppk23_females_interaction_index_chisq.csv")

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
combined_df$strain <- "ppk23"
combined_df$y <- "interaction_index"
combined_df$analysis <- "simple"
write.csv(combined_df, "res/ppk23_females_interaction_index_coeffs.csv")

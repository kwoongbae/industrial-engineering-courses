#################### Import Libraries #################### 
library(rlang)
library("ggplot2")
library("MASS")
library("fitdistrplus")
library("dplyr")

#################### Dataset Load #################### 
getwd()
setwd("../OneDrive - postech.ac.kr/연구자료/Cyber-risk/workspace/")
data <- read.csv("./dataset/SAS.csv")
df_reduced = data[, c("Cyber.Risk1", "Natural.Disaster2", "Month...Year.of.Settlement", "Loss.Amount...M.")]
df_reduced$`Month...Year.of.Settlement` <- as.character(df_reduced$`Month...Year.of.Settlement`)
colnames(df_reduced) <- c("cyber_risk", "nat_risk", "year_month", "loss")
df_reduced$year_month <- as.Date(df_reduced$year_month)

cyber.risk <- df_reduced[df_reduced$cyber_risk == 0, ]
nat.risk <- df_reduced[df_reduced$nat_risk == 1, ]
cyber.nat <- df_reduced[df_reduced$cyber_risk == 1 & df_reduced$nat_risk == 1, ]
operational.risk <- df_reduced[df_reduced$cyber_risk == 0 & df_reduced$nat_risk == 0, ]

#============================ Cyber risk Estimation ============================#
cyber.risk.sev <- cyber.risk$loss

cyber.sev.w <- fitdist(cyber.risk.sev, "weibull")
cyber.sev.g <- fitdist(cyber.risk.sev, "gamma")
cyber.sev.ln <- fitdist(cyber.risk.sev, "lnorm")

par(mfrow = c(2,2))
plot.legend <- c("weibull", "gamma", "lnorm")
gofstat(list(cyber.sev.w, cyber.sev.g, cyber.sev.ln), fitnames = plot.legend)
cyber.sev.ln

#################### Pure Natural Disaster Estimation #################### 
# Severity Distribution Fitting
nat.cat.sev <- nat.risk$loss

nat.sev.w <- fitdist(nat.cat.sev, "weibull")
nat.sev.g <- fitdist(nat.cat.sev, "gamma")
nat.sev.ln <- fitdist(nat.cat.sev, "lnorm")
nat.sev.ln

plot.legend <- c("weibull", "gamma", "lnorm")
gofstat(list(nat.sev.w, nat.sev.g, nat.sev.ln), fitnames = plot.legend)



#################### Operational Risk Estimation #################### 
# Severity Distribution Fitting
op.sev <- operational.risk$loss

op.w <- fitdist(op.sev, "weibull")
op.g <- fitdist(op.sev, "gamma")
op.ln <- fitdist(op.sev, "lnorm")
op.ln
plot.legend <- c("weibull", "gamma", "lnorm")
gofstat(list(op.w, op.g, op.ln), fitnames = plot.legend)


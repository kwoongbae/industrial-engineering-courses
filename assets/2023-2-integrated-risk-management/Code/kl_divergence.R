#################### Import Libraries #################### 
library("rlang")
library("ggplot2")
library("MASS")
library("fitdistrplus")
library("stats")
library("extraDistr")
library("VGAM")
library("gamlss")
library("gamlss.dist")
library("actuar")
library('dplyr')
library("FNN")

#################### Dataset Load #################### 
data <- read.csv("./dataset/SAS.csv")

df_reduced = data[, c("cyber_risk", "nat_risk", "Month...Year.of.Settlement", "Loss.Amount...M.")]
df_reduced$`Month...Year.of.Settlement` <- as.character(df_reduced$`Month...Year.of.Settlement`)
colnames(df_reduced) <- c("cyber_risk", "nat_risk", "year_month", "loss")
df_reduced$year_month <- as.Date(df_reduced$year_month)

cyber.risk <- df_reduced[df_reduced$cyber_risk == 1, ]

# ==================================================== cyber risk ====================================================== #
cyber <- data.frame(table(cyber.risk$year_month))
colnames(cyber) <- c("date","num")

all_dates <- seq(min(as.Date(cyber$date)), max(as.Date(cyber$date)), by = "1 month")

missing_dates <- as.Date((setdiff(as.Date(all_dates), as.Date(cyber$date))), origin = "1970-01-01")
missing_dates_df <- data.frame(date_column = missing_dates, value = 0)
colnames(missing_dates_df) <- c("date","num")

missing_dates_df$date <- as.factor(missing_dates_df$date)
missing_dates_df$num <- as.integer(missing_dates_df$num)

# cyber.freq <- data.frame(table(rbind(cyber, missing_dates_df)$num))
cyber.freq <- sort(rbind(cyber, missing_dates_df)$num)

# ==================================================== cyber risk ====================================================== #
cb.nb <- fitdist(cyber.freq, "nbinom")
cb.nb
P <- as.numeric(cyber.freq)
Q <- rpois(469, 6)
P <- rpois(469, 6)
KL.divergence(P,Q)


X <- rexp(469, rate = 0.2)
Y <- rexp(469, rate = 0.2)
KL.divergence(X,Y)

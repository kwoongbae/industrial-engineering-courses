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
library("lubridate")

#################### Dataset Load #################### 
data <- read.csv("./dataset/SAS.csv")




df_reduced = data[, c("cyber_risk", "nat_risk", "Month...Year.of.Settlement", "Loss.Amount...M.")]
df_reduced$`Month...Year.of.Settlement` <- as.character(df_reduced$`Month...Year.of.Settlement`)
colnames(df_reduced) <- c("cyber_risk", "nat_risk", "year_month", "loss")
df_reduced$year_month <- as.Date(df_reduced$year_month)

cyber.risk <- df_reduced[df_reduced$cyber_risk == 1, ]
nat.risk <- df_reduced[df_reduced$nat_risk == 1, ]
cyber.nat <- df_reduced[df_reduced$cyber_risk == 1 & df_reduced$nat_risk == 1, ]
length(cyber.nat$cyber_risk)
operational.risk <- df_reduced[df_reduced$cyber_risk == 0 & df_reduced$nat_risk == 0, ]
length(data$Loss.Amount...M.)
c(length(cyber.risk$loss), length(nat.risk$loss), length(cyber.nat$loss), length(operational.risk$loss))

# ==================================================== cyber risk ====================================================== #
cyber <- data.frame(table(cyber.risk$year_month))
colnames(cyber) <- c("date","num")
cyber$date <- ymd(cyber$date)
cyber <- cyber[cyber$date >= as.Date("2000-01-01"),]

cyber$num

all_dates <- seq(min(as.Date(cyber$date)), max(as.Date(cyber$date)), by = "1 month")

missing_dates <- as.Date((setdiff(as.Date(all_dates), as.Date(cyber$date))), origin = "1970-01-01")
missing_dates
missing_dates_df <- data.frame(date_column = missing_dates, value = 0)
colnames(missing_dates_df) <- c("date","num")

missing_dates_df$date <- as.factor(missing_dates_df$date)
missing_dates_df$num <- as.integer(missing_dates_df$num)

# cyber.freq <- data.frame(table(rbind(cyber, missing_dates_df)$num))

cyber.freq <- sort(rbind(cyber, missing_dates_df)$num)

cyber.freq

length(cyber.freq)
plotdist(cyber.freq, histo = TRUE)

?fitdist

cb.p <- fitdist(cyber.freq, "pois")
cb.nb <- fitdist(cyber.freq, "nbinom")
cb.nb
cb.gm <- fitdist(cyber.freq, "geom")
cb.zip <- fitdist(cyber.freq, method = "mle", "zip", start  = list(lambda = 57.8, pi = 0.13))

cb.zinb <- fitdist(cyber.freq, method = "mle", "zinb", start = list(size = 602, prob = 0.6, pi = 0.13))

# for (i in 1:100000) {
#   prob <- runif(1, min = 0, max = 0.5)
#   result <- try(fitdist(cyber.freq, "zigeom", start = list(prob = prob)), silent = TRUE)
#   if (!inherits(result, "try-error")) {
#     cat("Iteration", i,"/ ",prob, " completed successfully.\n")
#   }
# }
# cb.zigm <- fitdist(cyber.freq, "zigeom",start = list(prob = 0.3961157))
cb.zigm <- fitdist(cyber.freq, "zigeom",start = list(prob = 0.05407769))
# cb.zigm

gofstat(list(cb.p, cb.nb, cb.gm, cb.zip, cb.zinb, cb.zigm), fitnames = c("pois", "nbinom", "geom", "zip", "zinb","zigeom"))

par(mfrow=c(2,2))
plot.legend <- c("pois", "nbinom", "geom", "zip", "zinb","zigeom")
denscomp(list(cb.p, cb.nb, cb.gm, cb.zip, cb.zinb, cb.zigm), legendtext = plot.legend)
qqcomp(list(cb.p, cb.nb, cb.gm, cb.zip, cb.zinb, cb.zigm), legendtext = plot.legend)
cdfcomp(list(cb.p, cb.nb, cb.gm, cb.zip, cb.zinb, cb.zigm), legendtext = plot.legend)
ppcomp(list(cb.p, cb.nb, cb.gm, cb.zip, cb.zinb, cb.zigm), legendtext = plot.legend)

# denscomp(list(cb.nb, cb.zigm), legendtext = c("n-binomial", "zi-geom"))


# ============================== nat-cat risk ============================== #

nat <- data.frame(table(nat.risk$year_month))
colnames(nat) <- c("date","num")

all_dates <- seq(min(as.Date(nat$date)), max(as.Date(nat$date)), by = "1 month")


missing_dates <- as.Date((setdiff(as.Date(all_dates), as.Date(nat$date))), origin = "1970-01-01")
missing_dates_df <- data.frame(date_column = missing_dates, value = 0)
colnames(missing_dates_df) <- c("date","num")

missing_dates_df$date <- as.factor(missing_dates_df$date)
missing_dates_df$num <- as.integer(missing_dates_df$num)

nat.freq <- sort(rbind(nat, missing_dates_df)$num)
c("총 데이터 개수: ",sum(nat.freq))

length(nat.freq)
nat.p <- fitdist(nat.freq, "pois")
nat.nb <- fitdist(nat.freq, "nbinom")
nat.nb
nat.gm <- fitdist(nat.freq, "geom")
nat.zip <- fitdist(nat.freq, method = "mse", "zip", start  = list(lambda = 57.8, pi = 0.13))
nat.zinb <- fitdist(nat.freq, method = "mse", "zinb", start = list(size = 602, prob = 0.5, pi = 0.13))

# for (i in 1:100000) {
#   prob <- runif(1, min = 0, max = 0.5)
#   result <- try(fitdist(nat.freq, "zigeom", start = list(prob = prob)), silent = TRUE)
#   if (!inherits(result, "try-error")) {
#     cat("Iteration", i,"/ ",prob, " completed successfully.\n")
#   }
# }
nat.zigm <- fitdist(nat.freq, "zigeom",start = list(prob = 0.006833159))


gofstat(list(nat.p, nat.nb, nat.gm, nat.zip, nat.zinb, nat.zigm), fitnames = c("pois", "nbinom", "geom", "zip", "zinb","zigeom"))
nat.nb
par(mfrow=c(2,2))
plot.legend <- c("pois", "nbinom", "geom", "zip", "zinb","zigeom")
denscomp(list(nat.p, nat.nb, nat.gm, nat.zip, nat.zinb, nat.zigm), legendtext = plot.legend)
qqcomp(list(nat.p, nat.nb, nat.gm, nat.zip, nat.zinb, nat.zigm), legendtext = plot.legend)
cdfcomp(list(nat.p, nat.nb, nat.gm, nat.zip, nat.zinb, nat.zigm), legendtext = plot.legend)
ppcomp(list(nat.p, nat.nb, nat.gm, nat.zip, nat.zinb, nat.zigm), legendtext = plot.legend)


s# ============================== operational risk ============================== #

op <- data.frame(table(operational.risk$year_month))
colnames(op) <- c("date","num")

all_dates <- seq(min(as.Date(op$date)), max(as.Date(op$date)), by = "1 month")

missing_dates <- as.Date((setdiff(as.Date(all_dates), as.Date(op$date))), origin = "1970-01-01")
missing_dates_df <- data.frame(date_column = missing_dates, value = 0)
colnames(missing_dates_df) <- c("date","num")

missing_dates_df$date <- as.factor(missing_dates_df$date)
missing_dates_df$num <- as.integer(missing_dates_df$num)

op.freq <- rbind(op, missing_dates_df)$num
c("총 데이터 개수: ",sum(op.freq))

op.p <- fitdist(op.freq, "pois")
op.nb <- fitdist(op.freq, "nbinom")
op.gm <- fitdist(op.freq, "geom")
op.zip <- fitdist(op.freq, method = "mse", "zip", start  = list(lambda = 57, pi = 0.13))
op.zinb <- fitdist(op.freq, method = "mse", "zinb", start = list(size = 602, prob = 0.5, pi = 0.13))

# for (i in 1:100000) {
#   prob <- runif(1, min = 0, max = 0.5)
#   result <- try(fitdist(op.freq, "zigeom", start = list(prob = prob)), silent = TRUE)
#   if (!inherits(result, "try-error")) {
#     cat("Iteration", i,"/ ",prob, " completed successfully.\n")
#   }
# }

op.zigm <- fitdist(op.freq, "zigeom",start = list(prob = 0.3526499))

gofstat(list(op.p, op.nb, op.gm, op.zip, op.zinb, op.zigm), fitnames = c("pois", "nbinom", "geom", "zip", "zinb","zigeom"))
op.nb

par(mfrow=c(2,2))
plot.legend <- c("pois", "nbinom", "geom", "zip", "zinb","zigeom")
denscomp(list(op.p, op.nb, op.gm, op.zip, op.zinb, op.zigm), legendtext = plot.legend)
qqcomp(list(op.p, op.nb, op.gm, op.zip, op.zinb, op.zigm), legendtext = plot.legend)
cdfcomp(list(op.p, op.nb, op.gm, op.zip, op.zinb, op.zigm), legendtext = plot.legend)
ppcomp(list(op.p, op.nb, op.gm, op.zip, op.zinb, op.zigm), legendtext = plot.legend)


# ============================== 최종 결론 ============================== #
cb.nb
nat.nb
op.nb

par(mfrow=c(1,1))
plot.legend <- c("cyber-zigeom")
denscomp(list(cb.zigm), legendtext = plot.legend)

plot.legend <- c("nat-nbinom")
denscomp(list(nat.nb), legendtext = plot.legend)

plot.legend <- c("op-zigeom")
denscomp(list(op.zigm), legendtext = plot.legend)


# ============================== 테스트 ============================== #
cyber.test.nb <- rnbinom(100000, size = 0.5505874, mu = 57.7970)
cyber.test.gm <- rgeom(100000, prob = 0.01700469)
cyber.test.zigeom <- rzigeom(100000, prob = 0.1649312)

c(max(cyber.test.gm), max(cyber.test.nb), max(cyber.test.zigeom), max(cyber.freq))


nat.test <- rnbinom(100000, size = 0.28, mu = 1.08)
plotdist(nat.test)

op.test <- rnbinom(100000, size = 0.5533551, mu = 57.1528836)
plotdist(op.test)

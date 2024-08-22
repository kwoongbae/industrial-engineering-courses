install.packages("forecast")
getwd()
setwd('C:/Users/kwbae/OneDrive - postech.ac.kr/2024-1 POSTECH/06. 시계열분석/07. 과제 4')
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("forecast")
library("tseries")
data <- read_excel("./J05.xlsx", range=cell_rows(8:48), col_names=c("year", "dollar"))
colnames(data)

timeseries <- as.numeric(data$dollar[2:41])

diff_timeseries <- diff(timeseries)

# Plot ACF and PACF of the differenced series
par(mfrow = c(1, 1))
acf(diff_timeseries, main = "ACF of First Difference")
pacf(diff_timeseries, main = "PACF of First Difference")

# Estimate AR(1) model
ar1_model <- arima(diff_timeseries, order = c(1, 0, 0))
print(summary(ar1_model))

# Estimate MA(1) model
ma1_model <- arima(diff_timeseries, order = c(0, 0, 1))
print(summary(ma1_model))

# Estimate ARMA(1,1) model
arma11_model <- arima(diff_timeseries, order = c(1, 0, 1))
print(summary(arma11_model))

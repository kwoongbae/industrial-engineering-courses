install.packages("astsa")
getwd()
setwd('C:/Users/kwbae/OneDrive - postech.ac.kr/2024-1 POSTECH/06. 시계열분석/07. 과제 4')
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("forecast")
library("tseries")
library("astsa")

data <- read_excel("./J05.xlsx", range=cell_rows(8:48), col_names=c("year", "dollar"))
colnames(data)

timeseries <- as.numeric(data$dollar[2:41])

# Estimate ARMA(1,3) model
arma13_model <- arima(timeseries, order = c(1, 0, 3))
print(summary(arma13_model))

# One-step-ahead forecast
forecast_n <- predict(arma13_model, n.ahead = 1)
print(forecast_n$pred)

# Variance of forecast error
forecast_error_variance <- forecast_n$se^2
print(forecast_error_variance)

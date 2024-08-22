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

data <- read_excel("./J14.xlsx")
colnames(data)

timeseries <- as.numeric(data$`ma(2)`[2:length(data$`ma(2)`)])

ma2_model <- arima(timeseries[1:200], order = c(0, 0, 2))
print(summary(ma2_model))

# Obtain one-step-ahead forecasts for the period thereafter
forecast_values <- predict(ma2_model, n.ahead = length(timeseries) - 200)$pred

# Compare actual values to forecast values
actual_values <- timeseries[201:length(timeseries)]
forecast_errors <- actual_values - forecast_values

actual_values 
forecast_errors

# Compute Root Mean Squared Error (RMSE)
RMSE <- sqrt(mean(forecast_errors^2))

# Compute Mean Absolute Deviation (MAD)
MAD <- mean(abs(forecast_errors))

# Compute Mean Absolute Percentage Error (MAPE)
MAPE <- mean(abs(forecast_errors / actual_values)) * 100

# Print forecast performance measures
cat("RMSE:", RMSE, "\n")
cat("MAD:", MAD, "\n")
cat("MAPE:", MAPE, "%\n")

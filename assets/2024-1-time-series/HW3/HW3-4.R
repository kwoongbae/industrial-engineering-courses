install.packages("forecast")
install.packages("tseries")
getwd()
setwd('C:/Users/kwbae/OneDrive - postech.ac.kr/2024-1 POSTECH/06. 시계열분석/06. 과제 3')
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("forecast")
library("tseries")
data <- read_excel("./J12.xlsx")$서울사망자
data

# Assuming 'Month' is the column containing the dates and 'Deaths' is the column containing the number of deaths
ts_data <- ts(data, frequency = 12)

# Log transformation
log_ts_data <- log(ts_data)

# Plot original and log-transformed series
plot(ts_data, main = "Original Time Series")
plot(log_ts_data, main = "Log-Transformed Time Series")

# Check stationarity of log-transformed series
adf_test <- adf.test(log_ts_data)
print(adf_test)

# Autocorrelation analysis
acf(log_ts_data)
pacf(log_ts_data)

# Model selection and fitting
# Example: ARIMA model
arima_model <- auto.arima(log_ts_data)
print(arima_model)

# Model evaluation
plot(forecast(arima_model))

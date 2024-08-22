install.packages("forecast")
getwd()
setwd('C:/Users/kwbae/OneDrive - postech.ac.kr/2024-1 POSTECH/06. 시계열분석/07. 과제 4')
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("forecast")
library("tseries")
data <- read_excel("./J08.xlsx")
colnames(data)
data <- data$...2
data
timeseries <- as.numeric(data[2:51])

arima_model <- arima(timeseries, order=c(1,0,0))

# Print the identified ARIMA model
print(arima_model)

# Print the identified ARIMA model
print(arima_model)

# Estimate the parameters of the identified ARIMA model
fitted_model <- arima(timeseries, order = arima_model$arma[c(1,6,2)])

# Print model summary
summary(fitted_model)

# Diagnostic checking for residuals
plot(fitted_model$residuals, main = "Residuals of ARIMA Model")
acf(fitted_model$residuals, main = "ACF of Residuals")
pacf(fitted_model$residuals, main = "PACF of Residuals")
Box.test(fitted_model$residuals, lag = 10, type = "Ljung-Box")

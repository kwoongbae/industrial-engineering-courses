install.packages("forecast")
install.packages("tseries")
getwd()
setwd('C:/Users/kwbae/OneDrive - postech.ac.kr/2024-1 POSTECH/06. 시계열분석/07. 과제 4')
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("forecast")
library("tseries")
data <- read_excel("./J12.xlsx")$서울사망자
data

# Assuming 'Month' is the column containing the dates and 'Deaths' is the column containing the number of deaths
arima_model <- arima(data, order = c(1, 0, 0))  # Example: ARIMA(1,0,1)

# Print model summary
summary(arima_model)

# Ljung-Box test for residuals
residuals <- residuals(arima_model)
Ljung_Box_test <- Box.test(residuals, lag = 10, type = "Ljung-Box")

# Print Ljung-Box test results
print(Ljung_Box_test)

install.packages("aTSA")
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("TTR") # DEMA
library("aTSA") # Holts
data <- read_excel("./J05.xlsx", range=cell_rows(8:48), col_names=c("year", "dollar"))
head(data)
prices <- round(as.numeric(data$dollar), 2)[2:41]

# ===============================
# Q1. Obtain double moving averages with N=3 and N=6, respectively and make graphs comparing with the original series.
# ===============================
df_ts_sma.3 <- TTR::SMA(prices, n=3)
df_ts_dma.3 <- TTR::SMA(df_ts_sma.3, n=3)
df_ts_sma.6 <- TTR::SMA(prices, n=6)
df_ts_dma.6 <- TTR::SMA(df_ts_sma.3, n=6)
df_ts_dma.6
plot(prices, type = "l", col = "blue", ylim = range(prices, df_ts_dma.3[5:40], df_ts_dma.6[8:40]), xlab = "Time", ylab = "Price")
lines(dema.3, col = "red")
lines(dema.6, col = "green")
legend("topleft", legend = c("Prices", "DMA (n=3)", "DMA (n=6)"), col = c("blue", "red", "green"), lty = 1)

# ===============================
# Q2. Obtain double moving averages with alpha=0.1 and alpha=0.3, respectively and make graphs comparing with the original series.
# ===============================
dema.0.1 <- DEMA(prices, n=2, ratio = 0.1)
dema.0.3 <- DEMA(prices, n=2, ratio = 0.3)
dema.0.3

plot(prices, type = "l", col = "blue", ylim = range(prices, dema.0.1[3:40], dema.0.3[3:40]), xlab = "Time", ylab = "Price")
lines(dema.0.1, col = "red")
lines(dema.0.3, col = "green")
legend("topleft", legend = c("Prices", "DEMA (a=0.1)", "DEMA (a=0.3)"), col = c("blue", "red", "green"), lty = 1)

# ===============================
# Q3. Apply Holt's model with alpha=0.1 to the data until 1999 and make one-step-ahead forecasts from 2000 to 2007. 
# Calculate forecasting performance measures based on the forecast errors.
# ===============================
x <- prices[1:22]
y <- prices[23:40]
forecast <- Holt(x, alpha = 0.1)
forecast$accurate

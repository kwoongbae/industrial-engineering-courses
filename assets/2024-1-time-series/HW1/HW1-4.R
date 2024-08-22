install.packages("aTSA")
# ===============================
# Import libraries and dataset
# ===============================
library("readxl") # read_excel
library("TTR") # DEMA
library("aTSA") # Holts
data <- read_excel("./J04.xlsx")$`quarterly electricity consumption in residential & commercial sector in Korea during 1997-2017`
data <- as.numeric(data[2:85])
head(data)

# ===============================
# Q1. Obtain suitable intial values for this model using data in first three years.
# ===============================
L.0 <- mean(data[1:12])
L.0 # 1583.917
b.0 <- 0
for (i in 1:4){
  for (j in 2:3){
    value <- (data[i+4*(j-1)]-data[i+4*(j-2)])/4
    b.0 <- b.0+value
  }
}
b.0 <- b.0/(2*4)
b.0 # 21.968

# ===============================
# Q2. Obtain smoothed values of level, trend, and seasonality using data from 2000 to 2004.
# ===============================
x.2000_2004 <- ts(data[13:32], frequency=4)
x.2000_2004
components_dfts.2000_2004 <- decompose(x.2000_2004)
plot(components_dfts.2000_2004)
hw.2000_2004 <- HoltWinters(x.2000_2004)
hw.2000_2004 # L_0=2957.474, b_0=64.375, s1=307.473, s2=-211.33, s3=-51.776, s4=-202.47

# ===============================
# Q3. Make one-step-ahead forecasts from year 2004 to 2017 and calculate forecast errors.
# ===============================
x.2004_2017 <- ts(data[29:length(data)], frequency=4)
x.2004_2017
hw.2004_2017 <- HoltWinters(x.2004_2017)
hw.2004_2017
hw.2004_2017.pred <- predict(hw.2004_2017)
hw.2004_2017.pred

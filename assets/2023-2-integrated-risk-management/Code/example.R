#################### Import Libraries #################### 
# install.packages("lubridate")
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
colnames(data)



df_reduced = data[, c("cyber_risk", "Description.of.Event","Natural.Disaster1", "Month...Year.of.Settlement", "Loss.Amount...M.")]
df_reduced$`Month...Year.of.Settlement` <- as.character(df_reduced$`Month...Year.of.Settlement`)
colnames(df_reduced) <- c("cyber_risk","description", "nat_risk", "year_month", "loss")
df_reduced$year_month <- as.Date(df_reduced$year_month)


min(df_reduced$year_month)
max(df_reduced$year_month)
length(df_reduced$year_month)


cyber.nat <- df_reduced[df_reduced$cyber_risk == 1, ]

cyber.nat$description[7]


cyber.nat <- df_reduced[df_reduced$cyber_risk == 1 & df_reduced$nat_risk == 1, ]
c(length(cyber.nat$cyber_risk))




# ==================================================== Description ====================================================== #
cyber.nat$description[1]
mean(cyber.nat$loss)




cyber.risk <- data[data$cyber_risk == 1, ]
nat.risk <- data[data$Natural.Disaster1 == 1, ]
op.risk <- data[data$Natural.Disaster1 == 0 & data$cyber_risk == 0, ]
cyber.nat <- data[data$Natural.Disaster1 == 1 & data$cyber_risk == 1, ]


xName <- c("avalanche", "blizzard", "cyclone", "drought", "earthquake", "flood", "hail", "hurricane", "ice", "landslide","snow",  "tornado", "tsunami", "typhoon", "wind", "storm")
xNum <- c(4,5,21,3,71,132, 16, 95, 37, 8, 37, 12, 33 ,8, 71, 197)
pie(xNum, labels = paste(xName, round(xNum)))


data <- data.frame(xName = xName, xNum = xNum)

ggplot(data, aes(x = xName, y = xNum, fill = xName)) +
  geom_bar(stat = "identity", width = 0.7, position = "dodge") +
  geom_text(aes(label = xNum),
            position = position_dodge(width = 0.7),
            vjust = -0.5, size = 3, color = "black") +
  labs(title = "Counts by risk category",
       x = "Category",
       y = "Count") +
  theme_minimal()




# ==================================================== cyber risk ====================================================== #

cyber.nat <- data.frame(table(cyber.nat$year_month))
colnames(cyber.nat) <- c("date","num")
cyber.nat$date <- ymd(cyber.nat$date)
cyber.nat <- cyber.nat[cyber.nat$date >= as.Date("2000-01-01"),]

cyber.nat$num

all_dates <- seq(min(as.Date(cyber.nat$date)), max(as.Date(cyber.nat$date)), by = "1 month")

missing_dates <- as.Date((setdiff(as.Date(all_dates), as.Date(cyber.nat$date))), origin = "1970-01-01")
missing_dates
missing_dates_df <- data.frame(date_column = missing_dates, value = 0)
colnames(missing_dates_df) <- c("date","num")

missing_dates_df$date <- as.factor(missing_dates_df$date)
missing_dates_df$num <- as.integer(missing_dates_df$num)

# cyber.freq <- data.frame(table(rbind(cyber, missing_dates_df)$num))

cyber.nat.freq <- sort(rbind(cyber.nat, missing_dates_df)$num)

cyber.nat.freq

length(cyber.nat.freq)
plotdist(cyber.nat.freq, histo = TRUE)



cyber.nat <- df_reduced[df_reduced$cyber_risk == 1 & df_reduced$nat_risk == 1, ]
loss <- cyber.nat$loss
plotdist(loss)
data.frame(table(loss))








cyber.risk <- df_reduced[df_reduced$cyber_risk == 1, ]
nat.risk <- df_reduced[df_reduced$nat_risk == 1, ]
op.risk <- df_reduced[df_reduced$nat_risk == 0 & df_reduced$cyber_risk == 0, ]
cyber.nat <- df_reduced[df_reduced$nat_risk == 1 & df_reduced$cyber_risk == 1, ]


sum(cyber.nat$loss) / (2021-1982+1)

sum(nat.risk$loss) / (2017-1987+1)

sum(op.risk$loss) / (2021-1971+1)

sum(cyber.nat$loss) / (2011-1998+1)




#===============
cyber.nat <- data[data$nat_risk == 1 & data$cyber_risk == 1, ]

cyber.nat
cyber.nat[5]
colnames(cyber.nat)

cyber.nat[15,4]

#===============
cyber <- data[data$cyber_risk == 1, ]

cyber$Description.of.Event[10]















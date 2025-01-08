## ----------------------------------------------------------------
## 1. Import Libraries and Load dataset
## ----------------------------------------------------------------

library(aod)
library(ggplot2)
library(MASS)
library(dplyr)
library(glmnet)
library(plotmo)
require(mgcv)
# install.packages("remotes")
# install.packages("devtools")
# devtools::install_github("cardiomoon/ggGam")
# library(ggGam)

data <- read.csv("./dataset/SAS.csv")
nat.risk <- data[data$nat_risk == 1, ]
length(nat.risk$Reference.ID.Code)
# colnames(cyber.risk)

nat <- data.frame(nat.risk$Loss.Amount...M.)


# cyber$current.loss <- as.numeric(cyber.risk$Current.Value.of.Loss...M.)
# cyber$basel.1 <- factor(cyber.risk$Basel.Business.Line...Level.1)
# cyber$basel.2 <- factor(cyber.risk$Basel.Business.Line...Level.2)
# cyber$business.unit <- factor(cyber.risk$Business.Unit)
# cyber$risk.category <- factor(cyber.risk$Event.Risk.Category)
nat$sub.risk <- factor(nat.risk$Sub.Risk.Category)
# nat$activity <- factor(nat.risk$Activity)
# cyber$legal.country <- factor(cyber.risk$Country.of.Legal.Entity)
nat$sector <- factor(nat.risk$Industry.Sector.Name)
nat$domicile.region <- factor(nat.risk$Region.of.Domicile)
# cyber$financial <- factor(cyber.risk$Financial.Information....F.or.P.)
nat$revenue <- nat.risk$Revenue...M.
# cyber$current.revenue <- cyber.risk$Current.Value.of.Revenue...M.
nat$assets <- nat.risk$Assets...M.
# cyber$shareholder <- cyber.risk$Shareholder.Equity...M.
nat$employees <- nat.risk$X..of.Employees
nat$net <- nat.risk$Net.Income...M.
nat$legal.liability <- nat.risk$Legal.Liability...M.
# cyber$regulatory.action <- cyber.risk$Regulatory.Action...M.
# cyber$local.currency <- cyber.risk$Reported.Loss.Amount..M..in.Local.Currency
# cyber$cpi <- cyber.risk$CPI.Adjustment
# cyber$financial.loss <- cyber.risk$Financial.Loss.Status

colnames(nat)[1] <- "loss"
nat <- na.omit(nat) 
sum(is.na(nat))
length(nat$loss)

## ----------------------------------------------------------------
## 2. Dummy variables
## ----------------------------------------------------------------

# Check the value counts
data.frame(table(nat$sector))

unique(nat$sector)

sub.risk.disaster <- ifelse(nat$sub.risk == 'Disasters and Other Events', 1, 0)
sub.risk.systems <- ifelse(nat$sub.risk == 'Systems', 1, 0)
region.north.america <- ifelse(nat$domicile.region == 'North America', 1, 0)
region.asia <- ifelse(nat$domicile.region == 'Asia', 1, 0)
region.Other.americas <- ifelse(nat$domicile.region == 'Other Americas', 1, 0)
region.africa <- ifelse(nat$domicile.region == 'Africa', 1, 0)
region.other <- ifelse(nat$domicile.region == 'Other', 1, 0)
sector.manufactoring <- ifelse(nat$sector == 'Manufactoring', 1, 0)
sector.construction <- ifelse(nat$sector == 'Construction', 1, 0)
sector.financial.services <- ifelse(nat$sector == 'Financial Services', 1, 0)
sector.utilities <- ifelse(nat$sector == 'Utilities', 1, 0)
sector.mining <- ifelse(nat$sector == 'Mining', 1, 0)
sector.public <- ifelse(nat$sector == 'Public Administration', 1, 0)
sector.wholesale.trade <- ifelse(nat$sector == 'Wholesale Trade', 1, 0)
sector.information <- ifelse(nat$sector == 'Information', 1, 0)
sector.transportation <- ifelse(nat$sector == 'Transportation and Warehousing', 1, 0)
sector.real.estate <- ifelse(nat$sector == 'Real Estate, Rental and Leasing', 1, 0)
sector.retail.trade <- ifelse(nat$sector == 'Retail Trade', 1, 0)
sector.agriculture <- ifelse(nat$sector == 'Agriculture, Forestry, Fishing and Hunting', 1, 0)
sector.arts <- ifelse(nat$sector == 'Arts, Entertainment and Recreation', 1, 0)
sector.accommodation <- ifelse(nat$sector == 'Accommodation and Foodservices', 1, 0)
sector.health <- ifelse(nat$sector == 'Health Care and Social Assistance', 1, 0)

colnames(nat)

new.nat <- data.frame(
  nat$loss,
  nat$assets,
  nat$employees,
  nat$revenue,
  nat$legal.liability,
  sub.risk.disaster, 
  sub.risk.systems,
  region.north.america,
  region.asia,
  region.Other.americas,
  region.africa,
  region.other,
  sector.manufactoring,
  sector.construction,
  sector.financial.services,
  sector.utilities,
  sector.mining,
  sector.public,
  sector.wholesale.trade,
  sector.information,
  sector.transportation,
  sector.real.estate,
  sector.retail.trade,
  sector.agriculture,
  sector.arts,
  sector.accommodation,
  sector.health
)

colnames(new.nat)

## ----------------------------------------------------------------
## 3.Lasso Variable Selection
## https://xiaorui.site/Data-Mining-R/lecture/3.C_LASSO.html
## https://inspiringpeople.github.io/data%20analysis/feature_selection/
## Lasso는 good lambda 값을 찾는 것이 중요함.
## ----------------------------------------------------------------


lasso_fit <- glmnet(x = as.matrix(new.nat[, -c(which(colnames(new.nat) == "nat.loss"))]), 
                    y = new.nat$nat.loss, alpha = 1)

coef(lasso_fit, s = 0.5) #lambda = 0.5
coef(lasso_fit, s = 1) #lambda = 1

# Draw the solution path of the LASSO selection results
plot(lasso_fit, xvar = "lambda", "label" = TRUE)
plot_glmnet(lasso_fit, label = TRUE)

# Use 5-fold cross-validation to search optimal labmda
cv_lasso_fit <- cv.glmnet(x = as.matrix(new.nat[, -c(which(colnames(new.nat) == "nat.loss"))]), 
                          y = log(new.nat$nat.loss), alpha = 1, nfolds = 5)
plot(cv_lasso_fit)

# The optimal lambda is 0.1116067
cv_lasso_fit$lambda.min

coef(lasso_fit, s = cv_lasso_fit$lambda.min)


## ----------------------------------------------------------------
## 4. GLM regression on loss severity
## ----------------------------------------------------------------

scope = log(nat.loss)~ nat.assets + nat.employees + nat.revenue + nat.legal.liability + 
  sub.risk.disaster + region.north.america + region.asia + region.Other.americas + region.africa + 
  region.other + sector.construction + sector.financial.services + sector.utilities + sector.mining + 
  sector.public + sector.wholesale.trade + sector.information + sector.transportation + 
  sector.real.estate + sector.retail.trade + sector.agriculture + sector.arts + sector.accommodation+ sector.health

result <- glm(scope, data = new.nat, family = gaussian(link = "identity"))

summary(result)

## ----------------------------------------------------------------
## 5. GLM regression on loss frequency
## ----------------------------------------------------------------

















## ----------------------------------------------------------------
## 2.Frequency and Severity respect to the region
## ----------------------------------------------------------------



result <- nat %>%
  group_by(domicile.region) %>%
  summarise(total_loss = sum(loss))

ggplot(nat, aes(x = domicile.region, y = loss, fill = domicile.region)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Loss by Domicile Region", x = "Domicile Region", y = "Total Loss") +
  theme_minimal()

ggplot(nat, aes(x = domicile.region, fill = domicile.region)) +
  geom_bar(stat = "count") +
  labs(title = "Frequency of Domicile Regions", x = "Domicile Region", y = "Frequency") +
  theme_minimal()

sum(nat$domicile.region=="Africa")



## ----------------------------------------------------------------
## 3. glm regression on loss severity
## ----------------------------------------------------------------


result <- glm(log(loss)~., data = nat, family = gaussian)

summary(result)


## ----------------------------------------------------------------
## 4. glm regression on loss frequency
## ----------------------------------------------------------------








## ----------------------------------------------------------------
## 4. What about the frequency of natural disasters in different regions?
## ----------------------------------------------------------------


unique(nat$sub.risk)


unique(cyber.risk$)
nat.risk$Region.of.Domicile #거주지역
nat.risk$Country.of.Legal.Entity #법인국가

nat.risk.region <- nat.risk[["Loss.Amount...M."], ["Region.of.Domicile"]]

result <- 
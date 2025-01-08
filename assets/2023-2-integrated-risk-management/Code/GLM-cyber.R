## ----------------------------------------------------------------
## 1. Import Libraries and Load dataset
## ----------------------------------------------------------------

library(aod)
library(ggplot2)
library(MASS)
# install.packages("plotmo")
library(dplyr)
library(glmnet)
library(plotmo)
# require(mgcv)
# install.packages("remotes")
# install.packages("devtools")
# devtools::install_github("cardiomoon/ggGam")
# library(ggGam)

data <- read.csv("./dataset/SAS.csv")
cyber.risk <- data[data$cyber_risk == 1, ]
length(cyber.risk$Reference.ID.Code)
# colnames(cyber.risk)

cyber <- data.frame(cyber.risk$Loss.Amount...M.)

# cyber$current.loss <- as.numeric(cyber.risk$Current.Value.of.Loss...M.)
# cyber$basel.1 <- factor(cyber.risk$Basel.Business.Line...Level.1)
# cyber$basel.2 <- factor(cyber.risk$Basel.Business.Line...Level.2)
# cyber$business.unit <- factor(cyber.risk$Business.Unit)
# unique(cyber$business.unit)
# cyber$risk.category <- factor(cyber.risk$Event.Risk.Category)
cyber$sub.risk <- factor(cyber.risk$Sub.Risk.Category)
# nat$activity <- factor(nat.risk$Activity)
# cyber$legal.country <- factor(cyber.risk$Country.of.Legal.Entity)
cyber$sector <- factor(cyber.risk$Industry.Sector.Name)
cyber$domicile.region <- factor(cyber.risk$Region.of.Domicile)
# cyber$financial <- factor(cyber.risk$Financial.Information....F.or.P.)
cyber$revenue <- cyber.risk$Revenue...M.
# cyber$current.revenue <- cyber.risk$Current.Value.of.Revenue...M.
cyber$assets <- cyber.risk$Assets...M.
# cyber$shareholder <- cyber.risk$Shareholder.Equity...M.
cyber$employees <- cyber.risk$X..of.Employees
cyber$net <- cyber.risk$Net.Income...M.
cyber$legal.liability <- cyber.risk$Legal.Liability...M.
# cyber$regulatory.action <- cyber.risk$Regulatory.Action...M.
# unique(cyber$regulatory.action)
# cyber$local.currency <- cyber.risk$Reported.Loss.Amount..M..in.Local.Currency
# cyber$cpi <- cyber.risk$CPI.Adjustment
# cyber$financial.loss <- cyber.risk$Financial.Loss.Status

colnames(cyber)[1] <- "loss"
cyber <- na.omit(cyber)
sum(is.na(cyber))
length(cyber$loss)

## ----------------------------------------------------------------
## 2. Dummy variables
## ----------------------------------------------------------------

# Check the value counts
data.frame(table(cyber$sub.risk))

unique(cyber$sector)

sub.risk.customer.intake <- ifelse(cyber$sub.risk == 'Customer Intake and Documentation', 1, 0)
sub.risk.account.management <- ifelse(cyber$sub.risk == 'Customer/Client Account Management', 1, 0)
sub.risk.disaster <- ifelse(cyber$sub.risk == 'Disasters and Other Events', 1, 0)
sub.risk.employee <- ifelse(cyber$sub.risk == 'Employee Relations', 1, 0)
sub.risk.improper.business <- ifelse(cyber$sub.risk == 'Improper Business or Market Practices', 1, 0)
sub.risk.monitoring <- ifelse(cyber$sub.risk == 'Monitoring and Reporting', 1, 0)
sub.risk.product.flaws <- ifelse(cyber$sub.risk == 'Product Flaws', 1, 0)
sub.risk.selection <- ifelse(cyber$sub.risk == 'Selection, Sponsorship & Exposure', 1, 0)
sub.risk.customer <- ifelse(cyber$sub.risk == 'Customer Intake and Documentation', 1, 0)
sub.risk.suitability <- ifelse(cyber$sub.risk == 'Suitability, Disclosure & Fiduciary', 1, 0)
sub.risk.systems <- ifelse(cyber$sub.risk == 'Systems', 1, 0)
sub.risk.systems.security <- ifelse(cyber$sub.risk == 'Systems Security', 1, 0)
sub.risk.thefts <- ifelse(cyber$sub.risk == 'Theft and Fraud', 1, 0)
sub.risk.transaction <- ifelse(cyber$sub.risk == 'Transaction Capture, Execution & Maintenance', 1, 0)
sub.risk.unauthorized <- ifelse(cyber$sub.risk == 'Unauthorized Activity', 1, 0)
sub.risk.vendors <- ifelse(cyber$sub.risk == 'Vendors & Suppliers', 1, 0)

region.north.america <- ifelse(cyber$domicile.region == 'North America', 1, 0)
region.asia <- ifelse(cyber$domicile.region == 'Asia', 1, 0)
region.Other.americas <- ifelse(cyber$domicile.region == 'Other Americas', 1, 0)
region.africa <- ifelse(cyber$domicile.region == 'Africa', 1, 0)
region.other <- ifelse(cyber$domicile.region == 'Other', 1, 0)
region.europe <- ifelse(cyber$domicile.region == 'Europe', 1, 0)

sector.financial.services <- ifelse(cyber$sector == 'Financial Services', 1, 0)
sector.retail.trade <- ifelse(cyber$sector == 'Retail Trade', 1, 0)
sector.professional <- ifelse(cyber$sector == "Professional, Scientific and Technical Services",1,0)
sector.manufactoring <- ifelse(cyber$sector == 'Manufactoring', 1, 0)
sector.information <- ifelse(cyber$sector == 'Information', 1, 0)
sector.arts <- ifelse(cyber$sector == 'Arts, Entertainment and Recreation', 1, 0)
sector.mining <- ifelse(cyber$sector == 'Mining', 1, 0)
sector.construction <- ifelse(cyber$sector == 'Construction', 1, 0)
sector.accommodation <- ifelse(cyber$sector == 'Accommodation and Foodservices', 1, 0)
sector.management <- ifelse(cyber$sector == 'Management of Companies and Enterprises', 1, 0)
sector.utilities <- ifelse(cyber$sector == 'Utilities', 1, 0)
sector.administrative <- ifelse(cyber$sector == 'Administrative and Support, Waste Management and Remediation Services', 1, 0)
sector.transportation <- ifelse(cyber$sector == 'Transportation and Warehousing', 1, 0)
sector.public <- ifelse(cyber$sector == 'Public Administration', 1, 0)
sector.wholesale.trade <- ifelse(cyber$sector == 'Wholesale Trade', 1, 0)
sector.health <- ifelse(cyber$sector == 'Health Care and Social Assistance', 1, 0)
sector.other <- ifelse(cyber$sector == 'Other Services (except Public Administration)', 1, 0)
sector.agriculture <- ifelse(cyber$sector == 'Agriculture, Forestry, Fishing and Hunting', 1, 0)
sector.real.estate <- ifelse(cyber$sector == 'Real Estate, Rental and Leasing', 1, 0)
sector.non.profit <- ifelse(cyber$sector == 'Non-Profit Organizations', 1, 0)
sector.educational <- ifelse(cyber$sector == 'Educational Services', 1, 0)


colnames(cyber)
length(cyber$revenue)

new.cyber <- data.frame(
  cyber$loss,
  cyber$assets,
  cyber$employees,
  cyber$revenue,
  cyber$legal.liability,
  sub.risk.customer.intake,
  sub.risk.account.management,
  sub.risk.disaster ,
  sub.risk.employee ,
  sub.risk.improper.business ,
  sub.risk.monitoring ,
  sub.risk.product.flaws ,
  sub.risk.selection ,
  sub.risk.suitability ,
  sub.risk.customer ,
  sub.risk.systems ,
  sub.risk.systems.security ,
  sub.risk.thefts ,
  sub.risk.transaction ,
  sub.risk.unauthorized ,
  sub.risk.vendors ,
  region.north.america ,
  region.asia ,
  region.Other.americas ,
  region.africa ,
  region.other,
  region.europe ,
  sector.financial.services ,
  sector.retail.trade ,
  sector.professional ,
  sector.manufactoring ,
  sector.information ,
  sector.arts ,
  sector.mining ,
  sector.construction ,
  sector.accommodation ,
  sector.management ,
  sector.utilities ,
  sector.administrative ,
  sector.transportation ,
  sector.public ,
  sector.wholesale.trade ,
  sector.health ,
  sector.other ,
  sector.agriculture ,
  sector.real.estate ,
  sector.non.profit ,
  sector.educational 
)

colnames(new.cyber)

## ----------------------------------------------------------------
## 3.Lasso Variable Selection
## https://xiaorui.site/Data-Mining-R/lecture/3.C_LASSO.html
## https://inspiringpeople.github.io/data%20analysis/feature_selection/
## Lasso는 good lambda 값을 찾는 것이 중요함.
## ----------------------------------------------------------------


lasso_fit <- glmnet(x = as.matrix(new.cyber[, -c(which(colnames(new.cyber) == "cyber.loss"))]), 
                    y = new.cyber$cyber.loss, alpha = 1)

coef(lasso_fit, s = 0.5) #lambda = 0.5
coef(lasso_fit, s = 1) #lambda = 1

# Draw the solution path of the LASSO selection results
plot(lasso_fit, xvar = "lambda", "label" = TRUE)
plot_glmnet(lasso_fit, label = TRUE)

# Use 5-fold cross-validation to search optimal labmda
cv_lasso_fit <- cv.glmnet(x = as.matrix(new.cyber[, -c(which(colnames(new.cyber) == "cyber.loss"))]), 
                          y = log(new.cyber$cyber.loss), alpha = 1, nfolds = 5)
plot(cv_lasso_fit)

# The optimal lambda is 0.04886459
cv_lasso_fit$lambda.min

coef(lasso_fit, s = cv_lasso_fit$lambda.min)


## ----------------------------------------------------------------
## 3. GLM regression
## ----------------------------------------------------------------

scope = log(cyber.loss) ~ cyber.assets + cyber.employees + cyber.revenue + cyber.legal.liability + 
  sub.risk.customer.intake + sub.risk.account.management + sub.risk.disaster + sub.risk.improper.business + 
  sub.risk.monitoring + sub.risk.product.flaws + sub.risk.selection + sub.risk.suitability + 
  sub.risk.customer + sub.risk.systems + sub.risk.systems.security + sub.risk.transaction + 
  sub.risk.unauthorized + sub.risk.vendors + region.north.america + region.asia + region.Other.americas + 
  region.africa + region.other + sector.financial.services + sector.retail.trade + 
  sector.professional + sector.information + sector.arts + sector.mining + 
  sector.construction + sector.accommodation + sector.management + sector.utilities + sector.administrative + 
  sector.transportation + sector.public + sector.wholesale.trade+ sector.health + sector.other + 
  sector.agriculture + sector.real.estate + sector.non.profit + sector.educational

result <- glm(scope, data = new.cyber, family = gaussian(link = "identity"))

summary(result)


## ----------------------------------------------------------------
## 4. GAM regression
## ----------------------------------------------------------------

gam.m <- gam(scope, data = new.cyber, method = "REML")
summary(gam.m)




## ----------------------------------------------------------------
## 2.Frequency and Severity respect to the region
## ----------------------------------------------------------------
a = 3.373/0.2221
b = 2*pt(a,1,lower.tail=FALSE)
b
p = 0.000754
diff = 100000

for (i in 1:50){
  b = 2*pt(a,i,lower.tail=FALSE)
  if (diff>abs(b-p)){
    diff <- abs(b-p)
  }
  print(b)
  print("3"+diff)
}

print(b)
print(p)
abs(1-3)

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
## 3. glm regression
## ----------------------------------------------------------------


result <- glm(log(loss)~., data = nat, family = gaussian)

summary(result)



## ----------------------------------------------------------------
## 4. What about the frequency of natural disasters in different regions?
## ----------------------------------------------------------------


unique(nat$sub.risk)


unique(cyber.risk$)
nat.risk$Region.of.Domicile #거주지역
nat.risk$Country.of.Legal.Entity #법인국가

nat.risk.region <- nat.risk[["Loss.Amount...M."], ["Region.of.Domicile"]]

result <- 
## ----------------------------------------------------------------
## 1. Import Libraries and Load dataset
## ----------------------------------------------------------------

library(aod)
library(ggplot2)
library(MASS)


?lm 
data <- read.csv("./dataset/SAS.csv")
nat.risk <- data[data$nat_risk == 1, ]
nat <- data.frame(nat.risk$Loss.Amount...M.)
# nat$current.loss <- as.numeric(nat.risk$Current.Value.of.Loss...M.)
# nat$basel.1 <- factor(nat.risk$Basel.Business.Line...Level.1)
# length(unique(nat$basel.1))
# nat$basel.2 <- factor(nat.risk$Basel.Business.Line...Level.2)
# length(unique(nat$basel.2))
# nat$business.unit <- factor(nat.risk$Business.Unit)
# nat$risk.category <- factor(nat.risk$Event.Risk.Category)
# length(unique(nat$risk.category))
nat$sub.risk <- factor(nat.risk$Sub.Risk.Category)
# nat$activity <- factor(nat.risk$Activity)
# nat$legal.country <- factor(nat.risk$Country.of.Legal.Entity)
nat$sector <- factor(nat.risk$Industry.Sector.Name)
nat$domicile.region <- factor(nat.risk$Region.of.Domicile)
# nat$financial <- factor(nat.risk$Financial.Information....F.or.P.)
# length(unique(nat$financial))
# nat$revenue <- nat.risk$Revenue...M.
# nat$current.revenue <- nat.risk$Current.Value.of.Revenue...M.
# nat$assets <- nat.risk$Assets...M.
# nat$shareholder <- nat.risk$Shareholder.Equity...M.
nat$employees <- nat.risk$X..of.Employees
# nat$net <- nat.risk$Net.Income...M.
nat$legal.liability <- nat.risk$Legal.Liability...M.
# nat$regulatory.action <- nat.risk$Regulatory.Action...M.
# nat$local.currency <- nat.risk$Reported.Loss.Amount..M..in.Local.Currency
# nat$cpi <- nat.risk$CPI.Adjustment
# nat$financial.loss <- nat.risk$Financial.Loss.Status
colnames(nat)[1] <- "loss"

nat <- na.omit(nat) 
length(nat)
sum(is.na(nat))
length(nat$loss)
colnames(nat)

nat

## ----------------------------------------------------------------
## Selection small version example
## ----------------------------------------------------------------




categorical.variables = colnames(nat)[c(3,4,5,6,7,8,9,10,11,12)]

for (i in c(3,4,5,6,7,8,9,10,11,12)){
# for (i in c(3)){
  # print(colnames(nat[i]))
  variable <- colnames(nat[i])
  formula_object <- as.formula(paste("~", variable))
  dummy_variables <- model.matrix(formula_object, data = nat)
  # print(colnames(dummy_variables)[c(2,3,4,5)])
  # print(dummy_variables[,2])
  
  
  for (i in c(3:length(colnames(dummy_variables)))){
    variable <- colnames(dummy_variables)[i]
    # print(i)
    # print(dummy_variables[,5])
    # print(dummy_variables)
    nat[[variable]] <- dummy_variables[,i]
    # print(nat[[variable]])
  }
  
  # nat[[dumm]]
}





length(nat)

scopeunique(nat$basel.1)

scope.small = loss~current.loss+basel.1+basel.2+business.unit+risk.category+sub.risk+
  activity+legal.country+sector+domicile.region+financial+revenue+current.revenue+assets+
  shareholder+employees+net+legal.liability+regulatory.action+local.currency+cpi+financial.loss



unique(nat$activity)

dummy_variables.small <- model.matrix(~basel.1, data = nat)

colnames(dummy_variables.small[,-1])

scope.small = loss ~ current.losss


model.small <- lm(scope.small, data = nat)


summary(model.small)$coefficient

step.forward = stepAIC(scope = model.small, direction = "forward", scope = scope.small)


## ----------------------------------------------------------------
## 2. Forward Selection 
## https://github.com/hakeemrehman/Regression-Analysis/blob/main/Multivariate%20Regression%20Analysis.R
## https://www.statology.org/dummy-variables-in-r/
## ----------------------------------------------------------------

# Create dummy variables using ifelse
unique(nat$basel.1)
basel.1.non.fs <- ifelse(nat$basel.1 == 'Non-FS', 1, 0)
basel.1.insurance <- ifelse(nat$basel.1 == 'Insurnace', 1, 0)
basel.1.retail.banking <- ifelse(nat$basel.1 == "Retail Banking", 1,0 )
basel.1.commercial.banking <- ifelse(nat$basel.1 == "Commercial Banking", 1,0)
basel.1.payment.and.settlement <- ifelse(nat$basel.1 == "Payment and Settlement", 1, 0)

scope = loss ~ current.loss + revenue + current.revenue + assets + shareholder +
  employees + net + legal.liability + regulatory.action + local.currency + cpi + financial.loss +
  basel.1.non.fs + basel.1.insurance + basel.1.insurance + basel.1.retail.banking + 
  basel.1.commercial.banking + basel.1.payment.and.settlement


scope = loss ~ current.loss + revenue + current.revenue + assets + shareholder +
  employees + net + legal.liability + regulatory.action + local.currency + cpi + financial.loss +
basel.1 + basel.2 + business.unit + risk.category + sub.risk + activity +
  legal.country + sector + domicile.region + financial


dummy_variables <- model.matrix(~ basel.1, data = nat)

head(dummy_variables)

dummy_variables[,"basel.1Insurance"]
dummy_variables[2,]


colnames(dummy_variables)

model.1 = lm(scope, data = nat)

summary(model.1)


step.forward = stepAIC(model.1, direction = "forward", scope = scope)



## ----------------------------------------------------------------
## 3. Backward Selection 
## ----------------------------------------------------------------

model.2 = lm(scope.small, data = nat)
step.backward = stepAIC(model.2, direction = "backward")


dummy_variables <- model.matrix(~ basel.1, data = nat)


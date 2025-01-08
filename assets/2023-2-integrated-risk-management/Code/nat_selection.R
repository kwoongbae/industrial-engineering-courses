library(aod)
library(ggplot2)
library(MASS)

############### Import Library and cyber risk dataset ###############
data <- read.csv("./dataset/SAS.csv")

nat.risk <- data[data$nat_risk == 1, ]

############### cyber risk selection ###############
colnames(nat.risk)

nat <- data.frame(nat.risk$Loss.Amount...M.)
nat$current.loss <- as.numeric(nat.risk$Current.Value.of.Loss...M.)
nat$basel.1 <- factor(nat.risk$Basel.Business.Line...Level.1)
nat$basel.2 <- factor(nat.risk$Basel.Business.Line...Level.2)
nat$business.unit <- factor(nat.risk$Business.Unit)
nat$risk.category <- factor(nat.risk$Event.Risk.Category)
nat$risk.category
nat$sub.risk <- factor(nat.risk$Sub.Risk.Category)
nat$activity <- factor(nat.risk$Activity)
nat$legal.country <- factor(nat.risk$Country.of.Legal.Entity)
nat$sector <- factor(nat.risk$Industry.Sector.Name)
nat$domicile.region <- factor(nat.risk$Region.of.Domicile)
nat$financial <- factor(nat.risk$Financial.Information....F.or.P.)
nat$revenue <- nat.risk$Revenue...M.
nat$current.revenue <- nat.risk$Current.Value.of.Revenue...M.
nat$assets <- nat.risk$Assets...M.
nat$shareholder <- nat.risk$Shareholder.Equity...M.
nat$employees <- nat.risk$X..of.Employees
nat$net <- nat.risk$Net.Income...M.
nat$legal.liability <- nat.risk$Legal.Liability...M.
nat$regulatory.action <- nat.risk$Regulatory.Action...M.
nat$local.currency <- nat.risk$Reported.Loss.Amount..M..in.Local.Currency
nat$cpi <- nat.risk$CPI.Adjustment
nat$financial.loss <- nat.risk$Financial.Loss.Status

# table(nat$risk.category)

colnames(nat)[1] <- "loss"

nat <- na.omit(nat) 
sum(is.na(nat))
length(nat$loss)

table(nat$activity)

unique(nat$current.revenue)
############### forward selection ###############

scope = loss~current.loss+basel.1+basel.2+business.unit+risk.category+sub.risk+
  activity+legal.country+sector+domicile.region+financial+revenue+current.revenue+assets+
  shareholder+employees+net+legal.liability+regulatory.action+local.currency+cpi+financial.loss

model.1 = lm(loss ~1, data = nat)



step.forward = stepAIC(model.1, direction = "forward", scope = scope)


############### backward selection ###############
model.2 = lm(scope, data = nat)
step.backward = stepAIC(model.2, direction = "backward")

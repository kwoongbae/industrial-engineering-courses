library(aod)
library(ggplot2)
library(MASS)

############### Import Library and cyber risk dataset ###############
data <- read.csv("./dataset/SAS.csv")

op.risk <- data[data$nat_risk == 0 & data$cyber_risk == 0,]

############### cyber risk selection ###############
colnames(op.risk)

op <- data.frame(op.risk$Loss.Amount...M.)
op$current.loss <- as.numeric(op.risk$Current.Value.of.Loss...M.)
op$basel.1 <- factor(op.risk$Basel.Business.Line...Level.1)
op$basel.2 <- factor(op.risk$Basel.Business.Line...Level.2)
op$business.unit <- factor(op.risk$Business.Unit)
op$risk.category <- factor(op.risk$Event.Risk.Category)
op$sub.risk <- factor(op.risk$Sub.Risk.Category)
op$activity <- factor(op.risk$Activity)
op$legal.country <- factor(op.risk$Country.of.Legal.Entity)
op$sector <- factor(op.risk$Industry.Sector.Name)
op$domicile.region <- factor(op.risk$Region.of.Domicile)
op$financial <- factor(op.risk$Financial.Information....F.or.P.)
op$revenue <- op.risk$Revenue...M.
op$current.revenue <- op.risk$Current.Value.of.Revenue...M.
op$assets <- op.risk$Assets...M.
op$shareholder <- op.risk$Shareholder.Equity...M.
op$employees <- op.risk$X..of.Employees
op$net <- op.risk$Net.Income...M.
op$legal.liability <- op.risk$Legal.Liability...M.
op$regulatory.action <- op.risk$Regulatory.Action...M.
op$local.currency <- op.risk$Reported.Loss.Amount..M..in.Local.Currency
op$cpi <- op.risk$CPI.Adjustment
op$financial.loss <- op.risk$Financial.Loss.Status

colnames(op)[1] <- "loss"

op <- na.omit(op) 
sum(is.na(op))
length(op$loss)

############### forward selection ###############
model.1 = lm(loss ~1, data = op)
scope = loss~current.loss+basel.1+basel.2+business.unit+risk.category+sub.risk+
  activity+legal.country+sector+domicile.region+financial+revenue+current.revenue+assets+
  shareholder+employees+net+legal.liability+regulatory.action+local.currency+cpi+financial.loss

step.forward = stepAIC(model.1, direction = "forward", scope = scope)


############### backward selection ###############
model.2 = lm(scope, data = op)
step.backward = stepAIC(model.2, direction = "backward")

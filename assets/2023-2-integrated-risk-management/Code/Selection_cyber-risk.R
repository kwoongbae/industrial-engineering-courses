library(aod)
library(ggplot2)
library(MASS)


############### Import Library and cyber risk dataset ###############
data <- read.csv("./dataset/SAS.csv")
# length(data$Reference.ID.Code)
cyber.risk <- data[data$cyber_risk == 1, ]
length(cyber.risk$Reference.ID.Code)
############### cyber risk selection ###############
colnames(cyber.risk)

cyber <- data.frame(cyber.risk$Loss.Amount...M.)

# cyber$current.loss <- as.numeric(cyber.risk$Current.Value.of.Loss...M.)
# cyber$basel.1 <- factor(cyber.risk$Basel.Business.Line...Level.1)
# cyber$basel.2 <- factor(cyber.risk$Basel.Business.Line...Level.2)
# cyber$business.unit <- factor(cyber.risk$Business.Unit)
# cyber$risk.category <- factor(cyber.risk$Event.Risk.Category)
cyber$sub.risk <- factor(cyber.risk$Sub.Risk.Category)
cyber$activity <- factor(cyber.risk$Activity)
# cyber$legal.country <- factor(cyber.risk$Country.of.Legal.Entity)
cyber$sector <- factor(cyber.risk$Industry.Sector.Name)
cyber$domicile.region <- factor(cyber.risk$Region.of.Domicile)
# cyber$financial <- factor(cyber.risk$Financial.Information....F.or.P.)
# cyber$revenue <- cyber.risk$Revenue...M.
# cyber$current.revenue <- cyber.risk$Current.Value.of.Revenue...M.
# cyber$assets <- cyber.risk$Assets...M.
# cyber$shareholder <- cyber.risk$Shareholder.Equity...M.
cyber$employees <- cyber.risk$X..of.Employees
# cyber$net <- cyber.risk$Net.Income...M.
# cyber$legal.liability <- cyber.risk$Legal.Liability...M.
# cyber$regulatory.action <- cyber.risk$Regulatory.Action...M.
# cyber$local.currency <- cyber.risk$Reported.Loss.Amount..M..in.Local.Currency
# cyber$cpi <- cyber.risk$CPI.Adjustment
# cyber$financial.loss <- cyber.risk$Financial.Loss.Status

colnames(cyber)[1] <- "loss"


cyber <- na.omit(cyber) 
sum(is.na(cyber))
length(cyber$loss)


unique(cyber$risk.category)
unique(cyber$sub.risk)


cyber$sector
cyber$loss
############### forward selection ###############
model.1 = lm(scope, data = cyber)

summary(model.1)

scope = loss~current.loss+basel.1+basel.2+business.unit+risk.category+sub.risk+
  activity+legal.country+sector+domicile.region+financial+revenue+current.revenue+assets+
  shareholder+employees+net+legal.liability+regulatory.action+local.currency+cpi+financial.loss

step.forward = stepAIC(model.1, direction = "forward", scope = scope)

colnames(cyber)

cor_matrix <- cor(cyber[,c()])


############### backward selection ###############
model.2 = lm(scope, data = cyber)
step.backward = stepAIC(model.2, direction = "backward")

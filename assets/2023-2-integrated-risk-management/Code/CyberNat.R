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
length(data$Reference.ID.Code)


cybernat.risk <- data[data$nat_risk == 1 &data$cyber_risk == 1,]
length(cybernat.risk$Firm.Name)

cyber.nat <- data.frame(cybernat.risk$Loss.Amount...M.)
cyber.nat$legal.liability <- cybernat.risk$Legal.Liability...M.
cyber.nat$assets <- cybernat.risk$Assets...M.
cyber.nat$sub.risk <- factor(cybernat.risk$Sub.Risk.Category)
cyber.nat$sector <- factor(cybernat.risk$Industry.Sector.Name)
cyber.nat$domicile.region <- factor(cybernat.risk$Region.of.Domicile)
cyber.nat$description <- cybernat.risk$Description.of.Event

colnames(cyber.nat)[1] <- "loss"
length(cyber.nat$loss)

## ----------------------------------------------------------------
## 2. Shows the cases of CyberNat
## ----------------------------------------------------------------
cyber.nat


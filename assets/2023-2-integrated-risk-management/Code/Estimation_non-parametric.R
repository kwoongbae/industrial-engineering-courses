#################### Import Libraries #################### 
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
cyber.nat <- data[data$cyber_risk == 1 & data$nat_risk == 1,]
length(cyber.nat$nat_risk)
des <- cyber.nat$Description.of.Event
des[12]

ano <- data[data$nat_risk==1 & data$Natural.Disaster1 ==0, ]
length(ano$nat_risk)
ano$Description.of.Event[1]


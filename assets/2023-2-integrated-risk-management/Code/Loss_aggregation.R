library(MASS)
library(stats4)
library("extraDistr")
library("VGAM")
library("fitdistrplus")

n <- 1000000
prob <- 0.01700466
meanlog <- 1.664
sdlog <- 2.106

# 벡터 x를 받아서 첫 번째 원소는 1로 설정하고 나머지는 0으로 만드는 함수.
Set.zeroes = function(x){
  multiplier <- c(rep(1, x[1]), rep(0, length(x) -1 -x[1]))
  x<- x[-1]*multiplier
}


# MCMC Simulation for Loss data
claim.count <- rzigeom(n, prob)
max.claim.count <- max(claim.count)

# Create a matrix of n x max.claim.count individual losses
ind.losses <- rlnorm(n*max.claim.count, meanlog <- meanlog, sdlog <- sdlog)
loss.amounts <- matrix(ind.losses, ncol = max.claim.count)
loss.matrix <- cbind(claim.count, loss.amounts)

data <- loss.amounts[1:10000]
max(data)




plotdist(data)
mean(loss.amounts[1:100])
head(loss.matrix)

# Retain only the first claim.count losses
losses <- t(apply(loss.matrix, 1, Set.zeroes))
agg.losses <- apply(losses, 1, sum) # calculate the aggregate losses for each scenario
summary(agg.losses)


######################## plotting ##########################
library(ggplot2)
breaks <- pretty(range(agg.losses), n = nclass.FD(agg.losses), min = 1)
bwidth <- breaks[2]-breaks[1]
df <- data.frame(log(agg.losses))
ggplot(df, aes(agg.losses)) + geom_histogram(binwidth = bwidth, fill= "white", colour = "deepskyblue4")
plotdist(df)
colnames(df)
plotdist(df$log.agg.losses.)

# plotdist(claim.count)

# plotdist(log(rlnorm(1000, meanlog, sdlog)))

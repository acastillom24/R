#### Example 9-1

## ------------------------------------------------------------------------
library("plm")

## ------------------------------------------------------------------------
data("Dialysis", package = "pder")
rndcoef <- pvcm(log(diffusion / (1 - diffusion)) ~ trend + trend:regulation, 
                 Dialysis, model="random")
summary(rndcoef)

## ------------------------------------------------------------------------
cbind(coef(rndcoef), stdev = sqrt(diag(rndcoef$Delta)))


#### Example 9-2

## ------------------------------------------------------------------------
data("HousePricesUS", package = "pder")
swmod <- pvcm(log(price) ~ log(income), data = HousePricesUS, model= "random")
mgmod <- pmg(log(price) ~ log(income), data = HousePricesUS, model = "mg")
coefs <- cbind(coef(swmod), coef(mgmod))
dimnames(coefs)[[2]] <- c("Swamy", "MG")
coefs


#### Example 9-3

## ------------------------------------------------------------------------
library("texreg")
data("RDSpillovers", package = "pder")
fm.rds <- lny ~ lnl + lnk + lnrd
mg.rds <- pmg(fm.rds, RDSpillovers, trend = TRUE)
dmg.rds <- update(mg.rds, . ~ lag(lny) + .)
screenreg(list('Static MG' = mg.rds, 'Dynamic MG'= dmg.rds), digits = 3) 

## ------------------------------------------------------------------------
library("msm")
b.lr <- coef(dmg.rds)["lnrd"]/(1 - coef(dmg.rds)["lag(lny)"])
SEb.lr <- deltamethod(~ x5 / (1 - x2),
                      mean = coef(dmg.rds), cov = vcov(dmg.rds))
z.lr <- b.lr / SEb.lr
pval.lr <- 2 * pnorm(abs(z.lr), lower.tail = FALSE)
lr.lnrd <- matrix(c(b.lr, SEb.lr, z.lr, pval.lr), nrow=1)
dimnames(lr.lnrd) <- list("lnrd (long run)", c("Est.", "SE", "z", "p.val"))
round(lr.lnrd, 3)


#### Example 9-4

## ------------------------------------------------------------------------
housep.np <- pvcm(log(price) ~ log(income), data = HousePricesUS, model = "within")
housep.pool <- plm(log(price) ~ log(income), data = HousePricesUS, model = "pooling")
housep.within <- plm(log(price) ~ log(income), data = HousePricesUS, model = "within")

d <- data.frame(x = c(coef(housep.np)[[1]], coef(housep.np)[[2]]), 
                coef = rep(c("intercept", "log(income)"), 
                           each = nrow(coef(housep.np))))
library("ggplot2")
ggplot(d, aes(x)) + geom_histogram(col = "black", fill = "white", bins = 8) +
    facet_wrap(~ coef, scales = "free") + xlab("") + ylab("")


## ------------------------------------------------------------------------
summary(housep.np)

## ------------------------------------------------------------------------
pooltest(housep.pool, housep.np)
pooltest(housep.within, housep.np)


#### Example 9-5

## ------------------------------------------------------------------------
library("texreg")
cmgmod <- pmg(log(price) ~ log(income), data = HousePricesUS, model = "cmg")
screenreg(list(mg = mgmod, ccemg = cmgmod), digits = 3)


#### Example 9-6

## ------------------------------------------------------------------------
ccemgmod <- pcce(log(price) ~ log(income), data=HousePricesUS, model="mg")
summary(ccemgmod)

## ------------------------------------------------------------------------
ccepmod <- pcce(log(price) ~ log(income), data=HousePricesUS, model="p")
summary(ccepmod)


#### Example 9-7

## ------------------------------------------------------------------------
ccep.rds <- pcce(fm.rds, RDSpillovers, model="p")
library(lmtest)
ccep.tab <- cbind(coeftest(ccep.rds)[, 1:2],
                  coeftest(ccep.rds, vcov = vcovNW)[, 2],
                  coeftest(ccep.rds, vcov = vcovHC)[, 2])
dimnames(ccep.tab)[[2]][2:4] <- c("Nonparam.", "vcovNW", "vcovHC")
round(ccep.tab, 3)


## ------------------------------------------------------------------------
autoreg <- function(rho = 0.1, T = 100){
  e <- rnorm(T+1)
  for (t in 2:(T+1)) e[t] <- e[t]+rho*e[t-1]
  e
}
set.seed(20)

f <- data.frame(time = rep(0:40, 2), 
                rho = rep(c(0.2, 1), each = 41),
                y = c(autoreg(rho = 0.2, T = 40), 
                      autoreg(rho = 1, T = 40)))
library("ggplot2")
ggplot(f, aes(time, y)) + geom_line() + facet_wrap(~ rho) + xlab("") + ylab("")

## ------------------------------------------------------------------------
autoreg <- function(rho = 0.1, T = 100){
  e <- rnorm(T)
  for (t in 2:(T)) e[t] <- e[t] + rho *e[t-1]
  e
}
tstat <- function(rho = 0.1, T = 100){
  y <- autoreg(rho, T)
  x <- autoreg(rho, T)
  z <- lm(y ~ x)
  coef(z)[2] / sqrt(diag(vcov(z))[2])
}
result <- c()
R <- 1000
for (i in 1:R) result <- c(result, tstat(rho = 0.2, T = 40))
quantile(result, c(0.025, 0.975))
prop.table(table(abs(result) > 2))

## ------------------------------------------------------------------------
result <- c()
R <- 1000
for (i in 1:R) result <- c(result, tstat(rho = 1, T = 40))
quantile(result, c(0.025, 0.975))
prop.table(table(abs(result) > 2))

## ------------------------------------------------------------------------
R <- 1000
T <- 100
result <- c()
for (i in 1:R){
  y <- autoreg(rho=1, T=100)
  Dy <- y[2:T] - y[1:(T-1)]
  Ly <- y[1:(T-1)]
  z <- lm(Dy ~ Ly)
  result <- c(result, coef(z)[2] / sqrt(diag(vcov(z))[2]))
}

ggplot(data.frame(x = result), aes(x = x)) + 
    geom_histogram(fill = "white", col = "black", 
                   bins = 20, aes(y = ..density..)) +
    stat_function(fun = dnorm) + xlab("") + ylab("")

## ------------------------------------------------------------------------
prop.table(table(result < -1.64))


#### Example 9-8

## ------------------------------------------------------------------------
data("HousePricesUS", package = "pder")
price <- pdata.frame(HousePricesUS)$price
purtest(log(price), test = "levinlin", lags = 2, exo = "trend")
purtest(log(price), test = "madwu", lags = 2, exo = "trend")
purtest(log(price), test = "ips", lags = 2, exo = "trend")


#### Example 9-9

## ------------------------------------------------------------------------
tab5a <- matrix(NA, ncol = 4, nrow = 2)
tab5b <- matrix(NA, ncol = 4, nrow = 2)

for(i in 1:4) {
    mymod <- pmg(diff(log(income)) ~ lag(log(income)) + 
                 lag(diff(log(income)), 1:i),
                 data = HousePricesUS,
                 model = "mg", trend = TRUE)
    tab5a[1, i] <- pcdtest(mymod, test = "rho")$statistic
    tab5b[1, i] <- pcdtest(mymod, test =  "cd")$statistic
}

for(i in 1:4) {
    mymod <- pmg(diff(log(price)) ~ lag(log(price)) +
                 lag(diff(log(price)), 1:i),
                 data=HousePricesUS,
                 model="mg", trend = TRUE)
    tab5a[2, i] <- pcdtest(mymod, test = "rho")$statistic
    tab5b[2, i] <- pcdtest(mymod, test =  "cd")$statistic
}

tab5a <- round(tab5a, 3)
tab5b <- round(tab5b, 2)
dimnames(tab5a) <- list(c("income", "price"),
                        paste("ADF(", 1:4, ")", sep=""))
dimnames(tab5b) <- dimnames(tab5a)

tab5a
tab5b

## ------------------------------------------------------------------------
php <- pdata.frame(HousePricesUS)
cipstest(log(php$price), type = "drift")
cipstest(diff(log(php$price)), type = "none")

## ------------------------------------------------------------------------
cipstest(resid(ccemgmod), type="none")
cipstest(resid(ccepmod), type="none")



#### Example 1-1

## ------------------------------------------------------------------------
data("Fatalities", package="AER")
Fatalities$frate <- with(Fatalities, fatal / pop * 10000)
fm <- frate ~ beertax

## ------------------------------------------------------------------------
mod82 <- lm(fm, Fatalities, subset = year == 1982)
summary(mod82)

## ------------------------------------------------------------------------
mod88 <- update(mod82, subset = year == 1988)
library("lmtest")

coeftest(mod88)

## ------------------------------------------------------------------------
library("plm")
poolmod <- plm(fm, Fatalities, model="pooling")
coeftest(poolmod)

## ------------------------------------------------------------------------
dmod <- plm(diff(frate, 5) ~ diff(beertax, 5), Fatalities, model="pooling")
coef(dmod)

## ------------------------------------------------------------------------
lsdv.fm <- update(fm, . ~ . + state - 1)
lsdvmod <- lm(lsdv.fm, Fatalities)
coef(lsdvmod)[1]

## ------------------------------------------------------------------------
library("plm")
femod <- plm(fm, Fatalities)
coeftest(femod)


#### Example 1-2

## ------------------------------------------------------------------------
data("Tileries", package = "pder")
coef(summary(plm(log(output) ~ log(labor) + machine, data = Tileries,
             subset = area == "fayoum")))

## ------------------------------------------------------------------------
coef(summary(plm(log(output) ~ log(labor) + machine, data = Tileries,
             model = "pooling", subset = area == "fayoum")))


#### Example 1-3

## ------------------------------------------------------------------------
y <- Fatalities$frate
X <- cbind(1, Fatalities$beertax)
beta.hat <- solve(crossprod(X), crossprod(X,y))

## ------------------------------------------------------------------------
beta.hat
mod <- lm(frate ~ beertax, Fatalities)
coef(mod)

## ------------------------------------------------------------------------
LSDVmod <- lm(frate ~ beertax + state - 1, Fatalities)
coef(LSDVmod)["beertax"]

## ------------------------------------------------------------------------
attach(Fatalities)
frate.tilde <- frate - rep(tapply(frate, state, mean),
                           each = length(unique(year)))
beertax.tilde <- beertax - rep(tapply(beertax, state, mean),
                           each = length(unique(year)))
lm(frate.tilde ~ beertax.tilde - 1)
detach(Fatalities)

## ------------------------------------------------------------------------
summary(plm(fm, Fatalities))


#### Example 1-4

## ------------------------------------------------------------------------
w.mod <- plm(Within(frate) ~ Within(beertax) - 1, data=Fatalities,
             model = "pooling")
coef(w.mod)


#### Example 1-5

## ------------------------------------------------------------------------
data("Tileries", package = "pder")
til.fm <- log(output) ~ log(labor) + log(machine)
lm.mod <- lm(til.fm, data = Tileries, subset = area == "fayoum")

## ------------------------------------------------------------------------
library(car)
lht(lm.mod, "log(labor) + log(machine) = 1")

## ------------------------------------------------------------------------
library(car)
lht(lm.mod, "log(labor) + log(machine) = 1", vcov=vcovHC)


#### Example 1-6

## ------------------------------------------------------------------------
plm.mod <- plm(til.fm, data = Tileries, subset = area == "fayoum")

## ------------------------------------------------------------------------
library(car)
lht(plm.mod, "log(labor) + log(machine) = 1", vcov = vcovHC)


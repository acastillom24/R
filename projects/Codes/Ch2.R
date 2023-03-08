#### Example 2-1

## ------------------------------------------------------------------------
library(plm)
data("TobinQ", package = "pder")

## ------------------------------------------------------------------------
pTobinQ <- pdata.frame(TobinQ)
pTobinQa <- pdata.frame(TobinQ, index = 188)
pTobinQb <- pdata.frame(TobinQ, index = c('cusip'))
pTobinQc <- pdata.frame(TobinQ, index = c('cusip', 'year'))

## ------------------------------------------------------------------------
pdim(pTobinQ)

## ----results = 'hide'----------------------------------------------------
pdim(TobinQ, index = 'cusip')
pdim(TobinQ)

## ------------------------------------------------------------------------
head(index(pTobinQ))

## ------------------------------------------------------------------------
Qeq <- ikn ~ qn
Q.pooling <- plm(Qeq, pTobinQ, model = "pooling")
Q.within <- update(Q.pooling, model = "within")
Q.between <- update(Q.pooling, model = "between")

## ------------------------------------------------------------------------
Q.within
summary(Q.within)

## ------------------------------------------------------------------------
head(fixef(Q.within))
head(fixef(Q.within, type = "dfirst"))
head(fixef(Q.within, type = "dmean"))

## ------------------------------------------------------------------------
head(coef(lm(ikn ~ qn + factor(cusip), pTobinQ)))


#### Example 2-2

## ------------------------------------------------------------------------
Q.swar <- plm(Qeq, pTobinQ, model = "random", random.method = "swar")
Q.swar2 <- plm(Qeq, pTobinQ, model = "random",
               random.models = c("within", "between"),
               random.dfcor = c(2, 2))
summary(Q.swar)

## ------------------------------------------------------------------------
ercomp(Qeq, pTobinQ)
ercomp(Q.swar)

## ------------------------------------------------------------------------
Q.walhus <- update(Q.swar, random.method = "swar")
Q.amemiya <- update(Q.swar, random.method = "amemiya")
Q.nerlove <- update(Q.swar, random.method = "nerlove")
Q.models <- list(swar = Q.swar, walhus = Q.walhus,
                 amemiya = Q.amemiya, nerlove = Q.nerlove)
sapply(Q.models, function(x) ercomp(x)$theta)
sapply(Q.models, coef)


#### Example 2-3

## ------------------------------------------------------------------------
sapply(list(pooling = Q.pooling, within = Q.within,
            between = Q.between, swar = Q.swar),
       function(x) coef(summary(x))["qn", c("Estimate", "Std. Error")])

## ------------------------------------------------------------------------
summary(pTobinQ$qn)

## ------------------------------------------------------------------------
SxxW <- sum(Within(pTobinQ$qn) ^ 2)
SxxB <- sum((Between(pTobinQ$qn) - mean(pTobinQ$qn)) ^ 2)
SxxTot <- sum( (pTobinQ$qn - mean(pTobinQ$qn)) ^ 2)
pondW <- SxxW / SxxTot
pondW
pondW * coef(Q.within)[["qn"]] +
  (1 - pondW) * coef(Q.between)[["qn"]]

## ------------------------------------------------------------------------
T <- 35
N <- 188
smxt2 <- deviance(Q.between) * T / (N - 2)
sidios2 <- deviance(Q.within) / (N * (T - 1) - 1)
phi <- sqrt(sidios2 / smxt2)

## ------------------------------------------------------------------------
pondW <- SxxW / (SxxW + phi^2 * SxxB)
pondW
pondW * coef(Q.within)[["qn"]] +
  (1 - pondW) * coef(Q.between)[["qn"]]


#### Example 2-4

## ------------------------------------------------------------------------
data("ForeignTrade", package = "pder")
FT <- pdata.frame(ForeignTrade)
summary(FT$gnp)
ercomp(imports ~ gnp, FT)
models <- c("within", "random", "pooling", "between")
sapply(models, function(x) coef(plm(imports ~ gnp, FT, model = x))["gnp"])


#### Example 2-5

## ------------------------------------------------------------------------
data("TurkishBanks", package = "pder")
TurkishBanks <- na.omit(TurkishBanks)
TB <- pdata.frame(TurkishBanks)
summary(log(TB$output))
ercomp(log(cost) ~ log(output), TB)
sapply(models, function(x)
       coef(plm(log(cost) ~ log(output), TB, model = x))["log(output)"])


#### Example 2-6

## ------------------------------------------------------------------------
data("TexasElectr", package = "pder")
TexasElectr$cost <- with(TexasElectr, explab + expfuel + expcap)
TE <- pdata.frame(TexasElectr)
summary(log(TE$output))
ercomp(log(cost) ~ log(output), TE)
sapply(models, function(x)
       coef(plm(log(cost) ~ log(output), TE, model = x))["log(output)"])


#### Example 2-7

## ------------------------------------------------------------------------
data("DemocracyIncome25", package = "pder")
DI <- pdata.frame(DemocracyIncome25)
summary(lag(DI$income))
ercomp(democracy ~ lag(income), DI)
sapply(models, function(x)
       coef(plm(democracy ~ lag(income), DI, model = x))["lag(income)"])


#### Example 2-8

## ------------------------------------------------------------------------
Q.models2 <- lapply(Q.models, function(x) update(x, effect = "twoways"))
sapply(Q.models2, function(x) sqrt(ercomp(x)$sigma2))
sapply(Q.models2, function(x) ercomp(x)$theta)


#### Example 2-9

## ------------------------------------------------------------------------
data("UnionWage", package = "pglm")
pdim(UnionWage)

## ------------------------------------------------------------------------
UnionWage$exper2 <- with(UnionWage, exper ^ 2)
wages.within1 <- plm(wage ~ union + school + exper + exper2 +
                         com + rural + married + health +
                         region + sector, UnionWage)
wages.within2 <- plm(wage ~ union + school + exper + exper2 +
                         com + rural + married + health +
                         region + sector + occ, UnionWage)
wages.pooling1 <- update(wages.within1, model = "pooling")
wages.pooling2 <- update(wages.within2, model = "pooling")

## ------------------------------------------------------------------------
library("stargazer")
stargazer(wages.pooling2, wages.pooling1, wages.within2, wages.within1,
          omit = c("region", "sector", "occ"),
          omit.labels = c("region dummies", "sector dummies", "occupation dummies"),
          column.labels = c("pooling estimation", "within estimation"),
          column.separate = c(2, 2),
          dep.var.labels = "log of hourly wage",
          covariate.labels = c("union membership", "education years",
                               "experience years", "experience years squared",
                               "black", "hispanic", "rural residence",
                               "married", "health problems",
                               "Intercept"),
          omit.stat = c("adj.rsq", "f"),
          title = "Wage equation",
          label = "tab:wagesresult",
          no.space = TRUE
)


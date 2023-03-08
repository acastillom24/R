#### Example 6-1

## ------------------------------------------------------------------------
library("plm")

## ------------------------------------------------------------------------
y ~ x1 + x2 + x3 | x1 + x3 + z
y ~ x1 + x2 + x3 | . - x2 + z

## ------------------------------------------------------------------------

data("SeatBelt", package = "pder")
SeatBelt$occfat <- with(SeatBelt, log(farsocc / (vmtrural + vmturban)))
ols <- plm(occfat ~ log(usage) + log(percapin) + log(unemp) + log(meanage) + 
           log(precentb) + log(precenth)+ log(densrur) + 
           log(densurb) + log(viopcap) + log(proppcap) +
           log(vmtrural) + log(vmturban) + log(fueltax) +
           lim65 + lim70p + mlda21 + bac08, SeatBelt, 
           effect = "time")
fe <- update(ols, effect = "twoways")
ivfe <- update(fe, . ~ . |  . - log(usage) + ds + dp +dsp)

rbind(ols = coef(summary(ols))[1,],
      fe = coef(summary(fe))[1, ],
      w2sls = coef(summary(ivfe))[1, ])

## ------------------------------------------------------------------------
SeatBelt$noccfat <- with(SeatBelt, log(farsnocc / (vmtrural + vmturban)))
nivfe <- update(ivfe, noccfat ~ . | .)
coef(summary(nivfe))[1, ]


#### Example 6-2

## ------------------------------------------------------------------------
data("ForeignTrade", package = "pder")
w1 <- plm(imports~pmcpi + gnp + lag(imports) + lag(resimp)  |
          lag(consump) + lag(cpi) + lag(income) + lag(gnp) + pm +
          lag(invest) + lag(money) + gnpw + pw + lag(reserves) +
          lag(exports) + trend + pgnp + lag(px),
          ForeignTrade, model = "within")
r1 <- update(w1, model = "random", random.method = "nerlove", 
             random.dfcor = c(1, 1), inst.method = "baltagi")

## ------------------------------------------------------------------------
phtest(r1, w1)

## ------------------------------------------------------------------------
r1b <- plm(imports ~ pmcpi + gnp + lag(imports) + lag(resimp) |
            lag(consump) + lag(cpi) + lag(income) + lag(px) + 
            lag(reserves) + lag(exports) | lag(gnp) + pm + 
            lag(invest) + lag(money) + gnpw + pw  + trend + pgnp,
            ForeignTrade, model = "random", inst.method = "baltagi", 
            random.method = "nerlove", random.dfcor = c(1, 1))

phtest(w1, r1b)

## ------------------------------------------------------------------------
rbind(within = coef(w1), ec2sls = coef(r1b)[-1])

## ------------------------------------------------------------------------
elast <- sapply(list(w1, r1, r1b), 
                function(x) c(coef(x)["pmcpi"], 
                              coef(x)["pmcpi"] / (1 - coef(x)["lag(imports)"])))
dimnames(elast) <- list(c("ST", "LT"), c("w1", "r1", "r1b"))
elast

## ------------------------------------------------------------------------
rbind(within = coef(summary(w1))[, 2], 
      ec2sls = coef(summary(r1b))[-1, 2])


#### Example 6-3

## ------------------------------------------------------------------------
data("TradeEU", package = "pder")

## ------------------------------------------------------------------------
ols <- plm(trade ~ gdp + dist + rer + rlf + sim + cee + emu + bor + lan, TradeEU, 
          model = "pooling", index = c("pair", "year"))
fe <- update(ols, model = "within")
fe

## ------------------------------------------------------------------------
re <- update(fe, model = "random")
re

## ------------------------------------------------------------------------
phtest(re, fe)

## ----results='hide'------------------------------------------------------
ht1 <- plm(trade ~ gdp + dist + rer + rlf + sim + cee + emu + bor + lan | 
           rer + dist + bor | gdp + rlf + sim + cee + emu + lan , 
           data = TradeEU, model = "random", index = c("pair", "year"), 
           inst.method = "baltagi", random.method = "ht")
ht2 <- update(ht1, trade ~ gdp + dist + rer + rlf + sim + cee + emu + bor + lan | 
              rer + gdp + rlf + dist + bor| sim + cee + emu + lan)

## ------------------------------------------------------------------------
phtest(ht1, fe)
phtest(ht2, fe)

## ------------------------------------------------------------------------
ht2am <- update(ht2, inst.method = "am")

## ------------------------------------------------------------------------
phtest(ht2am, fe)


#### Example 6-4

## ------------------------------------------------------------------------
eqimp <- imports ~ pmcpi + gnp + lag(imports) + 
                lag(resimp) | lag(consump) + lag(cpi) + lag(income) + 
                lag(px) + lag(reserves) + lag(exports) | lag(gnp) + pm + 
                lag(invest) + lag(money) + gnpw + pw  + trend + pgnp
eqexp <- exports ~ pxpw + gnpw + lag(exports) |
                lag(gnp) + pw + lag(consump) + pm + lag(px) + lag(cpi) | 
                lag(money) + gnpw +  pgnp + pop + lag(invest) + 
                lag(income) + lag(reserves) + exrate
r12 <- plm(list(import.demand = eqimp,
                export.demand = eqexp),
           data = ForeignTrade, index = 31, model = "random", 
           inst.method = "baltagi", random.method = "nerlove",
           random.dfcor = c(1, 1))
summary(r12)

## ------------------------------------------------------------------------
rbind(ec2sls = coef(summary(r1b))[-1, 2],
      ec3sls = coef(summary(r12), "import.demand")[-1, 2])


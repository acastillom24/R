#### Example 4-1

## ----------------------------------------------------------------
library(plm)
data("RiceFarms", package = "splm")
Rice <- pdata.frame(RiceFarms, index = "id")
rice.w <- plm(log(goutput) ~ log(seed) + log(totlabor) + log(size), Rice)
rice.p <- update(rice.w, model = "pooling")
rice.wd <- plm(log(goutput) ~ log(seed) + log(totlabor) + log(size), Rice,
               effect = "twoways")

## ----------------------------------------------------------------
pFtest(rice.w, rice.p)

## ----------------------------------------------------------------
pFtest(log(goutput) ~ log(seed) + log(totlabor) + log(size), Rice)

## ----------------------------------------------------------------
pFtest(rice.wd, rice.p)

## ----------------------------------------------------------------
pFtest(log(goutput) ~ log(seed) + log(totlabor) + log(size), Rice,
       effect = "twoways")

## ----------------------------------------------------------------
pFtest(rice.wd, rice.w)

## ----------------------------------------------------------------
plmtest(rice.p)
plmtest(log(goutput)~log(seed)+log(totlabor)+log(size), Rice)
plmtest(rice.p, effect = "time")
plmtest(rice.p, effect = "twoways")

## ----------------------------------------------------------------
plmtest(rice.p, effect = "twoways", type = "kw")
plmtest(rice.p, effect = "twoways", type = "ghm")


#### Example 4-2

## ------------------------------------------------------------------------
data("RiceFarms", package = "splm")
Rice <- pdata.frame(RiceFarms, index = "id")
rice.w <- plm(log(goutput) ~ log(seed) + log(totlabor) + log(size), Rice)
rice.r <- update(rice.w, model = "random")
phtest(rice.w, rice.r)

## ------------------------------------------------------------------------
rice.b <- update(rice.w, model = "between")
cp <- intersect(names(coef(rice.b)), names(coef(rice.w)))
dcoef <- coef(rice.w)[cp] - coef(rice.b)[cp]
V <- vcov(rice.w)[cp, cp] + vcov(rice.b)[cp, cp]
as.numeric(t(dcoef) %*% solve(V) %*% dcoef)

## ------------------------------------------------------------------------
cor(fixef(rice.w), between(log(Rice$goutput)))

## ----chamberlain---------------------------------------------------------
data("RiceFarms", package = "splm")
pdim(RiceFarms, index = "id")
piest(log(goutput) ~ log(seed) + log(totlabor) + log(size),
      RiceFarms, index = "id")

## ----anewey--------------------------------------------------------------
aneweytest(log(goutput) ~ log(seed) + log(totlabor) + log(size),
           RiceFarms, index = "id")


#### Example 4-3

## ------------------------------------------------------------------------
data("RiceFarms", package="plm")
Rice <- pdata.frame(RiceFarms, index = "id")
fm <- log(goutput) ~ log(seed) + log(totlabor) + log(size)
pwtest(fm, Rice)


#### Example 4-4

## ------------------------------------------------------------------------
bsy.LM <- matrix(ncol=3, nrow = 2)
tests <- c("J", "RE", "AR")
dimnames(bsy.LM) <- list(c("LM test", "p-value"), tests)
for(i in tests) {
    mytest <- pbsytest(fm, data = Rice, test = i)
    bsy.LM[1:2, i] <- c(mytest$statistic, mytest$p.value)
    }
round(bsy.LM, 6)

## ------------------------------------------------------------------------
pbltest(fm, Rice, alternative = "onesided")


#### Example 4-5

## ------------------------------------------------------------------------
library("nlme")
data(Grunfeld, package = "plm")
reGLS <- plm(inv ~ value + capital, data = Grunfeld, model = "random")
reML <- lme(inv ~ value + capital, data = Grunfeld, random = ~1 | firm)
rbind(coef(reGLS), fixef(reML))

## ------------------------------------------------------------------------
lmAR1ML <- gls(inv ~ value + capital, data = Grunfeld,
    correlation = corAR1(0, form = ~ year | firm))

## ------------------------------------------------------------------------
reAR1ML <- lme(inv ~ value + capital, data = Grunfeld,
    random = ~ 1 | firm, correlation = corAR1(0, form = ~ year | firm))
summary(reAR1ML)

## ------------------------------------------------------------------------
lmML <- gls(inv ~ value + capital, data = Grunfeld)
anova(lmML, lmAR1ML)

## ------------------------------------------------------------------------
anova(reML, reAR1ML)

## ------------------------------------------------------------------------
anova(lmML, reML)

## ------------------------------------------------------------------------
anova(lmAR1ML, reAR1ML)


#### Example 4-6

## ------------------------------------------------------------------------
rice.re <- plm(fm, Rice, model='random')
pbgtest(rice.re, order = 2)
pdwtest(rice.re, order = 2)


#### Example 4-7

## ------------------------------------------------------------------------
data("EmplUK", package = "plm")
pwartest(log(emp) ~ log(wage) + log(capital), data = EmplUK)


#### Example 4-8

## ------------------------------------------------------------------------
pwfdtest(log(emp) ~ log(wage) + log(capital), data = EmplUK)

## ------------------------------------------------------------------------
pwfdtest(log(emp) ~ log(wage) + log(capital), data = EmplUK,
    h0 = "fe")


#### Example 4-0

## ------------------------------------------------------------------------
W.fd <- matrix(ncol = 2, nrow =2)
H0 <- c("fd", "fe")
dimnames(W.fd) <- list(c("test", "p-value"), H0)
for(i in H0) {
    mytest <- pwfdtest(fm, Rice, h0 = i)
    W.fd[1, i] <- mytest$statistic
    W.fd[2, i] <- mytest$p.value
    }
round(W.fd, 6)


#### Example 4-10

## ------------------------------------------------------------------------
data("RDSpillovers", package = "pder")
fm.rds <- lny ~ lnl + lnk + lnrd

## ------------------------------------------------------------------------
pcdtest(fm.rds, RDSpillovers)

## ------------------------------------------------------------------------
rds.2fe <- plm(fm.rds, RDSpillovers, model = "within", effect = "twoways")
pcdtest(rds.2fe)

## ------------------------------------------------------------------------
cbind("rho"  = pcdtest(rds.2fe, test = "rho")$statistic,
      "|rho|"= pcdtest(rds.2fe, test = "absrho")$statistic)


#### Example 4-11

## ------------------------------------------------------------------------
data("HousePricesUS", package = "pder")
php <- pdata.frame(HousePricesUS)

## ------------------------------------------------------------------------
cbind("rho"   = pcdtest(diff(log(php$price)), test = "rho")$statistic,
      "|rho|" = pcdtest(diff(log(php$price)), test = "absrho")$statistic)

## ------------------------------------------------------------------------
regions.names <- c("New Engl", "Mideast", "Southeast", "Great Lks",
                   "Plains", "Southwest", "Rocky Mnt", "Far West")
corr.table.hp <- cortab(diff(log(php$price)), grouping = php$region,
                        groupnames = regions.names)
colnames(corr.table.hp) <- substr(rownames(corr.table.hp), 1, 5)
round(corr.table.hp, 2)

## ------------------------------------------------------------------------
pcdtest(diff(log(price)) ~ diff(lag(log(price))) + diff(lag(log(price), 2)),
        data = php)


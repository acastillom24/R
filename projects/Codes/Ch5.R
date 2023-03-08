#### Example 5-1

## ------------------------------------------------------------------------
library("plm")
data("Produc", package = "plm")
fm <- log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp

## ------------------------------------------------------------------------
lmmod <- lm(fm, Produc)
library("lmtest")
library("sandwich")
coeftest(lmmod, vcov = vcovHC)

## ------------------------------------------------------------------------
plmmod <- plm(fm, Produc, model = "pooling")
summary(plmmod, vcov = vcovHC)


#### Example 5-2

## ------------------------------------------------------------------------
data("Hedonic", package = "plm")
hfm <- mv ~ crim + zn + indus + chas + nox + rm + age + dis + 
    rad + tax + ptratio + blacks + lstat

## ------------------------------------------------------------------------
hlmmod <- lm(hfm, Hedonic)
coeftest(hlmmod, vcov = vcovHC)

## ------------------------------------------------------------------------
hplmmod <- plm(hfm, Hedonic, model = "pooling", index = "townid")

sign.tab <- cbind(coef(hlmmod), coeftest(hlmmod, vcov = vcovHC)[,4], 
                  coeftest(hplmmod, vcov = vcovHC)[, 4])
dimnames(sign.tab)[[2]] <- c("Coefficient", "p-values, HC", "p-val., cluster")
round(sign.tab, 3)


#### Example 5-3

## ------------------------------------------------------------------------
coeftest(plmmod, vcov=vcovSCC)

## ------------------------------------------------------------------------
coeftest(plmmod, vcov=vcovDC)

## ------------------------------------------------------------------------
myvcovDCS <- function(x, maxlag = NULL, ...) {
    w1 <- function(j, maxlag) 1
    VsccL.1 <- vcovSCC(x, maxlag = maxlag, wj = w1, ...)
    Vcx <- vcovHC(x, cluster = "group", method = "arellano", ...)
    VnwL.1 <- vcovSCC(x, maxlag = maxlag, inner = "white", wj = w1, ...)
    return(VsccL.1 + Vcx - VnwL.1)
}
coeftest(plmmod, vcov=function(x) myvcovDCS(x, maxlag = 4))


#### Example 5-4

## ------------------------------------------------------------------------
Vw <- function(x) vcovHC(x, method = "white1")
Vcx <- function(x) vcovHC(x, cluster = "group", method = "arellano")
Vct <- function(x) vcovHC(x, cluster = "time", method = "arellano")
Vcxt <- function(x) Vcx(x) + Vct(x) - Vw(x)
Vct.L <- function(x) vcovSCC(x, wj = function(j, maxlag) 1)
Vnw.L <- function(x) vcovNW(x)
Vscc.L <- function(x) vcovSCC(x)
Vcxt.L<- function(x) Vct.L(x) + Vcx(x) - vcovNW(x, wj = function(j, maxlag) 1)

## -------------------------------------------------------------------------
vcovs <- c(vcov, Vw, Vcx, Vct, Vcxt, Vct.L, Vnw.L, Vscc.L, Vcxt.L)
names(vcovs) <- c("OLS", "Vw", "Vcx", "Vct", "Vcxt", "Vct.L", "Vnw.L",
                  "Vscc.L", "Vcxt.L")

## -------------------------------------------------------------------------
cfrtab <- function(mod, vcovs, ...) {
    cfrtab <- matrix(nrow = length(coef(mod)), ncol = 1 + length(vcovs))
    dimnames(cfrtab) <- list(names(coef(mod)),
                             c("Coefficient", paste("s.e.", names(vcovs))))
    cfrtab[,1] <- coef(mod)
    for(i in 1:length(vcovs)) {
        myvcov = vcovs[[i]]
        cfrtab[ , 1 + i] <- sqrt(diag(myvcov(mod)))
        }
    return(t(round(cfrtab, 4)))
}

## ------------------------------------------------------------------------
cfrtab(plmmod, vcovs)


#### Example 5-5

## ------------------------------------------------------------------------
replmmod <- plm(fm, Produc)
cfrtab(replmmod, vcovs)


#### Example 5-6

## ------------------------------------------------------------------------
library("pcse")
data("agl", package = "pcse")

## ------------------------------------------------------------------------
fm <- growth ~ lagg1 + opengdp + openex + openimp + central * leftc
aglmod <- plm(fm, agl, model = "w", effect = "time")
coeftest(aglmod, vcov=vcovBK)


#### Example 5-7

## ------------------------------------------------------------------------
coeftest(plmmod, vcov = vcovHC(plmmod, type = "HC3"))

## ------------------------------------------------------------------------
coeftest(plmmod, vcov = function(x) vcovHC(x, type = "HC3"))


#### Example 5-8

## ------------------------------------------------------------------------
data("Parity", package = "plm")
fm <- ls ~ ld
pppmod <- plm(fm, data = Parity, effect = "twoways")

## ------------------------------------------------------------------------
library("car")
linearHypothesis(pppmod, "ld = 1", vcov = vcov)

## ------------------------------------------------------------------------
vcovs <- c(vcov, Vw, Vcx, Vct, Vcxt, Vct.L, Vnw.L, Vscc.L, Vcxt.L)
names(vcovs) <- c("OLS", "Vw", "Vcx", "Vct", "Vcxt", "Vct.L", "Vnw.L",
                  "Vscc.L", "Vcxt.L")
tttab <- matrix(nrow = 4, ncol = length(vcovs))
dimnames(tttab) <- list(c("Pooled OLS","Time FE","Country FE","Two-way FE"),
                        names(vcovs))

pppmod.ols <- plm(fm, data = Parity, model = "pooling")
for(i in 1:length(vcovs)) {
    tttab[1, i] <- linearHypothesis(pppmod.ols, "ld = 1",
                                    vcov = vcovs[[i]])[2, 4]
}

pppmod.tfe <- plm(fm, data = Parity, effect = "time")
for(i in 1:length(vcovs)) {
    tttab[2, i] <- linearHypothesis(pppmod.tfe, "ld = 1",
                                    vcov = vcovs[[i]])[2, 4]
}

pppmod.cfe <- plm(fm, data = Parity, effect = "individual")
for(i in 1:length(vcovs)) {
    tttab[3, i] <- linearHypothesis(pppmod.cfe, "ld = 1",
                                    vcov = vcovs[[i]])[2, 4]
}

pppmod.2fe <- plm(fm, data = Parity, effect = "twoways")
for(i in 1:length(vcovs)) {
    tttab[4, i] <- linearHypothesis(pppmod.2fe, "ld = 1",
                                    vcov = vcovs[[i]])[2, 4]
}

print(t(round(tttab, 6)))


#### Example 5-9

## ------------------------------------------------------------------------
data("Grunfeld", package = "plm")
phtest(inv ~ value + capital, data = Grunfeld)

## ------------------------------------------------------------------------
phtest(inv ~ value + capital, data = Grunfeld, method = "aux")


#### Example 5-10

## ------------------------------------------------------------------------
data("RDSpillovers", package = "pder")
pehs <- pdata.frame(RDSpillovers, index = c("id", "year"))
ehsfm <- lny ~ lnl + lnk + lnrd
phtest(ehsfm, pehs, method = "aux")

## ------------------------------------------------------------------------
phtest(ehsfm, pehs, method = "aux", vcov = vcovHC)


#### Example 5-11

## ------------------------------------------------------------------------
data("EmplUK", package = "plm")
gglsmod <- pggls(log(emp) ~ log(wage) + log(capital),
                 data = EmplUK, model = "pooling")
summary(gglsmod)

## ------------------------------------------------------------------------
round(gglsmod$sigma, 3)


#### Example 5-12

## ------------------------------------------------------------------------
feglsmod <- pggls(log(emp) ~ log(wage) + log(capital), data = EmplUK,
                  model = "within")
summary(feglsmod)

## ----gglshaus------------------------------------------------------------
phtest(feglsmod, gglsmod)


#### Example 5-13

## ------------------------------------------------------------------------
fdglsmod <- pggls(log(emp) ~ log(wage) + log(capital), data = EmplUK,
                  model = "fd")
summary(fdglsmod)


#### Example 5-14

## ------------------------------------------------------------------------
data("RiceFarms", package = "splm")
RiceFarms <- transform(RiceFarms, 
                       phosphate = phosphate / 1000,
                       pesticide = as.numeric(pesticide > 0))
                       
fm <- log(goutput) ~ log(seed) + log(urea) + phosphate +
    log(totlabor) + log(size) + pesticide + varieties +
        + region + time

## ------------------------------------------------------------------------
gglsmodrice <- pggls(fm, RiceFarms, model = "pooling", index = "id")
summary(gglsmodrice)

## ------------------------------------------------------------------------
library("lmtest")
waldtest(gglsmodrice, "region") 

## ------------------------------------------------------------------------
feglsmodrice <- pggls(update(fm, . ~ . - region), RiceFarms, index = "id")

## ------------------------------------------------------------------------
phtest(gglsmodrice, feglsmodrice)

## ------------------------------------------------------------------------
phtest(pggls(update(fm, . ~ . - region), RiceFarms, 
             model = "pooling", index = "id"),
       feglsmodrice)


#### Example 5-15

## ------------------------------------------------------------------------
fm <- lny ~ lnl + lnk + lnrd

## ------------------------------------------------------------------------
gglsmodehs <- pggls(fm, RDSpillovers, model = "pooling")
coeftest(gglsmodehs)

## ------------------------------------------------------------------------
feglsmodehs <- pggls(fm, RDSpillovers, model = "within")
coeftest(feglsmodehs)

## ------------------------------------------------------------------------
phtest(gglsmodehs, feglsmodehs)

## ------------------------------------------------------------------------
fdglsmodehs <- pggls(fm, RDSpillovers, model = "fd")

## ------------------------------------------------------------------------
fee <- resid(feglsmodehs)
dbfee <- data.frame(fee=fee, id=attr(fee, "index")[[1]])
coeftest(plm(fee~lag(fee)+lag(fee,2), dbfee, model = "p", index="id"))

## ----simpleartestfd------------------------------------------------------
fde <- resid(fdglsmodehs)
dbfde <- data.frame(fde=fde, id=attr(fde, "index")[[1]])
coeftest(plm(fde~lag(fde)+lag(fde,2), dbfde, model = "p", index="id"))

## ----fdglsehs2-----------------------------------------------------------
coeftest(fdglsmodehs)


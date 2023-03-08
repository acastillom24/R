#### Example 3-1

## ------------------------------------------------------------------------
library(plm)
data("Tileries", package = "pder")
head(Tileries, 3)
pdim(Tileries)

## ------------------------------------------------------------------------
Tileries <- pdata.frame(Tileries)
plm.within <- plm(log(output) ~ log(labor) + log(machine), Tileries)
y <- log(Tileries$output)
x1 <- log(Tileries$labor)
x2 <- log(Tileries$machine)
lm.within <- lm(I(y - Between(y)) ~ I(x1 - Between(x1)) + I(x2 - Between(x2)) - 1)
lm.lsdv <- lm(log(output) ~ log(labor) + log(machine) + factor(id), Tileries)
coef(lm.lsdv)[2:3]
coef(lm.within)
coef(plm.within)

## ------------------------------------------------------------------------
tile.r <- plm(log(output) ~ log(labor) + log(machine), Tileries, model = "random")
summary(tile.r)

## ------------------------------------------------------------------------
plm.within <- plm(log(output) ~ log(labor) + log(machine),
                  Tileries, effect = "twoways")
lm.lsdv <- lm(log(output) ~ log(labor) + log(machine) +
                  factor(id) + factor(week), Tileries)
y <- log(Tileries$output)
x1 <- log(Tileries$labor)
x2 <- log(Tileries$machine)
y <- y - Between(y, "individual") - Between(y, "time") + mean(y)
x1 <- x1 - Between(x1, "individual") - Between(x1, "time") + mean(x1)
x2 <- x2 - Between(x2, "individual") - Between(x2, "time") + mean(x2)
lm.within <- lm(y ~ x1 + x2 - 1)
coef(plm.within)
coef(lm.within)
coef(lm.lsdv)[2:3]

## ------------------------------------------------------------------------
wh <- plm(log(output) ~ log(labor) + log(machine), Tileries,
          model = "random", random.method = "walhus",
          effect = "twoways")
am <- update(wh, random.method = "amemiya")
sa <- update(wh, random.method = "swar")
ercomp(sa)

## ------------------------------------------------------------------------
re.models <- list(walhus = wh, amemiya = am, swar = sa)
sapply(re.models, function(x) sqrt(ercomp(x)$sigma2))
sapply(re.models, coef)


#### Example 3-2

## ------------------------------------------------------------------------
data("TexasElectr", package = "pder")
library("dplyr")
TexasElectr <- mutate(TexasElectr,
                      pf = log(pfuel / mean(pfuel)),
                      pl = log(plab / mean(plab)) - pf,
                      pk = log(pcap / mean(pcap)) - pf)

## ------------------------------------------------------------------------
TexasElectr <- mutate(TexasElectr, q = log(output / mean(output)))

## ------------------------------------------------------------------------
TexasElectr <- mutate(TexasElectr,
                      C = expfuel + explab + expcap,
                      sl = explab / C,
                      sk = expcap / C,
                      C = log(C / mean(C)) - pf)

## ------------------------------------------------------------------------
TexasElectr <- mutate(TexasElectr,
                      pll = 1/2 * pl ^ 2,
                      plk = pl * pk,
                      pkk = 1/2 * pk ^ 2,
                      qq = 1/2 * q ^ 2)

## ------------------------------------------------------------------------
cost <- C ~ pl + pk + q + pll + plk + pkk + qq
shlab <- sl ~ pl + pk
shcap <- sk ~ pl + pk

## ------------------------------------------------------------------------
R <- matrix(0, nrow = 6, ncol = 14)
R[1, 2] <- R[2, 3] <- R[3, 5] <- R[4, 6] <- R[5, 6] <- R[6, 7] <- 1
R[1, 9] <- R[2, 12] <- R[3, 10] <- R[4, 11] <- R[5, 13] <- R[6, 14] <- -1

## ------------------------------------------------------------------------
z <- plm(list(cost = C ~ pl + pk + q + pll + plk + pkk + qq,
              shlab = sl ~ pl + pk,
              shcap = sk ~ pl + pk),
         TexasElectr, model = "random",
         restrict.matrix = R)
summary(z)


#### Example 3-3

## ------------------------------------------------------------------------
data("RiceFarms", package = "splm")
Rice <- pdata.frame(RiceFarms, index = "id")
library("pglm")
rice.ml <- pglm(log(goutput) ~ log(seed) + log(totlabor) + log(size),
                data = Rice, family = gaussian)

## ------------------------------------------------------------------------
summary(rice.ml)


#### Example 3-4

## ------------------------------------------------------------------------
data("RiceFarms", package = "plm")
head(RiceFarms, 2)

## ------------------------------------------------------------------------
R1 <- pdata.frame(RiceFarms, index = c(id = "id", time = NULL, group = "region"))
R2 <- pdata.frame(RiceFarms, index = c(id = "id", group = "region"))
R3 <- pdata.frame(RiceFarms, index = c("id", group = "region"))
head(index(R1))

## ------------------------------------------------------------------------
data("Produc", package = "plm")
nswar <- plm(log(gsp) ~ log(pc) + log(emp) + log(hwy) + log(water) +
                 log(util) + unemp, data = Produc,
             model = "random", effect = "nested",
             random.method = "swar", index = c(group = "region"))
summary(nswar)

## ------------------------------------------------------------------------
library("texreg")
namem <- update(nswar, random.method = "amemiya")
nwalhus <- update(nswar, random.method = "walhus")
iswar <- update(nswar, effect = "individual")
iwith <- update(nswar, model = "within", effect = "individual")
screenreg(list("fe-id" = iwith, "re-id" = iswar,
               "Swamy_Arora" = nswar, "Wallas-Hussein" = nwalhus,
               "Amemiya" = namem), digits = 3)


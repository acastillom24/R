#### Example 10-1

## ------------------------------------------------------------------------
data("HousePricesUS", package="pder")
library("ggplot2")
data("fifty_states", package = "fiftystater")
baw <- FALSE
houses00 <- subset(HousePricesUS, year == 2000)
houses00$name <- tolower(houses00$name)
p <- ggplot(houses00, aes(map_id = name)) +
    geom_map(aes(fill = price), map = fifty_states) +
    expand_limits(x = fifty_states$long, y = fifty_states$lat) +
    coord_map() +
    scale_x_continuous(breaks = NULL) +
    scale_y_continuous(breaks = NULL) +
    labs(x = "", y = "") +
    theme(legend.position = "bottom",
          panel.background = element_blank()) + 
    theme(legend.text = element_text(size = 6), 
          legend.title= element_text(size = 8),
          axis.title = element_text(size = 8))
if (baw) p <-p + scale_fill_gradient2(low = "grey30", high = "grey5")
p


#### Example 10-2

## ------------------------------------------------------------------------
data("usaw49", package="pder")
library("plm")
php <- pdata.frame(HousePricesUS)
pcdtest(php$price, w = usaw49)

## ------------------------------------------------------------------------
library("splm")
rwtest(php$price, w = usaw49, replications = 999)

## ------------------------------------------------------------------------
mgmod <- pmg(log(price) ~ log(income), data = HousePricesUS)
ccemgmod <- pmg(log(price) ~ log(income), data = HousePricesUS, model = "cmg")
pcdtest(resid(ccemgmod), w = usaw49)
rwtest(resid(mgmod), w = usaw49, replications = 999)


#### Example 10-3

## ------------------------------------------------------------------------
library("plm")
library("splm")
data("Cigar", package = "plm")
fm <- log(sales) ~ log(price) + log(pimin) + log(ndi / cpi)
femod <- plm(fm, Cigar)
library("lmtest")
coeftest(femod)

## ------------------------------------------------------------------------
data("usaw46", package = "pder")
wcig <- usaw46 / apply(usaw46, 1, sum)
summary(apply(wcig, 1, sum))

## ------------------------------------------------------------------------
cig <- Cigar[order(Cigar$year, Cigar$state), ]
wp <- kronecker(diag(1, 30), wcig) %*% cig$price
Cigar$wp <- wp[order(cig$state, cig$year)]

## ------------------------------------------------------------------------
Cigar$wp <- kronecker(wcig, diag(1,30)) %*% Cigar$price

## ------------------------------------------------------------------------
fm2 <- update(fm, . ~ . - log(pimin) + log(wp))
femod2 <- plm(fm2, Cigar)
coeftest(femod2)

## ------------------------------------------------------------------------
lwcig <- mat2listw(wcig)
fm3 <- update(fm, . ~ . - log(pimin) + 
                      log(slag(price, listw=lwcig)))

## ------------------------------------------------------------------------
wx <- function(x) slag(x, listw = lwcig)
fm3.alt <- update(fm, . ~ . - log(pimin) + log(wx(price)))


#### Example 10-4

## ------------------------------------------------------------------------
e <- resid(ccemgmod)
edat <- data.frame(ind = attr(e, "index")[[1]],
                   tind = attr(e, "index")[[2]],  e = as.numeric(e))
sarmod.e <- spreml(e ~ 1, data = edat, w = usaw49, lag = TRUE, errors = "ols")
summary(sarmod.e)$ARCoefTable

## ------------------------------------------------------------------------
library("lmtest")
coeftest(plm(e ~ slag(e, listw = usaw49) - 1, data = edat, model = "p"))


#### Example 10-5

## ------------------------------------------------------------------------
data("RiceFarms", package = "splm")
data("riceww", package = "splm")
library("spdep")
ricelw <- mat2listw(riceww)
Rice <- pdata.frame(RiceFarms, index = "id")

## ------------------------------------------------------------------------
riceprod <- log(goutput) ~ log(seed) + log(totlabor) + 
    log(size) + region + time
    
rice.sem <- spreml(riceprod, data = Rice, w = riceww,
                   lag = FALSE, errors = "sem")

summary(rice.sem)


#### Example 10-6

## ------------------------------------------------------------------------
riceprod0 <- update(riceprod, . ~ . - region - time)
semfemod <- spml(riceprod0, Rice, listw = ricelw,
                 lag = FALSE, spatial.error = "b")
summary(semfemod)

## ------------------------------------------------------------------------

Rice <- pdata.frame(RiceFarms, index = "id")
sphtest(riceprod0, Rice, listw = ricelw)


#### Example 10-7

## ------------------------------------------------------------------------
sarremod.ml <- spml(riceprod0, Rice, listw = ricelw,
                    model = "random", lag = TRUE, spatial.error = "none")
summary(sarremod.ml)


#### Example 10-8

## ------------------------------------------------------------------------
semremod.ml <- spml(riceprod0, Rice, listw = ricelw,
                    model = "random", lag = FALSE, spatial.error = "b")
summary(semremod.ml)
sem2remod.ml <- spml(riceprod0, Rice, listw = ricelw,
                    model = "random", lag = FALSE, spatial.error = "kkp")
summary(sem2remod.ml)


#### Example 10-9

## ------------------------------------------------------------------------
semremod.gm <- spgm(riceprod0, Rice, listw = ricelw,
                    lag = FALSE, spatial.error = TRUE)
summary(semremod.gm)


#### Example 10-10

## ------------------------------------------------------------------------
bsktest(riceprod, data = Rice, listw = ricelw, test = "LMH")

## ------------------------------------------------------------------------
bsktest(riceprod, data = Rice, listw = ricelw, test = "CLMmu")

## ------------------------------------------------------------------------
bsktest(riceprod, data = Rice, listw = ricelw, test = "CLMlambda")


#### Example 10-11

## ------------------------------------------------------------------------
local.rob.LM <- matrix(ncol = 4, nrow = 2)
tests <- c("lml", "lme", "rlml", "rlme")
dimnames(local.rob.LM) <- list(c("LM test", "p-value"),
                               tests)
for(i in tests) {
    local.rob.LM[1, i] <- slmtest(riceprod, data = Rice,
                                  listw=ricelw, test = i)$statistic
    local.rob.LM[2, i] <- slmtest(riceprod, data = Rice,
                                  listw=ricelw, test = i)$p.value
    }
round(local.rob.LM, 4)

## ------------------------------------------------------------------------
local.rob.LMw <- matrix(ncol = 4, nrow = 2)
wriceprod <- Within(log(goutput)) ~ Within(log(seed)) +
    Within(log(totlabor)) + Within(log(size)) + 
    region + time
dimnames(local.rob.LMw) <- list(c("LM test", "p-value"),
                               c("lml", "lme", "rlml", "rlme"))
for(i in c("lml", "lme", "rlml", "rlme")) {
    local.rob.LMw[1, i] <- slmtest(wriceprod, data = Rice,
                                  listw=ricelw, test = i)$statistic
    local.rob.LMw[2, i] <- slmtest(wriceprod, data = Rice,
                                  listw=ricelw, test = i)$p.value
    }
round(local.rob.LMw, 4)


#### Example 10-12

## ------------------------------------------------------------------------
saremremod <- spml(riceprod, data = Rice, listw = ricelw, lag = TRUE,
                   model = "random", spatial.error = "b")
summary(saremremod)


#### Example 10-13

## ------------------------------------------------------------------------
ll1 <- saremremod$logLik
ll0 <- spml(riceprod, data = Rice, listw = ricelw, lag = FALSE,
                   model = "random", spatial.error = "b")$logLik
LR <- 2 * (ll1 - ll0)
pLR <- pchisq(LR, df = 1, lower.tail = FALSE)
pLR


#### Example 10-14

## ------------------------------------------------------------------------
data("EvapoTransp", package = "pder")
data("etw", package = "pder")
evapo <- et ~ prec + meansmd + potet + infil + biomass + plantcover +
  softforbs + tallgrass + diversity + matgram + dwarfshrubs + legumes
semsr.evapo <- spreml(evapo, data=EvapoTransp, w=etw,
                      lag=FALSE, errors="semsr")
summary(semsr.evapo)

## ------------------------------------------------------------------------
library("lmtest")
coeftest(plm(evapo, EvapoTransp, model="pooling"))

## ------------------------------------------------------------------------
coeftest(spreml(evapo, EvapoTransp, w=etw, errors="sem"))


#### Example 10-15

## ------------------------------------------------------------------------
bsjk.LM <- matrix(ncol = 4, nrow = 2)
tests <- c("J", paste("C", 1:3, sep = "."))
dimnames(bsjk.LM) <- list(c("LM test", "p-value"),
                               tests)
for(i in tests) {
    mytest <- bsjktest(riceprod, data = RiceFarms, index = "id",
                       listw = ricelw, test = i)
    bsjk.LM[1, i] <- mytest$statistic
    bsjk.LM[2, i] <- mytest$p.value
    }
round(bsjk.LM, 6)


#### Example 10-16

## ------------------------------------------------------------------------
semsrre.rice <- spreml(riceprod, data = Rice,#Farms, index = "id",
                       w=riceww, lag = FALSE, errors = "semsrre")
round(summary(semsrre.rice)$ErrCompTable, 6)


#### Example 10-17

## ------------------------------------------------------------------------
saremsrre.evapo <- spreml(evapo, data = EvapoTransp,
                          w = etw, lag = TRUE, errors = "semsr")
summary(saremsrre.evapo)$ARCoefTable
round(summary(saremsrre.evapo)$ErrCompTable, 6)


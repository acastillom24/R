## ------------------------------------------------------------------------
library("plm")
library("maxLik")
library("texreg")
extract.maxLik <- function (model, include.nobs = TRUE, ...){
    s <- summary(model, ...)
    names <- rownames(s$estimate)
    class(names) <- "character"
    co <- s$estimate[, 1]
    se <- s$estimate[, 2]
    pval <- s$estimate[, 4]
    class(co) <- class(se) <- class(pval) <- "numeric"
    n <- nrow(model$gradientObs)
    lik <- logLik(model)
    gof <- numeric()
    gof.names <- character()
    gof.decimal <- logical()
    gof <- c(gof, n, lik)
    gof.names <- c(gof.names, "Num. obs.", "Log Likelihood")
    gof.decimal <- c(gof.decimal, FALSE, TRUE)
    tr <- createTexreg(coef.names = names, coef = co, se = se, pvalues = pval,
                       gof.names = gof.names, gof = gof, gof.decimal = gof.decimal)
    return(tr)
}
setMethod("extract", signature = className("maxLik", "maxLik"), definition = extract.maxLik)

## ------------------------------------------------------------------------


#### Example 8-1

## ------------------------------------------------------------------------
data("Reelection", package = "pder")

## ------------------------------------------------------------------------
elect.l <- glm(reelect ~ ddefterm + ddefey + gdppc + dev + nd + maj, 
          data = Reelection, family = "binomial", subset = narrow)
l2 <- update(elect.l, family = binomial)
l3 <- update(elect.l, family = binomial())
l4 <- update(elect.l, family = binomial(link = 'logit'))

## ------------------------------------------------------------------------
elect.p <- update(elect.l, family = binomial(link = 'probit'))

## ------------------------------------------------------------------------
library("pglm")
elect.pl <- pglm(reelect ~ ddefterm + ddefey + gdppc + dev + nd + maj, 
                Reelection, family = binomial(link = 'logit'), 
                subset = narrow)
elect.pp <- update(elect.pl, family = binomial(link = 'probit'))

## ------------------------------------------------------------------------
library("texreg")
screenreg(list(logit = elect.l, probit = elect.p, 
               plogit = elect.pl, pprobit = elect.pp),
          digits = 3)


#### Example 8-2

## ------------------------------------------------------------------------
data("Fairness", package = "pglm")

## ------------------------------------------------------------------------
library("MASS")
parking.ol <- polr(answer ~ recurring + driving + education + rule, 
                   data = Fairness, subset = good == "parking", 
                   Hess = TRUE, method = "logistic")
parking.op <- update(parking.ol, method = "probit")

## ------------------------------------------------------------------------
parking.opp <- pglm(as.numeric(answer) ~ recurring + driving + education + rule, 
                    data = Fairness, subset = good == 'parking',
                    family = ordinal(link = 'probit'), R = 10, index = 'id', 
                    model = "random") 
parking.olp <- update(parking.opp, family = ordinal(link = 'probit'))

## ------------------------------------------------------------------------
library("texreg")
screenreg(list(ologit = parking.ol, oprobit = parking.op, 
               pologit = parking.olp, poprobit = parking.opp),
          digits = 3)


#### Example 8-3

## ------------------------------------------------------------------------
data("MagazinePrices", package = "pder")
logitS <- glm(change ~ length + cuminf + cumsales, data = MagazinePrices, 
              subset = included == 1, family = binomial(link = 'logit'))
logitD <- glm(change ~ length + cuminf + cumsales + magazine, 
              data = MagazinePrices, 
              subset = included == 1, family = binomial(link = 'logit'))
library("survival")
logitC <- clogit(change ~ length + cuminf + cumsales + strata(id), 
                 data = MagazinePrices,
                 subset = included == 1)
library("texreg")
screenreg(list(logit = logitS, "FE logit" = logitD, 
               "cond. logit" = logitC), omit.coef = "magazine")


#### Example 8-4

## ------------------------------------------------------------------------
data("LateBudgets", package = "pder")
LateBudgets$dayslatepos <- pmax(LateBudgets$dayslate, 0)
LateBudgets$divgov <- with(LateBudgets, 
                           factor(splitbranch == "yes" | 
                                  splitleg == "yes", 
                                  labels = c("no", "yes")))
LateBudgets$unemprise <- pmax(LateBudgets$unempdiff, 0)
LateBudgets$unempfall <- - pmin(LateBudgets$unempdiff, 0)
form <- dayslatepos ~ unemprise + unempfall + divgov + elecyear + 
    pop + fulltimeleg + shutdown + censusresp + endbalance + kids + 
    elderly + demgov + lameduck + newgov + govexp + nocarry + 
    supmaj + black + graduate

## ------------------------------------------------------------------------
FEtobit <- pldv(form, LateBudgets)
summary(FEtobit)


#### Example 8-5

## ------------------------------------------------------------------------
data("Donnors", package = "pder")
library("plm")
library("texreg")
T3.1 <- plm(donation ~ treatment +  prcontr, Donnors, index = "id")
T3.2 <- plm(donation ~ treatment * prcontr - prcontr, Donnors, index = "id")
T5.A <- pldv(donation ~ treatment +  prcontr, Donnors, index = "id", 
             model = "random", method = "bfgs")
T5.B <- pldv(donation ~ treatment * prcontr - prcontr, Donnors, index = "id", 
             model = "random", method = "bfgs")
screenreg(list(OLS = T3.1, Tobit = T5.A, OLS = T3.2, Tobit = T5.B), 
          reorder.coef = c(1:3, 7:9, 4:6))


## ------------------------------------------------------------------------
data("Terrorism", package="pder")

## ------------------------------------------------------------------------
ea <- pglm(incidents ~ polity + press, data = Terrorism,
           index = c("country", "year"), family = poisson)
summary(ea)

## ------------------------------------------------------------------------
stpress <- as.numeric(coef(ea)[3:4]%*%solve(vcov(ea))[3:4,3:4]%*%coef(ea)[3:4])
stpress

## ------------------------------------------------------------------------
pchisq(stpress, df = 2, lower.tail = FALSE)

## ------------------------------------------------------------------------
po <- update(ea, model="pooling")
wi <- update(ea, model="within")
be <- update(ea, model="between")
summary(wi)


#### Example 8-6

## ------------------------------------------------------------------------
data("GiantsShoulders", package = "pder")
head(GiantsShoulders)

## ------------------------------------------------------------------------
library("dplyr")
GiantsShoulders <- mutate(GiantsShoulders, age = year - pubyear)
cityear <- summarise(group_by(GiantsShoulders, brc, age), 
                     cit = mean(citations, na.rm = TRUE))

## ------------------------------------------------------------------------
GiantsShoulders <- mutate(GiantsShoulders,
                          window = as.numeric( (brc == "yes") & 
                                               abs(brcyear - year) <= 1),
                          post_brc = as.numeric( (brc == "yes") & 
                                                 year - brcyear > 1),
                          age = year - pubyear)
GiantsShoulders$age[GiantsShoulders$age == 31] <- 0
GiantsShoulders$year[GiantsShoulders$year %in% 1970:1974] <- 1970
GiantsShoulders$year[GiantsShoulders$year %in% 1975:1979] <- 1975

## ------------------------------------------------------------------------
library("pglm")
t3c1 <- lm(log(1 + citations) ~ brc + window + post_brc + factor(age), 
           data = GiantsShoulders)
t3c2 <- update(t3c1, . ~ .+  factor(pair) + factor(year))
t3c3 <- pglm(citations ~ brc + window + post_brc + factor(age) + factor(year),
           data = GiantsShoulders, index = "pair", 
           effect = "individual", model = "within", family = negbin)
t3c4 <- pglm(citations ~ window + post_brc + factor(age) + factor(year),
             data = GiantsShoulders, index = "article", 
             effect = "individual", model = "within", family = negbin)
screenreg(list(t3c2, t3c3, t3c4),
          custom.model.names = c("ols: age/year/pair-FE", 
                                 "NB:age/year/pair-FE", "NB: age/year/article-FE"),
          omit.coef="(factor)|(Intercept)", digits = 3)


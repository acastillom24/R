#### Example 7-1

## ------------------------------------------------------------------------

data("DemocracyIncome", package = "pder")
data("DemocracyIncome25", package = "pder")

## ------------------------------------------------------------------------
data("DemocracyIncome", package="pder")
set.seed(1)
di2000 <- subset(DemocracyIncome, year == 2000,
                 select = c("democracy", "income", "country"))
di2000 <- na.omit(di2000)
di2000$country <- as.character(di2000$country)
di2000$country[- c(2,5, 23, 16, 17, 22, 71,  125, 37, 43, 44, 79, 98, 105, 50, 120,  81, 129, 57, 58,99)] <- NA

library("ggplot2")
ggplot(di2000, aes(income, democracy, label = country)) + 
    geom_point(size = 0.4) + 
    geom_text(aes(y= democracy + sample(0.03 * c(-1, 1), 
                                        nrow(di2000), replace = TRUE)),
                  size = 2) +
    theme(legend.text = element_text(size = 6), 
          legend.title= element_text(size = 8),
          axis.title = element_text(size = 8),
          axis.text = element_text(size = 6))


## ------------------------------------------------------------------------
library("plm")
pdim(DemocracyIncome)
head(DemocracyIncome, 4)


#### Example 7-2

## ------------------------------------------------------------------------
mco <- plm(democracy ~ lag(democracy) + lag(income) + year - 1, 
           DemocracyIncome, index = c("country", "year"), 
           model = "pooling", subset = sample == 1)

## ------------------------------------------------------------------------
mco <- plm(democracy ~ lag(democracy) + lag(income), 
           DemocracyIncome, index = c("country", "year"), 
           model = "within", effect = "time",
           subset = sample == 1)
coef(summary(mco))


#### Example 7-3

## ------------------------------------------------------------------------
within <- update(mco, effect = "twoways")
coef(summary(within))


#### Example 7-4

## ------------------------------------------------------------------------
ahsiao <- plm(diff(democracy) ~ lag(diff(democracy)) + 
              lag(diff(income)) + year - 1  | 
              lag(democracy, 2) + lag(income, 2) + year - 1, 
              DemocracyIncome, index = c("country", "year"),
              model = "pooling", subset = sample == 1)
coef(summary(ahsiao))[1:2, ]


#### Example 7-5

## ------------------------------------------------------------------------
diff1 <- pgmm(democracy ~ lag(democracy) + lag(income) | 
              lag(democracy, 2:99)| lag(income, 2),
              DemocracyIncome, index=c("country", "year"), 
              model="onestep", effect="twoways", subset = sample == 1)
coef(summary(diff1))

## ------------------------------------------------------------------------
diff2 <- update(diff1, model = "twosteps")
coef(summary(diff2))


#### Example 7-6

## ------------------------------------------------------------------------
data("DemocracyIncome25", package = "pder")
pdim(DemocracyIncome25)

## ------------------------------------------------------------------------
diff25 <- pgmm(democracy ~ lag(democracy) + lag(income) |
               lag(democracy, 2:99) + lag(income, 2:99),
               DemocracyIncome25, model = "twosteps")

## ------------------------------------------------------------------------
diff25lim <- pgmm(democracy ~ lag(democracy) + lag(income) | 
                  lag(democracy, 2:4)+ lag(income, 2:4),
                  DemocracyIncome, index=c("country", "year"), 
                  model="twosteps", effect="twoways", subset = sample == 1)
diff25coll <- pgmm(democracy ~ lag(democracy) + lag(income) | 
                   lag(democracy, 2:99)+ lag(income, 2:99),
                   DemocracyIncome, index=c("country", "year"), 
                   model="twosteps", effect="twoways", subset = sample == 1,
                   collapse = TRUE)
sapply(list(diff25, diff25lim, diff25coll), function(x) coef(x)[1:2])


#### Example 7-7

## ------------------------------------------------------------------------
sys2 <- pgmm(democracy ~ lag(democracy) + lag(income) | 
             lag(democracy, 2:99)| lag(income, 2),
             DemocracyIncome, index = c("country", "year"), 
             model = "twosteps", effect = "twoways",
             transformation = "ld")
coef(summary(sys2))


#### Example 7-8

## ------------------------------------------------------------------------
sqrt(diag(vcov(diff2)))[1:2]
sqrt(diag(vcovHC(diff2)))[1:2]


#### Example 7-9

## ------------------------------------------------------------------------
sargan(diff2)
sargan(sys2)

## ------------------------------------------------------------------------
sapply(list(diff25, diff25lim, diff25coll), 
       function(x) sargan(x)[["p.value"]])


#### Example 7-10

## ------------------------------------------------------------------------
mtest(diff2, order = 2)


library(Ecdat)
library(estimatr)
library(texreg)

data("Cigarette")
#Taking a look at the data (requires vtable package)
vtable::vtable(Cigarette)

#Regular regression
summary(lm(packpc~avgprs,data=Cigarette))

#With standard errors
m1 <- lm_robust(packpc~avgprs,data=Cigarette)

#Non-robust standard errors with se_type='classical'
lm_robust(packpc~avgprs,data=Cigarette,se_type='classical')

#Include cluster-robust standard errors
lm_robust(packpc~avgprs,data=Cigarette,clusters=state)

#Fixed effects
lm_robust(packpc~avgprs,data=Cigarette,fixed_effects=~state)

#two-way fixed effects
lm_robust(packpc~avgprs,data=Cigarette,fixed_effects=~state+year)

#Instrumental variables with robust standard errors
m2<- iv_robust(packpc~avgprs +cpi | tax + cpi,data=Cigarette)

#IV with robust SEs and fixed_Effects
m3<- iv_robust(packpc~avgprs +cpi | tax + cpi,data=Cigarette,fixed_effects = ~state)

#Printing regression results with texreg
screenreg(list(m1,m2,m3),include.ci=FALSE,stars=c(.01,.05,.1))

## ---------- general preliminaries ---------------------------------------
library(plm)
baw <- FALSE
library("ggplot2")
plotplm <- function(x, N = 10, seed = 1, lgth = 0.1){
    mydata <- model.frame(x)
    onames <- names(mydata)
    names(mydata) <- c("y", "x")
    LGTH <- (max(mydata$x) - min(mydata$x)) ^ 2 +
        (max(mydata$y) - min(mydata$y)) ^ 2
    lgth <- lgth * sqrt(LGTH) / 2
    seed <- set.seed(seed)
    theids <- sample(unique(index(mydata)[[1]]), N)
    small <- subset(mydata, index(mydata)[[1]] %in% theids)
    small <- cbind(small, id = index(small)[[1]])
    ymean <- with(small, tapply(y, id, mean)[as.character(theids)])
    xmean <- with(small, tapply(x, id, mean)[as.character(theids)])
    within <- update(x, model = "within")
    alpha <- mean(mydata[[1]]) - coef(within) * mean(mydata[[2]])
    beta <- as.numeric(coef(within))
    random <- update(within, model = "random")
    between <- update(within, model = "between")
    ols <- update(within, model = "pooling")
    FE <- fixef(within)[as.character(theids)]
    DATA <- data.frame(id = names(FE), FE = as.numeric(FE), slope = beta,
                       xmean = xmean, ymean = ymean,
                       xmin = xmean - lgth / sqrt(1 + beta ^ 2),
                       xmax = xmean + lgth / sqrt(1 + beta ^ 2),
                       ymin = ymean - lgth * beta / sqrt(1 + beta ^ 2),
                       ymax = ymean + lgth * beta / sqrt(1 + beta ^ 2))
    MODELS <- data.frame(models = c("ols", "random", "within", "between"),
                         intercept = c(coef(ols)[1], coef(random)[1], alpha, coef(between)[1]),
                         slope = c(coef(ols)[2], coef(random)[2], coef(within), coef(between)[2]))
    if (! baw){
        ggplot(data = small, aes(x = x, y = y, color = id)) + geom_point(size = 0.4) +
            geom_segment(aes(x = xmin, xend = xmax, y = ymin, yend = ymax, color = id), data = DATA) +
            geom_abline(aes(intercept = intercept, slope = slope, lty = models), data = MODELS) +
            geom_point(aes(x = xmean, y = ymean, color = id), size = 1, shape = 13, data = DATA) +
            xlab(onames[2]) + ylab(onames[1]) +
            theme(legend.text = element_text(size = 6),
                  legend.title= element_text(size = 8),
                  axis.title = element_text(size = 8))
    } else {
        ggplot(data = small, aes(x = x, y = y)) + geom_point(size = 0.4, aes(shape = id)) +
            geom_segment(aes(x = xmin, xend = xmax, y = ymin, yend = ymax), data = DATA) +
            geom_abline(aes(intercept = intercept, slope = slope, lty = models), data = MODELS) +
            geom_point(aes(x = xmean, y = ymean, shape = id), size = 1,  data = DATA) +
            scale_shape_manual(values=1:N) +
            xlab(onames[2]) + ylab(onames[1]) +
            theme(legend.text = element_text(size = 6),
                  legend.title= element_text(size = 8),
                  axis.title = element_text(size = 8))
    }
}


## ------------- Chapter 2 -----------------------------------------------

## ------------- figure 2.1 ----------------------------------------------
data("ForeignTrade", package = "pder")
plotplm(plm(imports~gnp, ForeignTrade), N = 10, seed = 4, lgth = .05)


## ------------- figure 2.2 ----------------------------------------------
data("TurkishBanks", package = "pder")
TurkishBanks <- na.omit(TurkishBanks)
TB <- pdata.frame(TurkishBanks)

plotplm(plm(log(cost)~log(output), TB), N = 8)


## ------------- figure 2.3 -----------------------------------------------
data("TexasElectr", package = "pder")
TexasElectr$cost <- with(TexasElectr, explab + expfuel + expcap)

plotplm(plm(log(cost)~log(output), TexasElectr), N = 8)


## ------------------------------------------------------------------------
data("DemocracyIncome25", package = "pder")

plotplm(plm(democracy~lag(log(income)), DemocracyIncome25), N = 8)


## -------------- Chapter 7 -----------------------------------------------

## -------------- figure 7.1 ----------------------------------------------
data("DemocracyIncome", package="pder")
set.seed(1)
di2000 <- subset(DemocracyIncome, year == 2000,
                 select = c("democracy", "income", "country"))
di2000 <- na.omit(di2000)
di2000$country <- as.character(di2000$country)
#di2000$country[- sample(1:nrow(di2000), 20)] <- NA
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
          axis.text = element_text(size = 6)
)

## -------------- figure 7.2 ----------------------------------------------
hatpi <-function(x, sr = 1){
  k <- (1-x)^2/(1-x^2)
  (x-1) * k / (sr^2 + k)
}
xs <- seq(0, 1, 0.01)
dd <- data.frame(x = rep(xs, 2), y = c(hatpi(xs), xs- 1), 
                 var = rep(c("bm1", "pi"), each = length(xs)))
library("ggplot2")
ggplot(dd, aes(x, y)) + geom_line(aes(lty = var)) + 
    scale_y_continuous(limits = c(-1, 0)) + 
    xlab(expression(rho)) + ylab("") + 
    scale_linetype_manual(values = 1:2, breaks = c("bm1", "pi"),
                        labels = list(expression(pi),
                                      expression(rho-1)))+
        theme(legend.text = element_text(size = 6), 
          legend.title= element_blank(),
          axis.title = element_text(size = 8),
          axis.text = element_text(size = 6))

## -------------- figure 7.3 ----------------------------------------------
set.seed(2)
snu <- 0.2
beta <- 0.8
T <- 30L
nu1 <- rnorm(T, sd = snu)
nu2 <- rnorm(T, sd = snu)
mu1 <- 1
mu2 <- 2
y1 <- y2 <- Ey1 <- Ey2 <- rep(0, T)
y1[1] <- 1
y2[1] <- 6
Ey1[1] <- Ey2[1] <- NA
for(t in 2:T){
  y1[t] <- y1[t-1] * beta + mu1 + nu1[t]
  Ey1[t] <- y1[t-1] * beta
  y2[t] <- y2[t-1] * beta + mu2 + nu2[t]
  Ey2[t] <- y2[t-1] * beta
}
dd <- data.frame(x = rep(1:30, 4), y = c(y1, y2, Ey1, Ey2),
                 var = rep(c("y", "E(y)"), each = 30 * 2),
                 id = rep(rep(letters[1:2], each = 30), 2), 
                 case = "Case 1")
set.seed(2)
snu <- 0.2
beta <- 0.8
T <- 30L
nu1 <- rnorm(T, sd = snu)
nu2 <- rnorm(T, sd = snu)
mu1 <- 1
mu2 <- 2
y1 <- y2 <- Ey1 <- Ey2 <- rep(0, T)
Ey1[1] <- Ey2[1] <- NA
for(t in 2:T){
  y1[t] <- y1[t-1] * beta + mu1 + nu1[t]
  Ey1[t] <- y1[t-1] * beta
  y2[t] <- y2[t-1] * beta + mu2 + nu2[t]
  Ey2[t] <- y2[t-1] * beta
}
dd2 <- data.frame(x = rep(1:30, 4), y = c(y1, y2, Ey1, Ey2),
                  var = rep(c("y", "E(y)"), each = 30 * 2),
                  id = rep(rep(letters[1:2], each = 30), 2),
                  case = "Case 2")
dd <- rbind(dd, dd2)
library("ggplot2")
gp <- ggplot(dd, aes(x=x, y = y, lty = var, colour = id)) + 
    geom_line() + facet_wrap(~ case) + 
    xlab("") + ylab("") +
    theme(legend.text = element_text(size = 6), 
          legend.title = element_blank(),
          axis.title = element_text(size = 8))
if (baw) gp <- gp + scale_color_grey()
gp


## -------------- Chapter 8 -----------------------------------------------

## -------------- figure 8.3 ----------------------------------------------
library("ggplot2")
library("dplyr")
library("tidyverse")
set.seed(2)
N <- 5E02
X = rnorm(N, 3, 5)
Y = - 1 + 0.5 * X + rnorm(N, 0, 1)
z <- data.frame(X = X, Y = Y)
z <- mutate(z,
            neg = factor(Y < 0, labels = c("yes", "no")),
            Yc = ifelse(Y > 0 , Y, 0),
            Yt = ifelse(Y > 0, Y, NA))
z2 <- gather(z, key, value, -X, - neg)
colols <- ifelse(baw, "black", "blue")
ys <- c("Y" = "Whole sample", "Yc" = "Censored sample", "Yt" = "Truncated sample")
gp <- ggplot(z2, aes(X, value)) + geom_point(size = 0.4, aes(colour = neg)) + 
    geom_abline(intercept = -1, slope = 0.5) +
    geom_smooth(method = "lm", se = FALSE, lty = "dotted", color = colols) +
    facet_wrap(~ key, ncol = 3, labeller = labeller(key = ys)) +
    guides(colour = FALSE)  + xlab("") + ylab("") + 
    theme(legend.text = element_text(size = 6), 
          legend.title= element_text(size = 8),
          axis.title = element_text(size = 8))
if (baw) gp <- gp + scale_color_grey()
gp

## -------------- figure 8.6 ----------------------------------------------
data("GiantsShoulders", package = "pder")

library("dplyr")
library("ggplot2")
GiantsShoulders <- mutate(GiantsShoulders, age = year - pubyear)
cityear <- summarise(group_by(GiantsShoulders, brc, age), 
                     cit = mean(citations, na.rm = TRUE))
print(ggplot(cityear, aes(age, cit)) + geom_line(aes(lty = brc)) + 
    geom_point(aes(shape = brc)) + scale_x_continuous(limits = c(0, 20))) + 
    theme(legend.text = element_text(size = 6), 
          legend.title= element_text(size = 6),
          axis.title = element_text(size = 6))


## -------------- Chapter 9 -----------------------------------------------

## -------------- figure 9.1 ----------------------------------------------
data("HousePricesUS", package = "pder")

housep.np <- pvcm(log(price) ~ log(income), data = HousePricesUS, model = "within")
housep.pool <- plm(log(price) ~ log(income), data = HousePricesUS, model = "pooling")
housep.within <- plm(log(price) ~ log(income), data = HousePricesUS, model = "within")

d <- data.frame(x = c(coef(housep.np)[[1]], coef(housep.np)[[2]]), 
                coef = rep(c("intercept", "log(income)"), 
                           each = nrow(coef(housep.np))))
library("ggplot2")
ggplot(d, aes(x)) + geom_histogram(col = "black", fill = "white", bins = 8) +
    facet_wrap(~ coef, scales = "free") + xlab("") + ylab("")

## -------------- figure 9.2 ----------------------------------------------
autoreg <- function(rho = 0.1, T = 100){
  e <- rnorm(T+1)
  for (t in 2:(T+1)) e[t] <- e[t]+rho*e[t-1]
  e
}
set.seed(20)

f <- data.frame(time = rep(0:40, 2), 
                rho = rep(c(0.2, 1), each = 41),
                y = c(autoreg(rho = 0.2, T = 40), 
                      autoreg(rho = 1, T = 40)))
library("ggplot2")
ggplot(f, aes(time, y)) + geom_line() + facet_wrap(~ rho) + xlab("") + ylab("")

## -------------- figure 9.3 ----------------------------------------------
R <- 1000
T <- 100
result <- c()
for (i in 1:R){
  y <- autoreg(rho=1, T=100)
  Dy <- y[2:T] - y[1:(T-1)]
  Ly <- y[1:(T-1)]
  z <- lm(Dy ~ Ly)
  result <- c(result, coef(z)[2] / sqrt(diag(vcov(z))[2]))
}

ggplot(data.frame(x = result), aes(x = x)) + 
    geom_histogram(fill = "white", col = "black", 
                   bins = 20, aes(y = ..density..)) +
    stat_function(fun = dnorm) + xlab("") + ylab("")


## -------------- Chapter 10 ----------------------------------------------

## -------------- figure 10.1 ---------------------------------------------
data("HousePricesUS", package="pder")
library("ggplot2")
data("fifty_states", package = "fiftystater")
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





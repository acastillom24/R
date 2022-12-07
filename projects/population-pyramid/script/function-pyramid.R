function (data, Laxis = NULL, Raxis = NULL, AxisFM = "g", 
          AxisBM = "", AxisBI = 3, Cgap = 0.3, Cstep = 1, Csize = 1, 
          Llab = "Males", Rlab = "Females", Clab = "Ages", 
          GL = TRUE, Cadj = -0.03, Lcol = "Cyan", Rcol = "Pink", 
          Ldens = -1, Rdens = -1, main = "", ...) 
{
  Left <- data[, 1]
  Right <- data[, 2]
  if (length(data) == 2) {
    Center <- row.names(data)
  }
  else {
    Center <- data[, 3]
  }
  if (is.null(Laxis)) {
    Laxis <- pretty(c(0, max(c(Left, Right))))
  }
  if (is.null(Raxis)) {
    Raxis <- Laxis
  }
  BX <- c(-1 - Cgap/2, 1 + Cgap/2)
  BY <- c(-0.05, 1.1)
  plot(BX, BY, type = "n", axes = FALSE, xlab = "", 
       ylab = "", main = main, ...)
  LL <- max(Laxis)
  LR <- min(Laxis)
  LS <- LL - LR
  LI <- length(Laxis)
  RL <- min(Raxis)
  RR <- max(Raxis)
  RS <- RR - RL
  RI <- length(Raxis)
  segments(-(Laxis - LR)/LS - Cgap/2, -0.01, -(Laxis - LR)/LS - 
             Cgap/2, 0.01)
  segments((Raxis - RL)/RS + Cgap/2, -0.01, (Raxis - RL)/RS + 
             Cgap/2, 0.01)
  if (GL) {
    segments(-(Laxis - LR)/LS - Cgap/2, 0, -(Laxis - LR)/LS - 
               Cgap/2, 1, lty = 3, col = "blue")
    segments((Raxis - RL)/RS + Cgap/2, 0, (Raxis - RL)/RS + 
               Cgap/2, 1, lty = 3, col = "blue")
  }
  lines(c(-1 - Cgap/2, -Cgap/2), c(0, 0), lty = 1)
  lines(c(-Cgap/2, -Cgap/2), c(0, 1), lty = 1)
  lines(c(1 + Cgap/2, Cgap/2), c(0, 0), lty = 1)
  lines(c(Cgap/2, Cgap/2), c(0, 1), lty = 1)
  text(-0.5 - Cgap/2, 1, Llab, pos = 3)
  text(0.5 + Cgap/2, 1, Rlab, pos = 3)
  text(0, 1, Clab, pos = 3)
  Ci <- length(Center)
  for (i in 0:(Ci - 1)) {
    if ((i%%Cstep) == 0) {
      text(0, i/Ci + Cadj, paste(Center[i + 1]), pos = 3, 
           cex = Csize)
    }
  }
  text(-(Laxis - LR)/LS - Cgap/2, rep(0, LI), paste(formatC(Laxis, 
                                                            format = AxisFM, big.mark = AxisBM, big.interval = AxisBI)), 
       pos = 1)
  text((Raxis - RL)/RS + Cgap/2, rep(0, RI), paste(formatC(Raxis, 
                                                           format = AxisFM, big.mark = AxisBM, big.interval = AxisBI)), 
       pos = 1)
  VB <- 0:(Ci - 1)/Ci
  VT <- 1:Ci/Ci
  LeftP <- -(Left - LR)/LS - Cgap/2
  rect(LeftP, VB, rep(-Cgap/2, Ci), VT, col = Lcol, density = Ldens)
  RightP <- (Right - RL)/RS + Cgap/2
  rect(rep(Cgap/2, Ci), VB, RightP, VT, col = Rcol, density = Rdens)
}
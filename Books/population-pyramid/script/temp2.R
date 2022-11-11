labs(title=expression(paste(alpha, delta, Omicron, 1000^2, x^(y + z), integral(f(x)*dx, a, b), sum(x[i], i==1, n))))


divlist  <- c("BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral")
names(divlist) <- divlist
quallist <- c("Accent","Dark2","Paired","Pastel1","Pastel2","Set1","Set2","Set3")
names(quallist) <- quallist
seqlist  <- c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd",
              "PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd")
names(seqlist) <- seqlist			  
colorblindlist<-c("BrBG","PiYG","PRGn","PuOr","RdBu","RdYlBu", 
                  "Dark2","Paired","Set2",
                  seqlist)

divnum <- rep(11, length(divlist))
names(divnum)  <- divlist
qualnum <- c( 8, 8, 12, 9, 8, 9, 8, 12)
names(qualnum) <- quallist
seqnum <- rep(9, length(seqlist))
names(seqnum) <- seqlist
namelist<-c(divlist,quallist,seqlist)
maxcolors <- c(divnum,qualnum,seqnum)
catlist<-rep(c("div","qual","seq"),c(length(divlist),length(quallist),length(seqlist)))
colorblind <- (namelist %in% colorblindlist)


function (n = NULL, type = "all", select = NULL, exact.n = TRUE, 
          colorblindFriendly = FALSE) 
{
  gaplist <- ""
  totallist <- c(divlist, gaplist, quallist, gaplist, seqlist)
  names(totallist) <- c(names(divlist), "gap1", names(quallist), 
                        "gap2", names(seqlist))
  gapnum <- max(c(divnum, qualnum, seqnum))
  totnum <- c(divnum, gapnum, qualnum, gapnum, seqnum)
  names(totnum) <- names(totallist)
  if (!(type %in% c("div", "qual", "seq", 
                    "all"))) {
    stop(paste(type, "is not a valid name for a color list\n"))
  }
  colorlist <- switch(type, div = divlist, qual = quallist, 
                      seq = seqlist, all = totallist)
  maxnum <- switch(type, div = divnum, qual = qualnum, seq = seqnum, 
                   all = totnum)
  if (!is.null(select)) {
    colorlist <- colorlist[select]
    maxnum <- maxnum[select]
    if (any(is.na(colorlist))) 
      stop(paste("Illegal value(s) of select: ", 
                 paste(select[is.na(colorlist)], collapse = " ")))
  }
  if (colorblindFriendly) {
    colorlist <- colorlist[names(colorlist) %in% c(colorblindlist, 
                                                   "gap1", "gap2")]
    maxnum <- maxnum[names(maxnum) %in% c(colorblindlist, 
                                          "gap1", "gap2")]
  }
  palattr <- switch(type, qual = "qualitative", div = "divergent", 
                    seq = "sequential", all = "qualitative+divergent+sequential")
  if (is.null(n)) 
    n <- maxnum
  if (length(n) == 1) 
    n <- rep(n, length(colorlist))
  if (exact.n) {
    keep <- n <= maxnum
    colorlist <- colorlist[keep]
    n <- n[keep]
    maxnum <- maxnum[keep]
  }
  if (any(n < 3) | exact.n & any(n > maxnum) | length(n) != 
      length(colorlist)) {
    warning("Illegal vector of color numbers")
    print(paste(n, collapse = " "))
  }
  n[n < 3] <- 3
  n[n > maxnum] <- maxnum[n > maxnum]
  nr <- length(colorlist)
  nc <- max(n)
  ylim <- c(0, nr)
  oldpar <- par(mgp = c(2, 0.25, 0))
  on.exit(par(oldpar))
  plot(1, 1, xlim = c(0, nc), ylim = ylim, type = "n", 
       axes = FALSE, bty = "n", xlab = "", ylab = "")
  for (i in 1:nr) {
    nj <- n[i]
    if (colorlist[i] == "") 
      next
    shadi <- brewer.pal(nj, colorlist[i])
    rect(xleft = 0:(nj - 1), ybottom = i - 1, xright = 1:nj, 
         ytop = i - 0.2, col = shadi, border = "light grey")
  }
  text(rep(-0.1, nr), (1:nr) - 0.6, labels = colorlist, xpd = TRUE, 
       adj = 1)
}

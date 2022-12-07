
# ipak function: install and load multiple R packages.
# check to see if packages are installed. Install them if they are not, then load them into the R session.

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# usage
packageurl <- 
  c("https://cran.r-project.org/bin/windows/contrib/3.6/arules_1.6-7.zip",
    "https://cran.r-project.org/bin/windows/contrib/3.6/cairoDevice_2.28.2.zip",
    "https://cran.r-project.org/bin/windows/contrib/3.6/Hmisc_4.5-0.zip",
    "https://cran.r-project.org/bin/windows/contrib/3.6/randomForest_4.6-14.zip",
    "https://cran.r-project.org/bin/windows/contrib/3.6/RGtk2_2.20.36.zip",
    "https://cran.r-project.org/bin/windows/contrib/3.6/RODBC_1.3-16.zip",
    "http://cran.nexr.com/bin/windows/contrib/3.5/playwith_0.9-54.zip",
    "http://cran.nexr.com/bin/windows/contrib/3.5/gWidgetsRGtk2_0.0-85.zip",
    "http://cran.nexr.com/bin/windows/contrib/3.5/gWidgets_0.0-54.zip")


install.packages(packageurl, repos=NULL, type="source")

# Pendiente instalación de rggobi
"http://cran.nexr.com/bin/windows/contrib/3.4/rggobi_2.1.21.zip"

packages <- 
  c("ada", "arules", "cairoDevice", "doBy", "ellipse", "fBasics", "Formula", 
    "fpc", "gplots", "gridBase", "gridExtra", "Hmisc", "htmlTable", "lattice", 
    "latticeExtra", "kernlab", "Matrix", "mice", "party", "playwith", "pmml", 
    "randomForest", "rattle", "reshape", "rggobi", "RGtk2", "ROCR", "RODBC", 
    "rpart", "survival")

ipak(packages)

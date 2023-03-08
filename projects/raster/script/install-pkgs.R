# Functions

status_pkg <-
  function(pkg){
    status <-
      as.data.frame(installed.packages()[ , c("Package", "Version", "Depends")])

    status <-
      status[status$Package %in% pkg, c("Version", "Depends")]

    return(status)
  }

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require,
         character.only = TRUE,
         quietly = TRUE,
         warn.conflicts = FALSE)
}

# Instalar pkg
pkg <-
  c('raster', 'sp', 'classInt', 'sf', 'rgdal', 'RColorBrewer', 'maptools', 'stringr',
    'raster', 'rosm', 'jsonlite', 'gridExtra', 'rgeos', 'ggmap', 'ggspatial',
    'ggplot2', 'dplyr', 'prettymapr')

ipak(pkg)

# Instalar pkg <<GADMTools>>

packageurl <-
  "https://cran.r-project.org/src/contrib/Archive/GADMTools/GADMTools_3.9-1.tar.gz"

install.packages(packageurl, repos = NULL, type = "source")

# Status pkgs
pkg <-
  c('raster', 'sp', 'classInt', 'sf', 'rgdal', 'RColorBrewer', 'maptools', 'stringr',
    'raster', 'rosm', 'jsonlite', 'gridExtra', 'rgeos', 'ggmap', 'ggspatial',
    'ggplot2', 'dplyr', 'prettymapr', 'GADMTools')

status_pkg(pkg)

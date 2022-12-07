
#################################################################
##                      PACKAGES: feather                      ##
#################################################################

# Instalación del paquete -------------------------------------------------
install.packages("feather")

# Carga de la biblioteca --------------------------------------------------
library(feather)

# Ejecución ---------------------------------------------------------------

## Guardar datos
write_feather(x = mtcars, path = "../Feather for R/mtcars.feather")

## Abrir datos
data.mtcars <- read_feather(path = "../Feather for R/mtcars.feather")
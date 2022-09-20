
# Establecemos el path ----------------------------------------------------

path <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()


# Cargamos los paquetes ---------------------------------------------------

library(haven) # Cargar datos
library(pROC)
library(dplyr) # Manipulacion

# Cargamos los datos ------------------------------------------------------

data.ROC <- read_sav(file = "datos/dfcorFSFI_1.sav")

data.ROC %>% 
  roc(var_agrup_dummy, FSFI_totalcorregido) %>% 
  plot()

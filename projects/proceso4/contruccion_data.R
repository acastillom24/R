
library(haven)
library(dplyr)

# a) Plaguicidas
# b) Fertilizantes
# i) GastoInsumos

data_Modulo1536 <- read_sav(file = "data/701-Modulo1536_08_Cap200e.sav")

data_Modulo1536 %>% 
  filter(CCDD == '10') %>%
  group_by(ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA) %>% 
  summarise(n = n()) %>% 
  dim

data_Modulo1536 <- data_Modulo1536 %>% 
  mutate(
    Plaguicidas = ifelse(P238==1,1,0),
    Fertilizantes = ifelse(P240==1,1,0),
    GastoInsumos = rowSums(
      x = data_Modulo1536 %>% select(P235_VAL, P237_VAL, P239, P241), 
      na.rm = T)
  ) %>% 
  filter(CCDD == '10') %>% 
  group_by(ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA) %>% 
  summarise(
    Plaguicidas = max(Plaguicidas),
    Fertilizantes = max(Fertilizantes),
    GastoInsumos = sum(GastoInsumos))

# c) Crédito
data_Modulo1545 <- read_sav(file = "data/701-Modulo1545_17_Cap900.sav")

data_Modulo1545 <- data_Modulo1545 %>% 
  filter(CCDD == '10') %>%
  mutate(
    Credito = case_when(
      P902 == 1 ~ 1,
      TRUE ~ 0
    )
  ) %>% 
  select(
    ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA, 
    Credito
  )

# d) Riego - P212: 1 = EL CULTIVO TIENE RIEGO
# j) SupSembrada
# k) Produccion

data_Modulo1529 <- read_sav(file = "data/701-Modulo1529_01_Cap100_1.sav")
data_Modulo1530 <- read_sav(file = "data/701-Modulo1530_02_Cap200ab.sav")

CAR_UA1 <- data_Modulo1529 %>% 
  filter(CCDD == '10') %>%
  mutate(
    EQUIV_TOTAL = as.numeric(paste0(P104_EQUIV_1,".",P104_EQUIV_2)),
    SUP_TOTAL = as.numeric(paste0(P104_SUP_1,".",P104_SUP_2))*EQUIV_TOTAL) %>% 
  select(
    ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA, EQUIV_TOTAL, SUP_TOTAL)

data_Modulo1530 <- data_Modulo1530 %>% 
  select(
    ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA, 
    P212, P219_CANT_1, P219_CANT_2, P210_SUP_1, P210_SUP_2, 
    P217_SUP_1, P217_SUP_2, P219_EQUIV_KG
  ) %>% 
  filter(CCDD == '10') %>%
  left_join(
    CAR_UA1, 
    by = c("ANIO","CCDD","CCPP","CCDI","CONGLOMERADO","NSELUA","UA"))

data_Modulo1530 <- data_Modulo1530 %>% 
  mutate(
    Riego = ifelse(P212 > 1,1,0),
    Produccion_t = (as.numeric(paste0(P219_CANT_1, '.', P219_CANT_2))) * 
      P219_EQUIV_KG/1000,
    sup_sembrada_ha = as.numeric(paste0(P210_SUP_1,".",P210_SUP_2)) * 
      EQUIV_TOTAL,
    sup_cosechada_ha = as.numeric(paste0(P217_SUP_1,".",P217_SUP_2)) * 
      EQUIV_TOTAL,
    tamanoUA = case_when(
      SUP_TOTAL >= 0 & SUP_TOTAL < 1 ~ 1,
      SUP_TOTAL >= 1 & SUP_TOTAL < 2 ~ 2,
      SUP_TOTAL >= 2 & SUP_TOTAL < 5 ~ 3,
      SUP_TOTAL >= 5 & SUP_TOTAL < 10 ~ 4,
      SUP_TOTAL >= 10 ~ 5,
      TRUE ~ NA_real_,
    ),
    Rendimiento = Produccion_t / sup_cosechada_ha) %>% 
  group_by(ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA) %>% 
  summarise(
    Riego = max(Riego), 
    sup_sembrada_ha = sum(sup_sembrada_ha, na.rm = T),
    Produccion_t = sum(Produccion_t, na.rm = T),
    Rendimiento = sum(Rendimiento, na.rm = T),
    tamanoUA = unique(tamanoUA)
    )

# e) GastoJornal
# f) CantJornaleros
# g) JornalPC
# h) GastoMaq

data_Modulo1546 <- read_sav(file = 'data/701-Modulo1546_18_Cap1000.sav')

data_Modulo1546 <- data_Modulo1546 %>%
  mutate(
    GastoJornal = rowSums(
      data_Modulo1546 %>% 
        select(
          P1001A_2A_1, P1001A_2A_2, P1001A_2B_1, P1001A_2B_2), 
      na.rm = T),
    CantJornaleros = rowSums(
      data_Modulo1546 %>% 
        select(
          P1001A_2A_1C, 
          P1001A_2A_2C, 
          P1001A_2B_1C, 
          P1001A_2B_2C), 
      na.rm = T),
    JornalPC = case_when(
      CantJornaleros == 0 ~ 0,
      TRUE ~ GastoJornal / CantJornaleros
    ),
    GastoMaq = rowSums(
      data_Modulo1546 %>% 
        select(
          P1001A_5A, 
          P1001A_5B, 
          P1001A_6A, 
          P1001A_6B, 
          P1001A_6C), 
      na.rm = T)) %>% 
  filter(CCDD == '10') %>%
  select(
    ANIO, CCDD, CCPP, CCDI, CONGLOMERADO, NSELUA, UA, 
    GastoJornal, CantJornaleros, JornalPC, GastoMaq)

# Unión de los datasets
dataRendimeinto <- inner_join(
  x = data_Modulo1536, 
  y = data_Modulo1545,
  by = c("ANIO","CCDD","CCPP","CCDI","CONGLOMERADO","NSELUA","UA"))

dataRendimeinto <- inner_join(
  x = dataRendimeinto, 
  y = data_Modulo1530,
  by = c("ANIO","CCDD","CCPP","CCDI","CONGLOMERADO","NSELUA","UA"))

dataRendimeinto <- inner_join(
  x = dataRendimeinto, 
  y = data_Modulo1546,
  by = c("ANIO","CCDD","CCPP","CCDI","CONGLOMERADO","NSELUA","UA"))


dataRendimeinto <- as.data.frame(dataRendimeinto)

library(skimr)

dataRendimeinto %>% 
  as.data.frame() %>% 
  skim()

# Respaldo de la data
write.csv(
  x = dataRendimeinto, 
  file = "export/dataRendimiento.csv", 
  row.names = F)

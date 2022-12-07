
# Path
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Carga de bibliotecas
library(dplyr)
library(skimr)
library(readr)
library(VIM)
library(DMwR2)


# Carga de datos
housing <- read.csv(file = "housing_train.csv")

# 
housing <- housing %>% 
  select(-1)

housing %>%
  skim() %>%
  select(skim_variable, complete_rate) %>%
  filter(complete_rate < 0.75) %>% 
  mutate(complete_rate = complete_rate*100)

names(skim(housing2))


str(housing)

# CentralImputation()
centralImputation()
centralValue()

names(housing)


?skim




# Carga de bibliotecas
library(dplyr)

urlData <- 
  "https://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data"

namesGerman <- 
  c("account_status", "months", "credit_history", "purpose", "credit_amound",
    "savings", "employment", "installment_rate", "personal_status", "guarantors",
    "residence", "property", "age", "other_installment", "housing", "credit_cards",
    "job", "dependents", "telephone", "foreign_worker", "credit_rating")

dfGerman <- 
  read.table(
    file = urlData, 
    header = F, 
    col.names = namesGerman)

# Clasificación de los datos
table(dfGerman$credit_rating)

# Re-codificamos la variable target(credit_rating) y asignamos niveles a las variable categoricas cuya escala de medida sea ordinal.
dfGerman <- 
  dfGerman %>% 
  mutate(
    credit_rating = if_else(credit_rating == 1, 1, 0),
    account_status = factor(
      x = account_status, 
      levels = c("A11", "A12", "A13", "A14")),
    credit_history = factor(
      x = credit_history,
      levels = c("A30", "A31", "A32", "A33", "A34")),
    purpose = factor(
      x = purpose,
      levels = c("A40", "A41", "A42", "A43", "A44", "A45", "A46", "A47", "A48",
                 "A49", "A410")))

# Ejecución del modelo
modelLogit <- 
  glm(
    formula = credit_rating ~ .,
    family = binomial,
    data = dfGerman)

selectVarsModel <- 
  function(modelLogit, sig = 0.05){
    if(is.object(modelLogit)){
      varSig <- 
        summary(modelLogit)$coeff[-1, 4] < sig
      varSig <- 
        varSig[varSig == TRUE]
      return(names(varSig))
    }
  }

# Variables significativas
selectVarsModel(
  modelLogit = modelLogit,
  sig = 0.05)

# Predicción del modelo
predictModelLogit <- 
  predict(
    object = modelLogit,
    newdata = dfGerman,
    type = "response")

plot(
  x = predictModelLogit, 
  y = dfGerman$credit_rating)

# Filas: Actual
# Columnas: Predicción

matrizConfuccion <- 
  function(Actual, Prediccion, Transpose = FALSE){
    
    if(Transpose)
      etiqueta <- 
        c("Negativa", "Positiva")
      else
        etiqueta <- 
          c("Positiva", "Negativa")
      
    matriz <- table(Actual, Prediccion)
    colnames(matriz) <- etiqueta
    rownames(matriz) <- etiqueta
    
    error <- 
      (matriz[1,2] + matriz[2,1]) / sum(matriz)
    
    return(list(
      matriz = matriz,
      error = error
    ))
  }

result <- 
  matrizConfuccion(
  Actual = dfGerman$credit_rating,
  Prediccion = floor(predictModelLogit + 0.5),
  Transpose = TRUE)

result$matriz
result$error

# 160 clientes con calificación negativa han sido clasificados correctamente.
# 626 clientes con calificación positiva han sido clasificados correctamente.
# 140 clientes con calificación negativa inicialmente han sido clasificados incorrectamente.
# 140 clientes con calificación negativa inicialmente han sido clasificados incorrectamente.

library(ROCR)
predict <- 
  ROCR::prediction(
    predictions = predictModelLogit, 
    labels = dfGerman$credit_rating)

perf <- 
  performance(
    prediction.obj = predict, 
    measure = "tpr", 
    x.measure = "fpr")

plot(
  x = perf, 
  main="Curva ROC", 
  lwd = 3)

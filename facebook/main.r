
# Generamos un objeto dataframe de 100,000 registros
df <- data.frame(id = 1:100000, x = 1:100000 * 2, y = 1:100000 * 3)

# Identificador de extracción de filas
xx <- seq(0, 100000, by = 5)
xx[1] <- 1

# Extracción de las equivalencias
dfExt <- df[xx,]

head(dfExt)

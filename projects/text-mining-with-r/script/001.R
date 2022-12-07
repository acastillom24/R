install.packages("mpa", dependencies = T)
library(mpa)

?matriz.mpa()

data("revista")
View(revista)

revista[1]
revista[2]

mat <- matriz.mpa(leer.mpa = revista, 
                  sep.ind = "ind0",
                  sep.pal = "/",
                  fmin = 3, 
                  cmin = 1)

?leer.mpa()
revista
class(revista)
# Matriz de asociación
View(mat[["Matriza"]])
# Matriz de Co-ocurrencias
View(mat[["Matrizc"]])
# Vector de palabras
View(mat[["Palabras"]])
# Lexical table
View(mat[["tl"]])

prueba <- leer.mpa(textfile = "data/palabras_clave.txt", encoding = "latin1")

prueba

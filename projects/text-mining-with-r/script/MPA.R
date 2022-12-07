
# Bibliotecas -------------------------------------------------------------
library(mpa)
library(ade4)
library(FactoClass)
library(readxl)
library(tidyr)
library(dplyr)

# Cargamos la data --------------------------------------------------------
data.corpus <- leer.mpa(textfile = "export/corpus_2019.txt")
Id_Notas <- read_excel(path = "export/Id_Nota.xlsx",
                       sheet = "Hoja1") #Hoja1
notas.data <- read_excel(path = "data/pc.xlsx",
                         sheet = "Hoja3") #Hoja3

# creación de las matriz de asociaciones y co-ocurrencias -----------------
mat <- matriz.mpa(leer.mpa = data.corpus, 
                  sep.ind = "ind0",
                  sep.pal = "/",
                  fmin = 3, 
                  cmin = 1)

# Matriz de asociación
View(mat[["Matriza"]])
# Matriz de Co-ocurrencias
View(mat[["Matrizc"]])
# Vector de palabras
View(mat[["Palabras"]])
# Lexical table
View(mat[["tl"]])

# palabras y su frecuencia ------------------------------------------------
d <- diag(mat$Matrizc)

# clasificación -----------------------------------------------------------
clas <- mpa(mat$Matriza,10,mat$Palabras)

# diagrama estratégico ----------------------------------------------------
diagram.mpa(clas, tmin = 3)

# red de cada una de las clases -------------------------------------------
for(i in 1:3){
  windows()
  plotmpa(i, mat$Matriza, clas)
}

plotmpa(1, mat$Matriza, clas)
plotmpa(2, mat$Matriza, clas)
plotmpa(3, mat$Matriza, clas)



# Análisis de correspondecias simples -------------------------------------

# Depuración de las notas -------------------------------------------------
notas <- notas.data %>% 
  gather("Id_Nota", "PC", 1:29) %>% 
  na.omit

notas.data <- inner_join(notas, Id_Notas, by = "Id_Nota") %>% 
  select(PC, Month)

# Construimos la tabla de frecuencias -------------------------------------
notas.tabla <- notas.data %>% 
  table

# View(notas %>% 
#        group_by(PC) %>% 
#        summarise(n = n()))

# Relación a nivel de variables (Chi-Cuadrado) ----------------------------
chisq.test(notas.tabla)

N <- notas.tabla
n <- sum(margin.table(x = notas.tabla,
                      margin = 1))
P <- N/n
r <- margin.table(P, 1)
c <- margin.table(P, 2)

Dr <- diag(r)
Dc <- diag(c)

# Paso 1: Calcular la matriz de residuos estandarizados -------------------
S <- diag(r^(-0.5)) %*% (P - r %*% t(c)) %*% diag(c^(-0.5))

# Paso 2: Calcular la descomposición SVD de S -----------------------------
D_alpha <- svd(S)$d # Inercia = varianza
U <- svd(S)$u # Filas
V <- svd(S)$v # Columnas

# Paso 3: Coordenadas principales de filas --------------------------------

# Paso 4: Coordenadas principales de columnas -----------------------------
library(ca)
plot(ca(N))

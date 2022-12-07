
# Carga de bibliotecas ----------------------------------------------------
library(dplyr)
library(stringr)

# 14.2.5 Ejercicios -------------------------------------------------------

# 14.3 Coincidencia de patrones con expresiones regulares

str_view()
str_view_all()

## 14.3.1 Coincidencias básicas

### (.): Coincide con cualquier caracter
x1 <- c("apple", "banana", "pear")
str_view(x1, "..a..")

### (\\.): Coincidencia del punto
x2 <- c("abc", "a.c", "bef")
str_view(x2, "a\\.c")

### (\\\\): Coincidencias de la barra invertida
x3 <- "a\\b"
str_view(x3, "\\\\")

## 14.3.2 Anclajes

### ^ para que coincida con el comienzo de la cadena.
### $ para que coincida con el final de la cadena.

x1 <- c("apple", "banana", "pear")

str_view(x1, "^a")
str_view(x1, "na$")

x2 <- c("apple pie", "apple", "apple cake")
str_view(x2, "^apple$")

### 14.3.2.1 Ejercicios
# 1. ¿Cómo harías coincidir la cadena "$^$"?
x <- "$^$"
str_view(x, ".\\^.")
str_view(x, "\\$\\^\\$")

# 2. Dado el corpus de palabras comunes stringr::words, cree expresiones 
# regulares:
x <- stringr::words

## 1. Comience con "y"
str_view(x, "^y", match = T)

## 2. Termine con "x"
str_view(x, "x$", match = T)

## 3. Tienen exactamente tres letras de largo. No uses str_length()
str_view(x, "^...$", match = T)

## 4. Tener siete letras o más.
str_view(x, ".......", match = T)
View(x)

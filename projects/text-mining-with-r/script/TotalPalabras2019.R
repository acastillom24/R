
# Bibliotecas -------------------------------------------------------------
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(tidytext)
library(openxlsx)

# Cargamos todas las notas ------------------------------------------------
load(file = "data/Notas.RData")

# Extraemos la fecha de las notas -----------------------------------------
Gestion.data <- Notas %>% 
  mutate(Fecha = substr(x = Fecha,
                        start = 16,
                        stop = 25)) %>% 
  separate(col = Fecha, into = c("Day","Month","Year"), sep = "/") %>% 
  mutate(Day = as.numeric(Day), Month = as.numeric(Month), Year = as.numeric(Year)) %>%
  filter(Year == 2019,
         Month < 7) %>% 
  arrange(Month, Day) %>% 
  unite(col = "Fecha", Day, Month, Year,sep = "-")

# Agregamos el ID de las notas mediante la fecha --------------------------
for(i in 1:nrow(Gestion.data)){
  if(i < 10){
    Gestion.data$Id_Nota[i] = paste0("Nota-0", i)
  } else{
      Gestion.data$Id_Nota[i] = paste0("Nota-", i)
      }
}

# Limpieza de las notas periodística --------------------------------------
depurar <- function(Nota){
  # texto a minusculas
  nuevo_texto <- tolower(Nota)
  # Eliminacion de paginas web (palabras que empiezan por "http." seguidas 
  # de cualquier cosa que no sea un espacio)
  nuevo_texto <- str_replace_all(nuevo_texto,"http\\S*", "")
  # Eliminacion de signos de puntuacion
  nuevo_texto <- str_replace_all(nuevo_texto,"[[:punct:]]", " ")
  # Eliminacion de numeros
  nuevo_texto <- str_replace_all(nuevo_texto,"[[:digit:]]", " ")
  # Eliminacion de espacios en blanco multiples
  nuevo_texto <- str_replace_all(nuevo_texto,"[\\s]+", " ")
  return(nuevo_texto)
}

data.gestion.dep <- Gestion.data %>% 
  mutate(Notas_depuradas = map(.x = Nota,
                               .f = depurar)) %>% 
  select(Id_Nota, Notas_depuradas)

# Tokenizers o Quanteda ---------------------------------------------------
data.gestion.2019 <- data.gestion.dep %>% 
  unnest_tokens(word, Notas_depuradas)

# Palabras mas utilizadas en cada nota periodistica -----------------------
palabras_mas_usadas <- data.gestion.2019 %>% 
  group_by(Id_Nota, word) %>% 
  count(word) %>% 
  group_by(Id_Nota) %>%
  arrange(Id_Nota, desc(n))

write.xlsx(x = palabras_mas_usadas,
           file = "export/TotalPalabras2019.xlsx")



# Packages ----------------------------------------------------------------
# install.packages("tidyverse")
# install.packages("tidytext")
# install.packages("sm")
# install.packages("RColorBrewer")
# install.packages("wordcloud")
# install.packages("gridExtra")
# install.packages("scales")
# install.packages("openxlsx")
# install.packages(c("stopwords", "tidytext", "wordcloud"))
# install.packages("corrplot", dependencies = T)

# ==================== ****************************************** ====================
# El fichero Gestion contiene toda la recopilación de las notas periodisticas
load(file = "data/Gestion.RData")

# RESTRUCTURAR LOS DATOS --------------------------------------------------
Id_Nota <- c(); Fecha <- c(); Titulo <- c(); Subtitulo <- c(); Producto <- c(); Nota <- c()

for (i in 1:43) {
  if(i < 10){Id_Nota[i] <- paste0("Nota-0",i)} else{Id_Nota[i] <- paste0("Nota-",i)}
  Fecha[i] <- as.character(Gestion[[i]][1,2])
  Titulo[i] <- as.character(Gestion[[i]][2,2])
  Subtitulo[i] <- as.character(Gestion[[i]][3,2])
  Producto[i] <- as.character(Gestion[[i]][4,2])
  Nota[i] <- as.character(Gestion[[i]][5,2])
}
library(dplyr)
Notas <- tibble(Id_Nota,Fecha,Titulo,Subtitulo,Producto,Nota)
save(Notas, file = "data/Notas.RData")

# ORDENAR LOS DATOS -------------------------------------------------------
library(tidyr)
load(file = "data/Notas.RData")
Notas$Fecha <- substr(x = Notas$Fecha, start = 16,stop = 25)

Notas_0119_0719 <- Notas %>% 
  separate(col = Fecha, into = c("Day","Month","Year"), sep = "/") %>% 
  mutate(Day = as.numeric(Day), Month = as.numeric(Month), Year = as.numeric(Year)) %>%
  filter(Year == 2019, Month <= 7) %>% 
  arrange(Month, Day) %>% 
  unite(col = "Fecha", Day, Month, Year,sep = "-")

## Recodificamos nuevamente los datos
for(i in 1:nrow(Notas_0119_0719)){
  if(i < 10){Notas_0119_0719$Id_Nota[i] = paste0("Nota-0", i)} else{Notas_0119_0719$Id_Nota[i] = paste0("Nota-", i)}
  }

save(Notas_0119_0719, file = "data/Notas_0119_0719.RData")

# LIMPIEZA DE LAS NOTAS PERIODISTICAS -------------------------------------
load(file = "data/Notas_0119_0719.RData")
library(stringr)
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

library(purrr)
Notas_Depuradas_0119_0719 <- Notas_0119_0719 %>% 
  mutate(Notas_depuradas = map(.x = Nota,
                                 .f = depurar)) %>% 
  select(Id_Nota, Notas_depuradas)

save(Notas_Depuradas_0119_0719, file = "data/Notas_Depuradas_0119_0719.RData")

# TOKENIZERS O QUANTEDA ---------------------------------------------------
load(file = "data/Notas_Depuradas_0119_0719.RData")

library(dplyr)
library(tidytext)

Notas <- Notas_Depuradas_0119_0719 %>% 
  unnest_tokens(word,Notas_depuradas)

# ANALISIS EXPLORATORIO ---------------------------------------------------
## Frecuencia de palabras
### Total de palabras utilizadas en cada nota

total_palabras <- Notas %>%
  group_by(Id_Nota) %>% 
  summarise(n = n())

total_palabras %>% 
  summarise(media_word = median(n), mediana_word = mean(n), varianza = var(n), min_word = min(n), max_word = max(n), rango = max(n)-min(n))

library(ggplot2)
Notas %>%  
  ggplot(aes(x = Id_Nota)) + geom_bar(color = "black", fill = "skyblue") + coord_flip() + theme_minimal() + 
  ggtitle("Total de palabras utilizadas en cada nota") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  labs(caption = "Datos del diario Gestión",
       x = "", y = "")

### Palabras distintas utilizadas en cada nota
palabras_distintas <- Notas %>% 
  distinct() %>%  
  group_by(Id_Nota) %>%
  summarise(n = n())

palabras_distintas %>% 
  summarise(media_word = median(n), mediana_word = mean(n), varianza = var(n), min_word = min(n), max_word = max(n), rango = max(n)-min(n))

Notas %>% 
  distinct() %>%
  ggplot(aes(x = Id_Nota)) + geom_bar() + coord_flip() + theme_bw()

### Palabras mas utilizadas en cada nota periodistica
palabras_mas_usadas <- Notas %>% 
  group_by(Id_Nota, word) %>% 
  count(word) %>% 
  group_by(Id_Nota) %>%
  # top_n(10, n) %>% 
  arrange(Id_Nota, desc(n)) # %>% 
  # print(n=30)

library(openxlsx)
write.xlsx(x = palabras_mas_usadas,
           file = "export/TotalPalabras.xlsx")

### Stop Words
require(sm)
# stopwords::stopwords(language = "es")
otras_palabras <- c("s", "si", "x", "tres", "tal", "facts", "así", "sino",
                    "vez", "ser", "i", "ii", "ex", "d", "aid", "cite", "etc",
                    "dos", "ido", "ir", "allí", "dotó", "u", "alla", "cómo",
                    "aún", "irá", "alta", "través", "uu", "viene", "debe", "dijo",
                    "va", "par")
palabras <- c(stopwords::stopwords(language = "es"), 
              otras_palabras)

Notas_detention <- Notas %>% 
  filter(!(word %in% palabras))

### Representacion grafica de las frecuencias

Notas_detention %>% 
  group_by(Id_Nota, word) %>% 
  count(word) %>%
  group_by(Id_Nota) %>%
  filter(Id_Nota == c("Nota-17", "Nota-18", "Nota-19", "Nota-20")) %>% 
  top_n(5, n) %>% 
  arrange(Id_Nota, desc(n)) %>%
  ggplot(aes(x = reorder(word,n), y = n, fill = Id_Nota)) +
  geom_col() +
  theme_bw() +
  labs(y = "", x = "") +
  theme(legend.position = "none") +
  coord_flip() +
  facet_wrap(~Id_Nota, scales = "free", ncol = 2, drop = TRUE)

### Word Clouds

library(RColorBrewer)
library(wordcloud)
# library(wordcloud2)

wordcloud_custom <- function(grupo, df){
  #print(grupo)
  set.seed(123)
  wordcloud(words = df$word, 
            freq = df$frecuencia,
            min.freq = 1, 
            max.words = Inf, 
            random.order = FALSE, 
            rot.per = 0.3, 
            scale = c(4, .5),
            colors = brewer.pal(8, "Dark2"))
}

library(tidyr)
df_Notas <- Notas_detention %>% 
  group_by(Id_Nota, word) %>% 
  count(word) %>%
  group_by(Id_Nota) %>% 
  mutate(frecuencia = n / n()) %>%
  arrange(Id_Nota, desc(frecuencia)) %>% 
  nest()

library(purrr)

walk2(.x = df_Notas$Id_Nota, .y = df_Notas$data, .f = wordcloud_custom)

# CORRELACION ENTRE NOTAS POR PALABRAS UTILIZADAS -------------------------

library(gridExtra)
library(scales)
library(tidyr)

Notas_spread <- Notas_detention %>% 
  group_by(Id_Nota, word) %>% 
  count(word) %>% 
  spread(key = Id_Nota, value = n, fill = NA, drop = TRUE)

stats::cor.test(~ `Nota-01` + `Nota-02`, method = "pearson", data = Notas_spread)

cor_pearson <- matrix(nrow = 20, ncol = 20)

for (i in 2:21) {
  for(j in 2:21){
    print(paste("Nota-",(j-1)))
    cor_pearson[(i-1),(j-1)] <- Notas_spread[,c(i,j)] %>% 
      na.omit %>% 
      cor %>% 
      .[1,2]
  }
}

library(corrplot)

corrplot(cor_pearson, method = "number")
        
## Representacion grafica de las correlaciones

n1 <- ggplot(Notas_spread, aes(Nota_08, Nota_09)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  theme_bw() +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank())

n2 <- ggplot(Notas_spread, aes(Nota_02, Nota_09)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  theme_bw() +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank())

grid.arrange(n1, n2, nrow = 1)


# GUARDAR OBJETOS ---------------------------------------------------------

library(openxlsx)
write.xlsx(x = palabras_mas_usadas,
           file = "TotalPalabras.xlsx")




## Palabras clave
library(readxl)
palabras_clave <- read_xlsx(path = "export/TotalPalabrasClaves.xlsx", sheet = "Main")
palabras_clave <- as.data.frame(unique(palabras_clave$key_word))
names(palabras_clave) <- "word"

## corpus
corpus <- read_xlsx(path = "export/Corpus.xlsx")

corpus <- corpus %>% 
  group_by(Id_Nota, notas_detention) %>% 
  summarise(n = n())

freq_corpus <- corpus %>% 
  rename(word = notas_detention) %>% 
  group_by(word) %>% 
  summarise(n = sum(n)) %>% 
  arrange(-n)

## Join entre las palabras clave y el corpus
palabras_clave <- left_join(x = palabras_clave, y = freq_corpus, by = "word")

palabras_clave <- palabras_clave %>% 
  arrange(-n)

View(palabras_clave)

library(data.table)

Notas_detention %>% 
  filter(word %like% "^inno")

install.packages("SnowballC")
library(SnowballC)

notas_detention <- wordStem(Notas_detention$word)

class(notas_detention)

stand_word <- as.data.frame(notas_detention) 

stand_word %>% 
  filter(notas_detention %like% "^inno")

install.packages("tm")
library(tm)

notas_detention <- tm_map(x = notas_detention, FUN = stemDocument, "spanish")

## frecuencia de palabras por ctd de repetición en el corpus
ctd_rep_corpus <- palabras_clave %>% 
  group_by(n) %>% 
  summarise(freq = n()) %>% 
  arrange(-freq)

Notas_detention <- cbind(Notas_detention, notas_detention)

install.packages("xlsx")
library(xlsx)

write.xlsx(x = Notas_detention, file = "export/Corpus.xlsx", row.names = F)

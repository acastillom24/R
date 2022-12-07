
# Bibliotecas -------------------------------------------------------------
library(readxl)
library(tidyr)
library(dplyr)

# Cargamos los datos ------------------------------------------------------
notas.data <- read_excel(path = "data/pc.xlsx")

# Construimos el corpus ---------------------------------------------------
data.corpus <- c()
for(i in 1:29){
  key.word.data <- na.omit(notas.data[,i])
  num.row <- dim(key.word.data)[1]
  key.word <- key.word.data[1, 1]
  for(j in 2:num.row){
    key.word.2 <- key.word.data[j, 1]
    key.word <- paste0(key.word, "/", key.word.2)
  }
  key.word <- paste0("/ind0/", key.word, "/")
  data.corpus[i] <- key.word
}

write.table(x = data.corpus, 
            file = "export/corpus_2019.txt",
            sep = "\t",
            quote = F,
            row.names = F, 
            col.names = F)

# install.packages("googledrive")
# install.packages("googlesheets4")

library(googledrive)
library(googlesheets4)

# drive_auth(email = "alin.castillo@unmsm.edu.pe", cache = ".secrets")
# gs4_auth(email = "alin.castillo@unmsm.edu.pe", cache = ".secrets")

id.sheet = "16TUjrUMFJG7JW84OZilPo2mePgqV02W4"

corpus <- read_sheet(ss = id.sheet, sheet = "key_word")

drive_ls(path = "")

library(readxl)
read_excel(path = "https://docs.google.com/spreadsheets/d/16TUjrUMFJG7JW84OZilPo2mePgqV02W4/edit#gid=1955605439",
           sheet = "key_word")


library(googledrive)
temp <- tempfile(pattern = "Corpus", 
                 tmpdir = "D:\\Proyectos\\GitHub\\R\\text-mining-with-r", 
                 fileext = ".xlsx")

dl <- drive_download(file = as_id("16TUjrUMFJG7JW84OZilPo2mePgqV02W4"), 
                     path = temp, 
                     overwrite = TRUE)

drive_download(file = as_id("16TUjrUMFJG7JW84OZilPo2mePgqV02W4"), )

out <- unzip(temp, exdir = tempdir())
bank <- read.csv(out[14], sep = ";")

library(mpa)

data("revista")
View(revista)

class(revista)

rr <- as.data.frame(revista)

View(rr)
mpa()

datos <- revista
matriz <- matriz.mpa(datos, fmin=3, cmin=1)
d <- diag(matriz$Matrizc)
clas <- mpa(matriz$Matriza,10,matriz$Palabras)
diagram.mpa(clas,tmin=3)
leer.mpa(textfile = data.keyword)


library(readxl)
data.corpus <- read_excel(path = "data/Corpus_KeyWord.xlsx", sheet = "corpus")
data.keyword <- read_excel(path = "data/Corpus_KeyWord.xlsx", sheet = "key_word")


View(data.keyword)

keyword <- data.keyword %>% 
  group_by(key_word) %>% 
  summarise(f = n()) %>% 
  arrange(-f)

class(keyword)

names(data.keyword)

library(RColorBrewer)
library(wordcloud)

set.seed(123)
wordcloud(words = keyword$key_word, 
          freq = keyword$f,
          min.freq = 1, 
          max.words = Inf, 
          random.order = FALSE, 
          rot.per = 0.3, 
          scale = c(4, .5),
          colors = brewer.pal(8, "Dark2"))

data.corpus %>% 
  group_by(Id_Nota, notas_detention) %>% 
  count(word) %>%
  group_by(Id_Nota) %>%
  top_n(5, n) %>% 
  arrange(Id_Nota, desc(n)) %>%
  ggplot(aes(x = reorder(word,n), y = n, fill = Id_Nota)) +
  geom_col() +
  theme_bw() +
  labs(y = "", x = "") +
  theme(legend.position = "none") +
  coord_flip() +
  facet_wrap(~Id_Nota, scales = "free", ncol = 5, drop = TRUE)


#dim(data.keyword)[1]
data.corpus <- c()
k = 1
i = 1
for(s in 1:19){
  j = 1
  if (i < dim(data.keyword)[1]){
    while(data.keyword$id_nota[i] == data.keyword$id_nota[i+1]){
      if (j == 1){
        data.corpus[k] <- paste0("/ind0/", data.keyword$key_word[i], "/", data.keyword$key_word[i + 1])
      }else{
        data.corpus[k] <- paste0(data.corpus[k], "/", data.keyword$key_word[i + 1])
      }
      i = i + 1
      j = j + 1
    }
    i = i + 1
    k = k + 1
  }
}
<
  
datos <- data.corpus
matriz <- matriz.mpa(datos, fmin=3, cmin=1)
d <- diag(matriz$Matrizc)
clas <- mpa(E = matriz$Matriza, tmax = 10, palabras = matriz$Palabras)
diagram.mpa(mpa = clas, tmin = tmin=3)

for(i in 1:4){
  windows()
  plotmpa(clase = i, E = matriz$Matriza, mpa = clas)
}

rr <- as.data.frame(datos)
View(rr)
# Matriz de asociación
View(matriz[["Matriza"]])
# Matriz de Co-ocurrencias
View(matriz[["Matrizc"]])
# Vector de palabras
matriz[["Palabras"]]
# Lexical table
matriz[["tl"]]

df <- as.data.frame(matriz$Matriza)
write.xlsx(x = df, file = "export/matriz_asociaciones.xlsx")

df <- as.data.frame(matriz$Matrizc)
write.xlsx(x = df, file = "export/matriz_coocurrencias.xlsx")

View(matriz$Matriza)
df <- matriz$Matriza
class(matriz$Matriza)


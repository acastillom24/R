
# Info from: --------------------------------------------------------------
## http://spark.apache.org/
## https://therinspark.com/
## https://db-blog.web.cern.ch/blog/luca-canali/2017-08-apache-spark-and-cern-open-data-example
## https://academic.oup.com/gigascience/article/7/8/giy098/5067872


# Definimos el path -------------------------------------------------------
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Creamos los folders necesarios ------------------------------------------
if(dir.exists("export") != T){dir.create("export")}
if(dir.exists("info") != T){dir.create("info")}
if(dir.exists("script") != T){dir.create("script")}
if(dir.exists("data") != T){dir.create("data")}

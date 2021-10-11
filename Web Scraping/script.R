
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Options to kill processes
## Option 1
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

## Option 2
system(paste0("Taskkill /F /T" ," /PID ", pid = rD$server$process$get_pid()))

rD <- rsDriver(port = 4567L, 
               browser = c("chrome"), 
               chromever = "94.0.4606.61")

binman :: list_versions ("seleniumserver")
binman::list_versions("chromedriver")
binman :: list_versions ("geckodriver")
binman :: list_versions ("iedriverserver")
binman :: list_versions ("phantomjs")

rD <- rsDriver(port = 9881L, 
               browser = "chrome", 
               version = "3.141.59", 
               chromever = "94.0.4606.61", 
               geckover = "0.29.0", 
               check = T)


remDr <- rD[["client"]]

remDr$navigate("")

















# Install the rvest package

library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"



my_html <- session(url)

# We'll access the first table from the web page. In this case this is
# easy since there is only one table. On pages with many tables this will
# be a trial and error process

my_tables <- html_nodes(my_html,"table")[[1]]
populous_table <- html_table(my_tables)

populous_table <- populous_table[-1,-(7:8)]
populous_table$Population <- as.numeric(gsub(",","",populous_table$Population))/100000

names(populous_table) = c("Rank","Country", "Region", "Population", "% Population", "Date update")

# Let's plot the first 10 rows

library(lattice)
xyplot(Population ~ as.factor(Country), 
       populous_table[1:10,],
       scales = list(x = c(rot=60)),
       type="h",
       main="Most Densely Populated Countries", 
       xlab = "Country")


s <- data_finanzas %>% 
  dplyr::group_nest(path)



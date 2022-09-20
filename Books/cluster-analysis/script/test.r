x <- rnorm(100, mean = 10, sd = 1)

y <- runif(100, min = -1, max = 1)
data <- data.frame(x, y)

readr::write_csv(mtcars, ".\\data\\mtcars.csv", append = T)


plot(rnorm(100), col = "blue")

View(mtcars)

file.edit("~/.Rprofile")


shiny::runExample("01_hello")
View(lst)

netstat - aon
taskkill /F /PID 3256


library(ggplot2)

ggplot(mpg, aes(displ, hwy, colour = class)) +
geom_point()

library(ggplot2)

plot(x, y)

library(plotly)

str(diamonds)

p <- ggplot(diamonds, aes(x = cut, fill = clarity)) + 
geom_bar(position = "dodge")

ggplotly(p)

getwd()

rmarkdown::run("./info/Methods-for-measuring-distances.rmd")


install.packages("rmarkdown")

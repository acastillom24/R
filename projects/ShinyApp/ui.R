library(shiny)

ui <- fluidPage(
  sliderInput(
    inputId = "num", 
    label = "Selecciona un número", 
    value = 25,
    min = 1,
    max = 100
  ),
  plotOutput("hist")
)
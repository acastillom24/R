
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

library(shiny)

ui <- fluidPage(
  sliderInput(
    inputId = "num", 
    label = "Selecciona un número", 
    value = 25,
    min = 1,
    max = 100
  ),
  actionButton(inputId = "clicks", label = "Update"),
  # textInput(inputId = "title", 
  #           label = "", 
  #           value = "Histograma de valores aleatorios que siguen una distribución normal"),
  plotOutput(outputId = "hist"),
  verbatimTextOutput(outputId = "stats")
)

server <- function(input, output){
  # renderPlot()
  # renderDataTable()
  # renderImage()
  # renderPrint()
  # renderTable()
  # renderText()
  # renderUI()
  
  # observeEvent(eventExpr = input$clicks, 
  #              handlerExpr = {
  #                print(as.numeric(input$clicks))
  #              })
  
  data <- eventReactive(input$clicks, {
    rnorm(input$num)
  })
  
  output$hist <- renderPlot({
    title <- paste0("Distribución Normal para ", input$num, " datos")
    hist(x = data(),
         main = title)
  })
  
  output$stats <- renderPrint({
    summary(data())
  })
  
}

shinyApp(ui = ui, server = server)

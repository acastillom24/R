library(shiny)

server <- function(input, output){
  # renderPlot()
  # renderDataTable()
  # renderImage()
  # renderPrint()
  # renderTable()
  # renderText()
  # renderUI()
  output$hist <- renderPlot({
    title <- paste0("Distribución Normal para ", input$num, " datos")
    hist(x = rnorm(input$num),
         main = title)
  })
}
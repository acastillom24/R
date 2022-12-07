# Packages ----
library(shiny)  # Required to run any Shiny app
library(ggplot2)  # For creating pretty plots
library(dplyr)  # For filtering and manipulating data
library(agridat)  # The package where the data comes from

# Loading data ----
Barley <- as.data.frame(beaven.barley)

# ui.R ----
ui <- fluidPage(
  titlePanel("Barley Yield"),  # Add a title panel
  sidebarLayout(  # Make the layout a sidebarLayout
    sidebarPanel(
      selectInput(inputId = "gen",  # Give the input a name "genotype"
                  label = "1. Select genotype",  # Give the input a label to be displayed in the app
                  choices = c("A" = "a","B" = "b","C" = "c","D" = "d","E" = "e","F" = "f","G" = "g","H" = "h"), 
                  selected = "a"),  # Create the choices that can be selected. e.g. Display "A" and link to value "a"
      selectInput(inputId = "colour", 
                  label = "2. Select histogram colour", 
                  choices = c("blue","green","red","purple","grey"), 
                  selected = "grey"),
      sliderInput(inputId = "bin", 
                  label = "3. Select number of histogram bins", 
                  min=1, max=25, value= c(10)),
      textInput(inputId = "text", 
                label = "4. Enter some text to be displayed", ""),
      actionButton(inputId = "action", label = "Go!"),
      radioButtons(inputId = "radio", label = "Radio Buttons", choices = c("A", "B")),
      selectInput(inputId = "select", label = "select", choices = c("A", "B")),
      sliderInput(inputId = "slider", label = "slider", value = 5, min = 1, max = 100)
    ),  # Inside the sidebarLayout, add a sidebarPanel
    mainPanel()  # Inside the sidebarLayout, add a mainPanel
    )
)

# server.R ----
server <- function(input, output) {
  output$plot <- renderPlot(ggplot(Barley, aes(x = yield)) +  # Create object called `output$plot` with a ggplot inside it
                              geom_histogram(bins = 7,  # Add a histogram to the plot
                                             fill = "grey",  # Make the fill colour grey
                                             data = Barley,  # Use data from `Barley`
                                             colour = "black")  # Outline the bins in black
  )                                                       
}

# Run the app ----
shinyApp(ui = ui, server = server)

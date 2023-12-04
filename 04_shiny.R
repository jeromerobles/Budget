# app.R

library(shiny)
library(plotly)
library(RCurl)

url<-"robles_desktop/home_shared/Jerome/"
list.files(url)
file.copy(paste(url,'!readme.txt',sep=''),tempfile())

graph_data <- 'ftp://robles_desktop'

# Define UI
ui <- fluidPage(
  titlePanel("Interactive Plotly App"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose a CSV file",
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      selectInput("x_variable", "X-axis Variable", ""),
      selectInput("y_variable", "Y-axis Variable", "")
    ),
    mainPanel(
      plotlyOutput("plot")
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  observe({
    updateSelectInput(session, "x_variable", choices = names(data()))
    updateSelectInput(session, "y_variable", choices = names(data()))
  })
  
  output$plot <- renderPlotly({
    plot_ly(data(), x = ~get(input$x_variable), y = ~get(input$y_variable), type = "scatter", mode = "markers")
  })
  
}

# Run the application
shinyApp(ui, server)


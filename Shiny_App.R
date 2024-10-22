# Load necessary libraries
library(shiny)
library(ggplot2)
library(rsconnect)

# Load the CPI data using a relative path
cpi_data <- read.csv('cpi.csv', stringsAsFactors = FALSE)

# Ensure 'period' is in date format and extract the month name
cpi_data$period <- as.Date(cpi_data$period, format = "%m/%d/%Y")
cpi_data$month.name <- months(cpi_data$period)

# Define the UI for the app
ui <- fluidPage(
  titlePanel("CPI Analysis Tool"),
  
  tabsetPanel(
    # First tab: CPI Evolution
    tabPanel("CPI Evolution", 
             selectInput("startYear", "Select Start Year", choices = unique(cpi_data$year)),
             selectInput("startMonth", "Select Start Month", choices = unique(cpi_data$month.name)),
             selectInput("endYear", "Select End Year", choices = unique(cpi_data$year)),
             selectInput("endMonth", "Select End Month", choices = unique(cpi_data$month.name)),
             actionButton("showGraph", "Show Graph"),
             plotOutput("cpiGraph")
    ),
    
    # Second tab: Dollar Value Converter
    tabPanel("Dollar Value Converter",
             selectInput("baseYear", "Select Base Year", choices = unique(cpi_data$year)),
             selectInput("baseMonth", "Select Base Month", choices = unique(cpi_data$month.name)),
             selectInput("currentYear", "Select Current Year", choices = unique(cpi_data$year)),
             selectInput("currentMonth", "Select Current Month", choices = unique(cpi_data$month.name)),
             numericInput("dollarAmount", "Enter Dollar Amount", value = 100),
             actionButton("convertValue", "Convert Value"),
             textOutput("conversionResult")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Observer for generating the CPI graph
  observeEvent(input$showGraph, {
    
    # Filter data based on selected years and months
    filtered_data <- cpi_data[
      cpi_data$year >= as.numeric(input$startYear) &
        cpi_data$year <= as.numeric(input$endYear) &
        cpi_data$month.name %in% c(input$startMonth, input$endMonth), ]
    
    # Render the CPI graph
    output$cpiGraph <- renderPlot({
      ggplot(filtered_data, aes(x = period, y = cpi)) + 
        geom_line() +
        labs(title = "CPI Evolution", x = "Period", y = "CPI") +
        theme_minimal()
    })
  })
  
  # Observer for converting the dollar value
  observeEvent(input$convertValue, {
    
    # Find CPI values for the base and current periods
    base <- cpi_data[cpi_data$year == as.numeric(input$baseYear) & cpi_data$month.name == input$baseMonth, "cpi"]
    current <- cpi_data[cpi_data$year == as.numeric(input$currentYear) & cpi_data$month.name == input$currentMonth, "cpi"]
    
    # Perform conversion and display result if both CPI values are available
    if(length(base) > 0 && length(current) > 0) {
      conversion_result <- as.numeric(current) / as.numeric(base) * input$dollarAmount
      output$conversionResult <- renderText({
        paste("$", input$dollarAmount, "in", input$baseMonth, input$baseYear, 
              "is equivalent to $", round(conversion_result, 2), 
              "in", input$currentMonth, input$currentYear)
      })
    } else {
      output$conversionResult <- renderText("Data not available for selected periods.")
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)

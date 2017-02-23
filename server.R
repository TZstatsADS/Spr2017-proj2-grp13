

library(dplyr)

shinyServer(function(input, output, session) {
  
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <- c("#3366cc", "#dc3912")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data$CONTROL)
  )
  
  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    df <- data %.%
      filter(STATE == input$state) %.%
      select(INSTNM,input$year,input$income,CONTROL,LOANRATE) %.%
    
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          "Student earnings vs student loans",
          input$year),
        series = series
      )
    )
  })
})
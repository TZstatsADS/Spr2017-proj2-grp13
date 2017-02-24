

library(dplyr)
data<-read.csv("all1.csv")
data$CONTROL <- as.factor(data$CONTROL)

shinyServer(function(input, output, session) {
  
 
  defaultColors <- c("#3366cc", "#dc3912")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data$CONTROL)
  )
  year<-input$year
  income<-input$income
  yearData <- reactive({
    df <- data %.%
      filter(STATE == input$state) %.%
      select(INSTNM,year,income,CONTROL,LOANRATE) %.%
      arrange(CONTROL)
    
  })

  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          "Student earnings vs student loans, %s",
          input$year),
        series = series
      )
    )
  })
})
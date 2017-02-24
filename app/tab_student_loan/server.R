

library(dplyr)
data<-read.csv("all1.csv")
data$CONTROL <- as.factor(data$CONTROL)

shinyServer(function(input, output, session) {
  
 
  defaultColors <- c("#3366cc", "#dc3912")
  
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data$CONTROL)
  )
 
   yearData <- reactive({
    df <- data %>%
      filter(STATE == input$state) %>%
      select(INSTNM,after6years,between30000.75000,CONTROL,LOANRATE) %>%
      arrange(CONTROL)
    
  })

  
  output$chart <- reactive({
    
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
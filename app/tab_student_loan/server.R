

library(dplyr)
data1<-read.csv("all1.csv")
data1$CONTROL <- as.factor(data1$CONTROL)

shinyServer(function(input, output, session) {
  
 
  defaultColors <- c("#3366cc", "#dc3912")
  
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data1$CONTROL)
  )
 
   yearData <- reactive({
    df <- data1 %>%
      filter(STATE == input$state) %>%
      select(INSTNM,between30000.75000,after6years,CONTROL,LOANRATE) %>%
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
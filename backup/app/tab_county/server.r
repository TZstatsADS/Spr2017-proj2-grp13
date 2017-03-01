# server.R

library(maps)
library(mapproj)
counties <- read.csv("orgi.csv")
source("helpers.R")


shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      args <- switch(input$var,
                     "Student_Married%" = list(counties$married, "darkgreen", "Student_Married%"),
                     "Student_Depedent%" = list(counties$dependent, "black", "Student_Depedent%"),
                     "Student_Veteran%" = list(counties$veteran, "darkorange", "Student_Veteran%"),
                     "Student_First_Generation%" = list(counties$first.generation, "darkviolet", "Student_First_Generation%"))
      
      args$min <- input$range[1]
      args$max <- input$range[2]
      
      do.call(percent_map, args)
    })
  }
)

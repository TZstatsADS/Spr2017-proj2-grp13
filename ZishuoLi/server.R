library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
allzips <- readRDS("data/superzip.rds")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$college <- allzips$college * 100
allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
row.names(allzips) <- allzips$zipcode
zipdata <- allzips[sample.int(nrow(allzips), 10000),]
zipdata <- zipdata[order(zipdata$centile),]

collegedata <- read.csv("clean3.csv")
colnames(collegedata)[4:5] <- c("latitude","longitude")
class(collegedata$COSTT4_A) <- "numeric"
#filter(collegedata,COSTT4_A<20000,Rank>100)
#

function(input, output, session) {

  
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    tuition <- as.numeric(input$tuition)
    Rank2 <- as.numeric(input$Rank)
     
    data<- filter(collegedata,COSTT4_A<tuition&&Rank<Rank2)
    radius1 <- data$COSTT4_A/100
    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000

  output$map <- renderLeaflet({
    
    leaflet(data=zipdata) %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=radius, layerId=~zipcode,
                 stroke=FALSE, fillOpacity=0.4, fillColor="red")
    })

  
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      content <- as.character(tagList(
        tags$h4("Score:"),
        tags$strong(HTML(sprintf("s, s s"
        ))), tags$br(),
        sprintf("Median household income: "), tags$br(),
        sprintf("Percent of adults with BA: "), tags$br(),
        sprintf("Adult population: ")
      ))
      leafletProxy("map") %>% addPopups(lng=event$lng, lat=event$lat, content, layerId = event$id)
    })
  })
  
  
  ## Data Explorer ###########################################
}


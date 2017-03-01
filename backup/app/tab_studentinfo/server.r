library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

function(input, output, session) {

  
  ## 第二个tab第二个tab第二个tab第二个tab ###########################################

    #plot
    output$plot <- renderPlot({
      library(fmsb)
      #   input$satmath,input$satessay,input$satreading,input$actscore,input$moneywillingness,input$gpascore,input$studentrank
      data=data.frame(input$satmath/8,input$satessay/8*100,input$satreading/8,input$actscore/35*100,input$moneywillingness/500,input$gpascore/4*100,input$studentrank)
      colnames(data)=c("SAT math" , "SAT essay" , "SAT reading", "ACT" , "Financials", "GPA" ,"Rank" )
      data=rbind(rep(100,7) , rep(0,7) , data)
      # default       radarchart(data)
      radarchart( data  , axistype=1 , 
                  #custom polygon
                  pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
                  #custom the grid
                  cglcol="grey", cglty=1, axislabcol="grey", cglwd=0.8,
                  #custom labels
                  vlcex=0.8 
      )
    })
  
  output$ziptable <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        Score >= input$minScore,
        Score <= input$maxScore
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)

    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
  
  
}


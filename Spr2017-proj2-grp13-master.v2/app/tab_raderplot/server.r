#server for the university radar plot 
#task for tonight kh2793


library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

function(input, output, session) {

  
  ################################

    #plot
    output$plot <- renderPlot({
      library(fmsb)
      name=input$school
      
      transpose<-read.csv("transpose.csv")
      data=data.frame(as.numeric(as.character(transpose[7,name]))*100, (300-as.numeric(as.character(transpose[32,name])))/3, as.numeric(as.character(transpose[31,name]))/500,
                      as.numeric(as.character(transpose[26,name]))/36*100, as.numeric(as.character(transpose[27,name]))/36*100,
                      as.numeric(as.character(transpose[28,name]))/36*100, as.numeric(as.character(transpose[29,name]))/16)
      
      colnames(data)=c("admission rate" , "rank" , "Tuition", "ACT English" , "ACT Math", "ACT Writing" ,"SAT" )
      data=rbind(rep(100,7) , rep(0,7) , data)
      #radarchart(data)
      radarchart( data  , axistype=1 , 
                  #custom polygon
                  pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
                  #custom the grid
                  cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,20), cglwd=0.8,
                  #custom labels
                  vlcex=0.8 
      )
    })
  
}



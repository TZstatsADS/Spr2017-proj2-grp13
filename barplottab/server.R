
setwd('C:/Users/sy2674/Downloads/Spr2017-proj2-grp13-master/barplottab')
library(ggplot2)
data1=read.csv('CleanDataFinal.csv', na.strings = "NULL")
data1[is.na(data1)]=0
data1[,10:18][data1[,10:18]<=200]=NA
function(input, output) {
  
  # Fill in the spot we created for a plot
  data=data1[order(data1[,'Rank']),]
  
  ylim1=reactive({max(data[,input$var])})
                output$bPlot <- renderPlot({
                  # Render a barplot
                  ggplot(data=data[c(input$rank:(input$rank+10)),], aes(x=data[c(input$rank:(input$rank+10)),][,'College.Name'], y=data[c(input$rank:(input$rank+10)),][,input$var],fill=data[c(input$rank:(input$rank+10)),][,input$var]))+
                    geom_bar(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$var)+scale_fill_gradient(low="white", high="blue",limit=(c(0,1)))+ylim(0, ylim1())+labs(fill=input$var)+xlab('College Name')
                })
                output$sPlot <- renderPlot({
                  # Render a barplot
                  InverseRank=1/data[,'Rank']
                  Rank=data[,'Rank']
                  ggplot(data=data, aes(x=data[,input$x], y=data[,input$y],size=InverseRank,colour=Rank))+
                    geom_point()  + theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$var)+scale_colour_gradient(low="blue", high="black",limit=(c(0,200)))+labs(fill='Rank')+xlab(input$x)+ylab(input$y)
                })

}

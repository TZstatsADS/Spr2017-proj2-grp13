
setwd('C:/Users/sy2674/Downloads/Spr2017-proj2-grp13-master/barplottab')
library(ggplot2)
data1=read.csv('CleanDataFinal.csv', na.strings = "NULL")
data1[is.na(data1)]=0
data1[,c(10:18,31)][data1[,c(10:18,31)]<=200]=NA
function(input, output) {
  best.valued=reactive({as.character(data1$College.Name[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))])})
  # Fill in the spot we created for a plot
  data=data1[order(data1[,'Rank']),]
  model=reactive({lm(data[,input$y]~data[,input$x])})
  InverseRank=1/data[,'Rank']
  Rank=data[,'Rank']
  ylim1=reactive({max(data[,input$var])})
  ylim2=reactive({min(data[,input$var])})
  observeEvent(input$go, {
 if(input$x!=input$y){
    bool=rep(0,length(data1$College.Name))
    bool[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))]=1
    data$bool=bool
    output$sPlot <- renderPlot({
      # Render a barplot
      
      ggplot(data=data, aes(x=data[,input$x], y=data[,input$y],size=factor(bool),fill=factor(bool),colour=factor(bool)))+
        geom_point()  + theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$y)+labs(fill='best value')+xlab(input$x)+ylab(input$y)

    })
    output$text1 <- renderText({ 
      paste(best.valued(), sep=",", collapse=",")
    })
 }
  })
  observeEvent(input$x, {
    
    bool=rep(0,length(data1$College.Name))
    bool[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))]=1
    data$bool=bool
    output$sPlot <- renderPlot({
      # Render a barplot
      
      
      ggplot(data=data, aes(x=data[,input$x], y=data[,input$y],size=InverseRank,colour=Rank))+
        geom_point()  + theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$y)+scale_colour_gradient(low="blue", high="black",limit=(c(0,200)))+labs(fill='Rank')+xlab(input$x)+ylab(input$y)
    })
    output$text1 <- renderText({ 
      ''
    })
  })
  observeEvent(input$y, {
    
    bool=rep(0,length(data1$College.Name))
    bool[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))]=1
    data$bool=bool
    output$sPlot <- renderPlot({
      # Render a barplot
      
      
      ggplot(data=data, aes(x=data[,input$x], y=data[,input$y],size=InverseRank,colour=Rank))+
        geom_point()  + theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$y)+scale_colour_gradient(low="blue", high="black",limit=(c(0,200)))+labs(fill='Rank')+xlab(input$x)+ylab(input$y)
    })
    output$text1 <- renderText({ 
      ''
    })
  })
                output$bPlot <- renderPlot({
                  # Render a barplot
                  ggplot(data=data[c(input$rank:(input$rank+10)),], aes(x=data[c(input$rank:(input$rank+10)),][,'College.Name'], y=data[c(input$rank:(input$rank+10)),][,input$var],fill=data[c(input$rank:(input$rank+10)),][,input$var]))+
                    geom_bar(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$var)+scale_fill_gradient(low="white", high="blue",limit=(c(ylim2(), ylim1())))+ylim(0, ylim1())+labs(fill=input$var)+xlab('College Name')
                })
                output$sPlot <- renderPlot({
                  # Render a barplot

                  ggplot(data=data, aes(x=data[,input$x], y=data[,input$y],size=InverseRank,colour=Rank))+
                    geom_point()  + theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$y)+scale_colour_gradient(low="blue", high="black",limit=(c(0,200)))+labs(fill='Rank')+xlab(input$x)+ylab(input$y)
                })
                output$text1 <- renderText({ 
                   ''
                })
                


}

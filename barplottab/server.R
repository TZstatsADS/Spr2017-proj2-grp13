
setwd('C:/Users/sy2674/Downloads/Spr2017-proj2-grp13-master/barplottab')
library(ggplot2)
data1=read.csv('CleanDataFinal.csv', na.strings = "NULL")
data1[is.na(data1)]=0
data1[,c(10:18,31)][data1[,c(10:18,31)]<=200]=NA
function(input, output) {
  best.valued=reactive({as.character(data$College.Name[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))])})
  # Fill in the spot we created for a plot
  
  data=data1[order(data1[,'Rank']),]
  data2=data
  data2[is.na(data2)]=-999
  model=reactive({lm(data[,input$y]~data[,input$x])})
  InverseRank=1/data[,'Rank']
  Rank=data[,'Rank']
  ylim1=reactive({max(data[,input$var])})
  ylim2=reactive({min(data[,input$var])})
  x=reactive({input$ho$x})
  y=reactive({input$ho$y})
  data$all25=data$SATVR25+data$SATMT25
  data$all50=data$SATVRMID+data$SATMTMID
  data$all75=data$SATVR75+data$SATMT75
  diff=reactive({abs(data$SAT_AVG-ave())})
  df=reactive({data[order(diff(),decreasing=F),][1:10,]})
  ave=reactive({input$vr+input$mt})
  act=reactive({input$act})
  diff2=reactive({abs(data$ACTCMMID-aCT())})
  df2=reactive({data[order(diff2(),decreasing=F),][1:10,]})
  score=function(x,y,x1,y1){return((x-x1)^2+(y-y1)^2)}
  name=reactive({as.character(data2$College.Name)[which.min(score(x(),y(),data2[,input$x],data2[,input$y]))]})
  observeEvent(input$go, {
 if(input$x!=input$y){
    bool=rep(0,length(data$College.Name))
    bool[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))]=1
    data$bool=bool

    output$sPlot <- renderPlot({
      # Render a barplot
      
      ggplot(data=data, aes(x=data[,input$x], y=data[,input$y],size=factor(bool),fill=factor(bool),colour=factor(bool)))+
        geom_point()  + theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$y)+labs(fill='best value')+xlab(input$x)+ylab(input$y)
    
    })

    output$text1 <- renderText({ 
      paste(best.valued(), sep=",", collapse="")
    })
 }
  })
  observeEvent(input$x, {
    
    bool=rep(0,length(data$College.Name))
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
    
    bool=rep(0,length(data$College.Name))
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
  observeEvent(input$mt, {
    ave=reactive({input$vr+input$mt})
    data$all25=data$SATVR25+data$SATMT25
    data$all50=data$SATVRMID+data$SATMTMID
    data$all75=data$SATVR75+data$SATMT75
    diff=reactive({abs(data$SAT_AVG-ave())})
    df=reactive({data[order(diff()),][1:10,]})
    output$cPlot <- renderPlot({
      # Render a barplot
      ggplot(data=df(), aes(x=factor(College.Name),ymin=400,ymax=1600,lower=all25,middle=all50,upper=all75))+
        geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('SAT')+scale_fill_gradient(low="white", high="blue",limit=(c(400, 1600)))+ylim(400,1600)+labs(fill='SAT')+xlab('College Name')+
        geom_hline(yintercept=ave())
      
    })})
  observeEvent(input$vr, {
    ave=reactive({input$vr+input$mt})
    data$all25=data$SATVR25+data$SATMT25
    data$all50=data$SATVRMID+data$SATMTMID
    data$all75=data$SATVR75+data$SATMT75
    diff=reactive({abs(data$SAT_AVG-ave())})
    df=reactive({data[order(diff()),][1:10,]})
    output$cPlot <- renderPlot({
      # Render a barplot
      ggplot(data=df(), aes(x=factor(College.Name),ymin=400,ymax=1600,lower=all25,middle=all50,upper=all75))+
        geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('SAT')+scale_fill_gradient(low="white", high="blue",limit=(c(400, 1600)))+ylim(400,1600)+labs(fill='SAT')+xlab('College Name')+
        geom_hline(yintercept=ave())
      
    })})
  observeEvent(input$act, {
    act=reactive({input$act})
    diff2=reactive({abs(data$ACTCMMID-act())})
    df2=reactive({data[order(diff2(),decreasing=F),][1:10,]})
    output$DPlot <- renderPlot({
      # Render a barplot
      ggplot(data=df2(), aes(x=factor(College.Name),ymin=0,ymax=32,lower=ACTCM25,middle=ACTCMMID,upper=ACTCM75))+
        geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('SAT')+scale_fill_gradient(low="white", high="blue",limit=(c(0, 32)))+ylim(0,32)+labs(fill='ACT')+xlab('College Name')+
        geom_hline(yintercept=act())
      
    })})
  observeEvent(input$pc$x, {
roll=as.vector(data[data$College.Name==input$pc$x,])
output$intro <- renderText({
  paste(roll[1:6], sep=",", collapse="\n")
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
                output$info <- renderText({
                  name()
                })
                
                output$cPlot <- renderPlot({
                  # Render a barplot
                  ggplot(data=df(), aes(x=factor(College.Name),ymin=400,ymax=600,lower=all25,middle=all50,upper=all75))+
                    geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('SAT')+scale_fill_gradient(low="white", high="blue",limit=(c(400, 1600)))+ylim(400,1600)+labs(fill='SAT')+xlab('College Name')+
                    geom_hline(yintercept=ave())
                  
                })
                output$DPlot <- renderPlot({
                  # Render a barplot
                  ggplot(data=df2(), aes(x=factor(College.Name),ymin=0,ymax=32,lower=ACTCM25,middle=ACTCMMID,upper=ACTCM75))+
                    geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('SAT')+scale_fill_gradient(low="white", high="blue",limit=(c(0, 32)))+ylim(0,32)+labs(fill='SAT')+xlab('College Name')+
                    geom_hline(yintercept=act())
                  
                })
                output$intro <- renderText({
                    ''
                })

}

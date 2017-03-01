library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)

collegedata <- read.csv("clean4.csv")
colnames(collegedata)[c(which(colnames(collegedata)=="LATITUDE"):which(colnames(collegedata)=="LONGITUDE"))] <- c("latitude","longitude")
collegedata$COSTT4_A <- as.numeric(paste(collegedata$COSTT4_A))
collegedata$Rank <- as.numeric(paste(collegedata$Rank))
collegedata$UGDS_MEN <- as.numeric(paste(collegedata$UGDS_MEN))
collegedata$UGDS_WOMEN <- as.numeric(paste(collegedata$UGDS_WOMEN))
collegedata$SAT_AVG <- as.numeric(paste(collegedata$SAT_AVG))
collegedata$ADM_RATE <- as.numeric(paste(collegedata$ADM_RATE))
collegedata$ACTCMMID <- as.numeric(paste(collegedata$ACTCMMID))
#å¯ä»¥ç¨ï¼ï¼ï¼

data1<-read.csv('CleanDataFinal.csv', na.strings = "NULL")
data1[is.na(data1)]=0
data1[,c(10:18,31)][data1[,c(10:18,31)]<=200]=NA

function(input, output, session) {

  observe({
    usedcolor <- "red"
    
    tuition <- as.numeric(input$tuition)
    liRank <- as.numeric(input$liRank)
    SAT <- as.numeric(input$SAT) 
    adm <- as.numeric(input$adm)
    ACT <- as.numeric(input$ACT)
    lidata<- filter(collegedata,COSTT4_A<tuition,Rank<liRank,SAT_AVG<SAT,ADM_RATE<adm,ACTCMMID<ACT)
    radius1 <-lidata$Arrest*100
    opacity <- 0.8
    
    if(input$color=="liRank"){
      usedcolor <- "green"
      radius1 <- lidata$COSTT4_A
      opacity <- 0.4
    }else if(input$color=="population"){
      usedcolor<- ifelse(input$sex=="men","blue","red") 
      radius1 <- ifelse(input$sex=="men",lidata$UGDS_MEN*100000,lidata$UGDS_WOMEN*100000)
      opacity <- 0.6
    }else if(input$color=="ttpopulation"){
      usedcolor <- "blueviolet"
      radius1 <- lidata$UGDS*2
      opacity <- 0.5
    }
    
    
    
    output$map <- renderLeaflet({
      
      leaflet(data=lidata) %>%
        addTiles(
          urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
        ) %>%setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
        clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=radius1, layerId=~UNITID,
                   stroke=FALSE, fillOpacity=opacity, fillColor=usedcolor)
    })
    
    
    showZipcodePopup <- function(x, lat, lng) {
      lidata <- lidata[lidata$UNITID == x,]
      content <- as.character(tagList(
        tags$h4("University:",lidata$INSTNM),
        tags$strong(HTML(sprintf("information"
        ))), tags$br(),
        sprintf("Rank:%s",lidata$Rank), tags$br(),
        sprintf("State: %s   City: %s",lidata$STABBR,lidata$CITY),tags$br(),
        sprintf("Cost :%s  (four years)",lidata$CO), tags$br(),
        sprintf("Url: %s ",lidata$INSTURL),tags$br(),
        sprintf("Arrested in 2016: %s",lidata$Arrest)
      ))
      leafletProxy("map") %>% addPopups(lng, lat, content, layerId =x)
    }
    
    
    
    observe({
      leafletProxy("map") %>% clearPopups()
      event <- input$map_shape_click
      if (is.null(event))
        return()
      
      
      
      isolate({
        showZipcodePopup(event$id, event$lat, event$lng)
      })
    })
    
    
  })
  #####
  ## 
  #### ###########################################
  output$plot <- renderPlot({
    library(fmsb)
    name=input$school
    
    transpose<-read.csv("transpose.csv")
    datahh=data.frame(as.numeric(as.character(transpose[7,name]))*100, (300-as.numeric(as.character(transpose[32,name])))/3, as.numeric(as.character(transpose[31,name]))/500,
                    as.numeric(as.character(transpose[26,name]))/36*100, as.numeric(as.character(transpose[27,name]))/36*100,
                    as.numeric(as.character(transpose[28,name]))/36*100, as.numeric(as.character(transpose[29,name]))/16)
    
    colnames(datahh)=c("admission rate" , "rank" , "Tuition", "ACT English" , "ACT Math", "ACT Writing" ,"SAT" )
    datahh=rbind(rep(100,7) , rep(0,7) , datahh)
    #radarchart(data)
    radarchart( datahh  , axistype=1 , 
                #custom polygon
                pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
                #custom the grid
                cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,20), cglwd=0.8,
                #custom labels
                vlcex=0.8 
    )
  })
  
  ## Data Explorer ###########################################
  library(maps)
  library(mapproj)
  counties <- read.csv("orgi.csv")
  source("helpers.R")
  output$mapplot <- renderPlot({
    args <- switch(input$hkvar,
                   "Student_Married%" = list(counties$married, "darkgreen", "Student_Married%"),
                   "Student_Depedent%" = list(counties$dependent, "black", "Student_Depedent%"),
                   "Student_Veteran%" = list(counties$veteran, "darkorange", "Student_Veteran%"),
                   "Student_First_Generation%" = list(counties$first.generation, "darkviolet", "Student_First_Generation%"))

    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map, args)
  })
  ####################
  output$raderplot <- renderPlot({
    library(fmsb)
    #   input$satmath,input$satessay,input$satreading,input$actscore,input$moneywillingness,input$gpascore,input$studentrank
    hhdata=data.frame(input$satmath/8,input$satessay/8*100,input$satreading/8,input$actscore/35*100,input$moneywillingness/800,input$gpascore/4*100,input$studentrank)
    colnames(hhdata)=c("SAT math" , "SAT essay" , "SAT reading", "ACT" , "Financials", "GPA" ,"Rank" )
    hhdata=rbind(rep(100,7) , rep(0,7) , hhdata)
    # default       radarchart(data)
    radarchart( hhdata  , axistype=1 , 
                #custom polygon
                pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
                #custom the grid
                cglcol="grey", cglty=1, axislabcol="grey", cglwd=0.8,
                #custom labels
                vlcex=0.8 
    )
  })
  
  #####
  ####
  ####
  best.valued=reactive({as.character(data$College[as.numeric(names(sort(model()$residuals,decreasing = T)[1:5]))])})
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
  diff2=reactive({abs(data$ACTCMMID-act())})
  df2=reactive({data[order(diff2(),decreasing=F),][1:10,]})
  score=function(x,y,x1,y1){return((x-x1)^2+(y-y1)^2)}
  name=reactive({as.character(data2$College)[which.min(score(x(),y(),data2[,input$x],data2[,input$y]))]})
  observeEvent(input$go, {
    if(input$x!=input$y){
      bool=rep(0,length(data$College))
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
        geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('ACT')+scale_fill_gradient(low="white", high="blue",limit=(c(0, 32)))+ylim(0,32)+labs(fill='ACT')+xlab('College Name')+
        geom_hline(yintercept=act())
      
    })})
  observeEvent(input$pc$x, {
    f=as.factor(as.character(df2()$College.Name))
    lvls <- levels(f)
    nn <- lvls[round(input$pc$x)]
    roll=data[data$College.Name==nn,]
    aroll=apply(roll[,2:6],2,as.character)
    output$intro <- renderText({
      paste(aroll, sep=",", collapse="\n")
    })
    
  }) 
  observeEvent(input$pc2$x, {
    f=as.factor(as.character(df()$College.Name))
    lvls <- levels(f)
    nn <- lvls[round(input$pc2$x)]
    roll=data[data$College.Name==nn,]
    aroll=apply(roll[,2:6],2,as.character)
    output$intro <- renderText({
      paste(aroll, sep=",", collapse="\n")
    })
    
  })  
  
  output$bPlot <- renderPlot({
    # Render a barplot
    ggplot(data=data[c(input$rank:(input$rank+10)),], aes(x=data[c(input$rank:(input$rank+10)),][,"College Name"], y=data[c(input$rank:(input$rank+10)),][,input$var],fill=data[c(input$rank:(input$rank+10)),][,input$var]))+
      geom_bar(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab(input$var)+scale_fill_gradient(low="white", high="blue",limit=(c(ylim2(), ylim1())))+ylim(0, ylim1())+labs(fill=input$var)+xlab("College Name")
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
      geom_boxplot(stat="identity")+ theme(axis.text.x=element_text(angle = -90, hjust = 0))+ylab('ACT')+scale_fill_gradient(low="white", high="blue",limit=(c(0, 32)))+ylim(0,32)+labs(fill='SAT')+xlab('College Name')+
      geom_hline(yintercept=act())
    
  })
  output$intro <- renderText({
    ''
  })
  
  
}

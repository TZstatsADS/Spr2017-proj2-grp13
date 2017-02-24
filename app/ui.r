library(leaflet)
transpose<-read.csv("transpose.csv")
data1<-read.csv('CleanDataFinal.csv', na.strings = "NULL")
data1[is.na(data1)]=0
data1[,c(10:18,31)][data1[,c(10:18,31)]<=200]=NA
data=data1[order(data1[,'Rank']),]
data2=data
data2[is.na(data2)]=-999
# Choices for drop-downs
livars <- c(
  "Tuition" = "liRank",
  "Arrest" = "violence",
  "population ratio"="population",
  "population"="ttpopulation"
)
livar <- c("men"="men","women"="women")

navbarPage("College", id="nav",
           tabPanel("College information map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = 20, right = "auto", bottom = "auto",
                                      width = 300, height = "auto",
                                      
                                      h2("College"),
                                      
                                      sliderInput("liRank","Rank",min = 1,max = 300,value = 300),
                                      sliderInput("tuition","tuition",min = 6000,max=80000,value =80000),
                                      sliderInput("SAT","SAT",min = 900,max=1600,value =1600),
                                      sliderInput("ACT","ACT",min = 12,max=36,value =36),
                                      sliderInput("adm","admission rate",min = 0,max=1,value =1),
                                      selectInput("color", "color", livars),
                                      conditionalPanel("input.color == 'population'",
                                                       selectInput("sex", "sex", livar)
                                      )
                                      
                        ),
                        
                        tags$div(id="cite",
                                 'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
                        )
                    )
           ),
           
###############tab university information on county level summary############
   tabPanel("University Information County Summary",
         fluidRow(
           column(12,
                  h5("Create univerisity summarization graphic with information from the 2015 data.gov."),
                  selectInput("hkvar", 
                              label = "Choose a variable to display",
                              choices = c("Student_Married%", "Student_Depedent%",
                                          "Student_Veteran%", "Student_First_Generation%"),
                              selected = "Student Enrolled"),
                  sliderInput("range", label = "Range of interest:",
                              min = 0, max = 100, value = c(0, 100))
                  
           ),
         
         hr(),
         
         fluidRow(column(6, plotOutput('mapplot', height = 500)))
         )
   ),


###################tab student information analytics####################

tabPanel("Student Information",
         fluidRow(
           column(12,
                  h5("Hi, could you tell me a little bit about yourself? 
                     Then we would be able to provide some analysis and related information about college for you.")
                  ),
           column(4,sliderInput("satessay",label = h5("SAT Essay Score"),min=2,max=8,value=6)
           ),
           column(4,sliderInput("satreading",label = h5("SAT Reading Score"),min=200,max=800,value=500)
           ),
           column(4,sliderInput("satmath",label = h5("SAT Math Score"),min=200,max=800,value=500)
           ),
           column(4,sliderInput("actscore",label = h5("ACT Score"),min=20,max=35,value=10)
                  
           ),
           column(4,sliderInput("gpascore",label = h5("GPA Score"),min=0,max=4,value=3)
           ),
           column(4,sliderInput("studentrank",label = h5("Rank %"),min=1,max=100,value=50)
           ),
           column(4,
                  sliderInput("moneywillingness",label = h5("Money paid by year"),min=1000,max=80000,value=30000)
           )
           ),
         
         
         
         hr(),
         
         fluidRow(
           column(6, plotOutput('raderplot', height = 500))
         ),
         fluidRow(
           p(class = 'text-center', downloadButton('x3', 'Download Filtered Data'))
         )
),
tabPanel( 'Best Value University'  ,   fluidRow(
  
  column(3,sliderInput("krank", label = h3("School Rank"), min = 0, 
                       max = 100, value = 50),
         hr(),
         selectInput("kvar", "Varibles", 
                     choices=names(data1)[c(9:33)]),
         hr(),
         hr(),
         hr(),
         hr(),
         hr(),
         hr(),
         hr(),
         
         selectInput("x", "x axis", 
                     choices=names(data1)[c(9:33)]),
         
         selectInput("y", "y axis", 
                     choices=names(data1)[c(9:33)])),
  column(7, plotOutput("sPlot", hover = "ho"),  actionButton("go", "Find the best valued University"),
                                                            verbatimTextOutput("info"),
                                                            textOutput("text1")))),

#####################school Recomendation##################
tabPanel('School recommendation',  fluidRow(
  
  column(2,sliderInput("vr", label = "Sat verbal", min = 200, 
                       max = 800, value = 500,step=10),
         hr(),
         sliderInput("mt", label = "Sat math", min = 200, 
                     max = 800, value = 500,step=10),
         hr(),
         sliderInput("wr", label = "Sat writing", min = 200, 
                     max = 800, value = 500,step=10),
         sliderInput("act", label = "ACT", min = 1, 
                     max = 32, value = 20),
         sliderInput("gpa", label = "GPA", min = 0.0, 
                     max = 5.0, value = 3.0, step= 0.1),
         hr(),
         
         
         

         selectInput("major", "Any thought about major?", 
                     choices=c('Undecided','Math & Nautural Science','Social Science','Econ, Accounting and Business','Engineering'))
         ),column(7,plotOutput('cPlot',click = "pc2"),plotOutput('DPlot',click = "pc")),column(2,verbatimTextOutput("intro"))))

,
  conditionalPanel("false", icon("crosshair"))

)

library(leaflet)
transpose<-read.csv("transpose.csv")

# Choices for drop-downs
vars <- c(
  "Rank" = "Rank",
  "violence" = "violence",
  "population ratio"="population"
)
var <- c("men"="men","women"="women")

navbarPage("Superzip", id="nav",
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
                                      
                                      sliderInput("Rank","Rank",min = 1,max = 300,value = 300),
                                      sliderInput("tuition","tuition",min = 6000,max=80000,value =80000),
                                      sliderInput("SAT","SAT",min = 900,max=1600,value =1600),
                                      sliderInput("ACT","ACT",min = 12,max=36,value =36),
                                      sliderInput("adm","admission rate",min = 0,max=1,value =1),
                                      selectInput("color", "color", vars),
                                      conditionalPanel("input.color == 'population'",
                                                       selectInput("sex", "sex", var)
                                      )
                                      
                        ),
                        
                        tags$div(id="cite",
                                 'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
                        )
                    )
           ),
           
###########################
   tabPanel("University Information Conty Summary",
         fluidRow(
           column(12,
                  h5("Create univerisity summarization graphic with information from the 2015 data.gov."),
                  selectInput("var", 
                              label = "Choose a variable to display",
                              choices = c("Student_Married%", "Student_Depedent%",
                                          "Student_Veteran%", "Student_First_Generation%"),
                              selected = "Student Enrolled"),
                  helpText("# student displayed here is adjusted"),
                  sliderInput("range", 
                              label = "Range of interest:",
                              min = 0, max = 100, value = c(0, 100))
           ),
         
         hr(),
         
         fluidRow(column(6, plotOutput('mapplot', height = 500)))
         )
   ),


#######################################

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
                  radioButtons("nearby",label = h5("Do you want to study near school?"),choices = list("Yes"=1,"No"=2))
           ),
           column(4,
                  textInput("postalcode",label = h5("Postal code"),value = "Only 5 digit number...")
           ),
           column(4,
                  sliderInput("moneywillingness",label = h5("Money paid by year"),min=1000,max=50000,value=30000)
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
  conditionalPanel("false", icon("crosshair"))

)

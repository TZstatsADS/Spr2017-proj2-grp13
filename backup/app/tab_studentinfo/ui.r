library(leaflet)

# Choices for drop-downs
vars <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)


navbarPage("Superzip", id="nav",

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
      column(6, plotOutput('plot', height = 500)),
      column(6, DT::dataTableOutput("ziptable"))
    ),
    fluidRow(
      p(class = 'text-center', downloadButton('x3', 'Download Filtered Data'))
    )
  ),

  conditionalPanel("false", icon("crosshair"))
)

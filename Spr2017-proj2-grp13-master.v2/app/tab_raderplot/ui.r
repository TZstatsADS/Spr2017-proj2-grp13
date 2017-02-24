# task for tonight~
# kh2793 



library(leaflet)
data<-read.csv("Clean Data Final.csv")

# using the transposed data to make it easy for plotting
transpose<-read.csv("transpose.csv")


navbarPage("Superzip", id="nav",

  tabPanel("University Information Radar Plot",
    fluidRow(
      column(12,
             h5("You can select a school from the list, 
                and we could tell you the basci characteristics of it. ")
      ),
      column(4,
        selectInput("school",label = h5("University"),names(transpose))
      )
    ),
  
    hr(),
    
    fluidRow(
      column(6, plotOutput('plot', height = 500))
    )
  ),

  conditionalPanel("false", icon("crosshair"))
)

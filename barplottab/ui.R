fluidPage(
  
    
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        sliderInput("rank", label = h3("School Rank"), min = 0, 
                    max = 100, value = 50),
        hr(),
        selectInput("var", "Varibles", 
                    choices=names(data1)[c(9:33)])
      ),
  
           
           # Copy the line below to make a slider bar 
           

    mainPanel(
      plotOutput("bPlot")  
    )
  

)
)
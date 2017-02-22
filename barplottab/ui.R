fluidPage(
      
      # Define the sidebar with one input

           
           # Copy the line below to make a slider bar 
           

  mainPanel(
    tabsetPanel(

    tabPanel( 'tab1'  ,   fluidRow(
      
      column(3,sliderInput("rank", label = h3("School Rank"), min = 0, 
                                 max = 100, value = 50),
                     hr(),
                     selectInput("var", "Varibles", 
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
                                 choices=names(data1)[c(9:33)])),column(8,plotOutput("bPlot"), plotOutput("sPlot", hover = "ho"),      actionButton("go", "Find the best valued University"),
                                                                       verbatimTextOutput("info"),
                                                                       textOutput("text1")))),
    
    
    tabPanel('tab2',  fluidRow(
      
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
             
             
             selectInput("Home", "Do you want to go to college near your home?", 
                         choices=c('Yes','No')),
             textInput("zip", "If Yes please enter your zipcode"),
             selectInput("major", "Any thouught about major?", 
                         choices=c('Undecided','Math & Nautural Science','Social Science','Econ, Accounting and Business','Engineering'))),column(7,plotOutput('cPlot'),plotOutput('DPlot',click = "pc")),column(2,verbatimTextOutput("intro"))))
    
      )
    )
  


)

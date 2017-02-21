shinyUI(fluidPage(
  titlePanel("University Information Conty Summary"),
  
  sidebarLayout(
    sidebarPanel(
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
    
    mainPanel(plotOutput("map"))
  )
))

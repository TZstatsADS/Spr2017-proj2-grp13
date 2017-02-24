library(googleCharts)
data<-read.csv("all1.csv")
data$CONTROL <- as.factor(data$CONTROL)
# Use global max/min for axes so the view window stays
# constant as the user moves between years
xlim <- list(
  min = min(na.omit(data$lessthan30000)) - 500,
  max = max(na.omit(data$morethan75000)) + 500
)
ylim <- list(
  min = min(na.omit(data$after6years)),
  max = max(na.omit(data$after10years)) + 500
)

shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
     ),
  
  h2("Student loans and earnings info"),
  
  googleBubbleChart("chart",
                    width="100%", height = "475px",
                
                    options = list(
                      fontName = "Source Sans Pro",
                      fontSize = 13,
                      # Set axis labels and ranges
                      hAxis = list(
                        title = "Median amount of debt($)",
                        viewWindow = xlim
                      ),
                      vAxis = list(
                        title = "Mean amount of earnings($)",
                        viewWindow = ylim
                      ),
                      # The default padding is a little too spaced out
                      chartArea = list(
                        top = 50, left = 75,
                        height = "75%", width = "75%"
                      ),
                      # Allow pan/zoom
                      explorer = list(),
                      # Set bubble visual props
                      bubble = list(
                        opacity = 0.4, stroke = "none",
                        # Hide bubble label
                        textStyle = list(
                          color = "none"
                        )
                      ),
                      # Set fonts
                      titleTextStyle = list(
                        fontSize = 16
                      ),
                      tooltip = list(
                        textStyle = list(
                          fontSize = 12
                        )
                      )
                    )
  ),
  fluidRow(
    shiny::column(4, offset = 4,
              
                  selectInput('year', 'Number of years after entering the industry', names(data[,2:6])),
                  selectInput('income', 'Student Family Income',names(data[,10:12]) )),
                   selectInput('state', 'State',data$STATE ))
))


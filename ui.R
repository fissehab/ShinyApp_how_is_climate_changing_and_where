library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title = 'By Fisseha Berhane'),
  
  dashboardSidebar(width = 100
                  
              
  ),
  
  
  dashboardBody( 
    
    
    tags$h3('How is climate changing and where with',span('R',style="color:blue;font-size:140%"),style="text-align:center;color:#b30000;font-size:200%"),
    br(),
    fluidRow(
      
      column(width = 7,
             
      plotOutput("distPlot",dblclick='plot_dblclick', click = "plot_click")
      
      ),
      
      column(width = 5,
             
             plotOutput('dbclick'))
      )
    
  

))




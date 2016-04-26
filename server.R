library(ggplot2)
library(ggmap)
library(maptools)
library(maps)
library(shiny)
library(lubridate)



load("data/cru_1901_2013_tmp_coarser")


shinyServer(function(input, output) {
  

  
  output$distPlot <- renderPlot({
    mapWorld <- borders("world", colour="gray50", fill="#cce6ff") # create a layer of borders
    p=ggplot() +   mapWorld
    p=p+ggtitle("Double click over any land part to see \n the temperature trend since 1901")+
      theme(axis.text.y   = element_blank(),
            line = element_blank(),
            axis.text.x   = element_blank(),
            axis.title.y  = element_blank(),
            axis.title.x  = element_blank(),
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            plot.title = element_text(vjust=1.5,size = 18,colour="#663300"),
            panel.border = element_rect(colour = "gray70", fill=NA, size=1))

      
    p
    
  })
  

  
  double_clicked <- reactiveValues(
    
    center = NULL 
  )
  
  # Handle dounle clicks on the plot
  
  observeEvent(input$plot_dblclick, {
    
    double_clicked$center <- c(input$plot_dblclick$x,input$plot_dblclick$y)
    
  })
  

  
  lon_index<-reactive({
    z=double_clicked$center
   which((abs(lon-z[1]))<=1)[1]
    
  })
  
  
  lat_index<-reactive({
    z=double_clicked$center
    which((abs(lat-z[2]))<=1)[1]
    
  })
  
 
  
    
  output$dbclick<-renderPlot({
    
    if(!is.na(lon_index())){
      
    z =tmp[lon_index(),lat_index(),]
    
    monthly=matrix(z,nrow=12)
  
    if(length(na.omit(monthly))>0){
      
      annual_min=apply(monthly,2,min,na.omit=TRUE)
      annual_max=apply(monthly,2,max,na.omit=TRUE)
      annual_ave=apply(monthly,2,mean,na.omit=TRUE)
      
    
    annual=as.data.frame(list(annual_ave=annual_ave,years=unique(year(time))))
    
   q=ggplot(annual,aes(x=years,y=annual_ave))+geom_line()+ ylab(expression("Temperature "*~degree*C))+theme_bw()
  q=q+ggtitle(paste0("Annual Average Temperature Trend at (",lon[lon_index()],", ", lat[lat_index()],")"))+xlab('')+theme(axis.title.y = element_text(size=14,angle=90,hjust=.5,vjust=1),
                    axis.text.y = element_text(colour="darkred",size=16,angle=0,hjust=1,vjust=0),plot.title = element_text(vjust=1.5,size = 15,colour="blue"),
                    axis.text.x = element_text(colour="darkred",size=16,angle=0,hjust=1,vjust=0))+stat_smooth(method='lm',color='darkred')
    
     
   q
    }
    
    }
    
  })
  
  
})


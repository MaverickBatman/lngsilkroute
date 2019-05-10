library(ggplot2)

#function(input, output) {
  
  theme_set(theme_bw())
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    if(is.null(input$Market)) return()
    data <- market_prices
    
    if (input$Market != "All") {
      data <- data[data$Market == input$Market,]
    }
    data
  }))
  
  
  
  output$plot1 <- renderPlot({
    
    if(is.null(input$Market)) return()
    market_prices$date <- as.Date(market_prices$Contract_End)
    xs <- market_prices
    
    if (input$Market != "All") 
    {
      xs <- subset(xs, xs$Market == input$Market & xs$date <= as.Date(input$daterange[2]) & xs$date >= as.Date(input$daterange[1]))
      
    }
    
    else
    {
      
      xs <- subset(xs,xs$date <= as.Date(input$daterange[2]) & xs$date >= as.Date(input$daterange[1]))
      
    }
    
    ggplot(data = xs,aes(x = Contract_End, y = Mid, group = Market, 
                         colour = Market)) + geom_line() + geom_point() 
    
    
    
    })
  
    
  
  
#}


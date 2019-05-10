
file1 <-read.csv('db/Inventory.csv', header = TRUE)
t3_temp <- read.csv('db/Long_Lat.csv', header = TRUE)
storage <- storage[complete.cases(storage), ]

#col_plot = c("Beginning_Inventory","Ending_Inventory")
#dlong <- melt(file1[,c("Start_Date", col_plot)], id.vars="Start_Date")  
# file1 <- melt(file1, id.vars="Start_Date")

theme_set(theme_bw())

df <- file1[file1$variable %in% c("LNG Production", "Gas Feed"), ]
df$DATE <- as.Date(df$DATE)
output$t3_dateRange <- renderUI({

  date_start <- as.character(input$t3_dateRange[1])
  date_end <- as.character(input$t3_daterange[2])
})




output$chart1 <-renderPlotly({

 
  # plot
  date_start <- as.character(input$t3_daterange[1])
  date_end <- as.character(input$t3_daterange[2])
  if(is.null(input$t3_daterange[1])) return()
  dfVar<- subset(file1, file1$VARIABLE == "Gas Feed" | file1$VARIABLE =="LNG Production")
                   
  dfVar$DATE <-as.Date(dfVar$DATE,format="%Y-%m-%d")
  reactiveMaster <- reactive({
    subset(dfVar,dfVar$DATE >= as.Date(input$t3_daterange[1]) & dfVar$DATE<= as.Date(input$t3_daterange[2]))
  })
 
  
 p<- ggplot(reactiveMaster(), aes(x= DATE,y =VOLUME_MMBTU )) + 
    geom_line(aes(y=VOLUME_MMBTU, col=VARIABLE)) + 
    labs(title="Feed VS LNG Production Inventory", 
         subtitle="Drawn from Long Data format", 
         
         y="VOLUME_MMBTU", 
         color=NULL) +  # title and caption
    scale_x_date(date_labels = "%b-%d-%Y") + 
    scale_color_manual(labels = c("LNG Production", "Gas Feed"), 
                       values = c("Gas Feed"="#00ba38", "LNG Production"="#f8766d")) +  # line color
    theme(axis.text.x = element_text(angle = 90, vjust=0.5, size = 8),  # rotate x axis text
          panel.grid.minor = element_blank())  # turn off minor grid
  
  
  # 
  # df_sorted <- arrange(file, Ending_Inventory, Beginning_Inventory) 
  # head(df_sorted)
  # df_cumsum <- ddply(df_sorted, "Ending_Inventory",
  #                    transform, 
  #                    label_ypos=cumsum(Beginning_Inventory) - Ending_Inventory)
  # # Create the barplot
  # ggplot(data=df_cumsum, aes(x=Start_Date, y=Beginning_Inventory ,fill=Commodity)) +
  #   geom_line()+
  #   geom_point()
  #  
  #   scale_fill_brewer(palette="Paired")+
  #   theme_minimal()
  # 
  
 ggplotly(p)
})




output$chart2 <- renderPlotly({
  
  

  #agg = aggregate(file1, by = list(file1$DATE),                     FUN = sum())
  file1$DATE <- as.Date(file1$DATE)
  dfVar<- subset(file1, file1$VARIABLE == "LNG Production" | file1$VARIABLE =="Load Quantity")
  dfhist<- subset(dfVar, dfVar$DATE >= as.Date(input$t3_daterange[1]) & dfVar$DATE <= 
                    as.Date(input$t3_daterange[2]) )
  
  t3_PChart2 <-ggplot(data = dfhist, aes( x =  DATE , y = VOLUME_MMBTU, fill = VARIABLE , text =paste("Date: ", format(DATE, "%Y-%m-%d"), "<br> Variable  : " , VARIABLE,  "<br>Volume: ", round(VOLUME_MMBTU, digits = 2), "MMBTU", "<br>Opening_Capacity : " ,round(Opening_Capacity, digits = 2) )))  +    # print bar chart
    geom_bar( stat = 'identity', position = 'dodge' ) +
  geom_line(aes(y = Opening_Capacity, group = 1)) 
  geom_line(colour = "#408FA6")
  geom_text(aes(y = Opening_Capacity, label = round(Opening_Capacity, 2)), vjust = 1.4, color = 'steelblue', size = 3) 
    #geom_text(aes(y = Opening_Capacity, label = round(Opening_Capacity, 2)), vjust = 1.4, color = "black", size = 3) +
 # scale_y_continuous("Volume, MMBTU")
  
  # ggplot(dfhist, aes(x = DATE, y =VOLUME_MMBTU)) +
  #   geom_text(aes(y = VOLUME_MMBTU, label = VOLUME_MMBTU), fontface = "bold", vjust = 1.4, color = "black", size = 4) 
  # geom_line(aes(y = AverageRepair_HrsPerCar * 1500, group = 1, color = 'blackline')) +
  #   
    
    # geom_bar(stat = "identity", aes(fill = VOLUME_MMBTU), width =0.8, legend = FALSE) + 
    # 
    # #stat_summary(aes(label = ..y..), fun.y = 'sum', geom = 'text',  vjust = -0.3) +
    # stat_summary(aes(label = ..y..), fun.y = 'sum') +
    # geom_text(aes(label = ..y..), vjust=-0.3, size=2.5)+
    # #scale_y_continuous("Volume", labels = percent_format()) +
    # scale_y_continuous("Volume, MMBTU")
  
  #opts(axis.title.x = theme_blank())
  # 
  # Df2 <- dfhist %>%
  # filter(VARIABLE %in% c("LNG Production", "Load Quantity")) %>%
  # group_by(DATE) %>%
  #   View(Df2)
  #   
  #   mutate(diff = VOLUME_MMBTU - lag(VOLUME_MMBTU, default = first(VOLUME_MMBTU), order_by = DATE))
  #  
  # 
  # 
  # # p<-ggplot(data = dfhist, aes(x = DATE, y = VOLUME_MMBTU)) +
  # #   geom_col(aes(fill = VARIABLE), width = 0.7)+
  # #   geom_text(aes(y = lab_ypos, label = len, group =supp), color = "white")
  # # p
  # 
  # 
  ggplotly(t3_PChart2, tooltip = "text")
  
}) 


observeEvent(input$location_name,{

  leafletProxy("t3_mymap") %>%
  
  # Remove any existing legend, and only if the legend is
  # enabled, create a new one.
  #proxy %>% clearControls()
 
 flyToBounds(lng1 = min(t3_temp$Longitude),lat1= min(t3_temp$Latitude),lng2= max(t3_temp$Longitude),lat2 = max(t3_temp$Latitude))   
  
})

observeEvent(input$t3_daterange,{
  
  updateDateInput(session ,"daterange" )
  #View(reactiveMaster())
  
})

observeEvent(input$t3_range,{
  
  filteredData <- reactive({
    subset(t3_temp,t3_temp$Utilization >= input$t3_range[1] & t3_temp$Utilization <= input$t3_range[2]) })
  leafletProxy("t3_mymap", data = filteredData()) %>%
    clearShapes() %>%
    addCircles( weight = 1, color = "#777777",
                fillOpacity = 0.7, popup = paste(data$Utilization))
  

output$t3_mymap <- renderLeaflet({
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    subset(t3_temp,t3_temp$Utilization >= input$t3_range[1] & t3_temp$Utilization <= input$t3_range[2]) 
    #t3_temp[t3_temp$Utilization >= input$t3_range[1] & t3_temp$Utilization <= input$t3_range[2]]
  })
    t3_tempfilteredData  <- filteredData()

  leaflet("t3_mymap") %>%
   # addTiles() %>%
   
  #  fitBounds(27.8006,42.7781867,-76.3888383,26.5333)
     addTiles(options = tileOptions(noWrap = TRUE, minZoom = 2)) %>%
 
 # fitBounds(as.numeric(~min(t3_temp$Longitude)), as.numeric(~min(t3_temp$Latitude)), as.numeric(~max(t3_temp$Longitude)), as.numeric(~max(t3_temp$Latitude)))
  # 
    setView(lng = max(t3_tempfilteredData$Longitude), lat = max(t3_tempfilteredData$Latitude), zoom = 2) %>%
  
    addMarkers(data = t3_tempfilteredData,
               lng = ~Longitude  ,
               lat = ~Latitude,
               label = t3_tempfilteredData$Location,
              popup =  paste("Capacity =", t3_tempfilteredData$Daily_Delivery , "</br>", "Volume =" ,t3_tempfilteredData$Opening_Capacity ,"capacity Utilization Rate=" ,round(t3_tempfilteredData$Daily_Delivery/t3_tempfilteredData$Opening_Capacity *100 ,2) )
              

              )
  
 
    
  })


})



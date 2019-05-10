
location_name <- read.csv('db/Location_name.csv', header = TRUE)
location_name <- droplevels(filter(location_name))

t3_temp <- read.csv('db/Long_Lat.csv', header = TRUE)


fluidRow(
  column(4,
    dateRangeInput("t3_daterange", "Select Date range:",
                   start = "2019-01-01",
                   end = "2019-12-31", min = "2008-01-01", max="2019-12-31")),
  column(4, selectInput('location_name', 'Location', as.character(levels(location_name$location_name)), selected ="USA"),offset = 4),
  #A line break to make the interface clearer 




  column(width =12, box(title = "Daily LNG Beginning and Ending Inventory", status = "primary", solidHeader = TRUE,
      collapsible = TRUE,collapsed = TRUE, plotlyOutput("chart1" ,height = "400px" ,width = "1000px"),width = 1000)),
  
  
  column(width=12, box(title = "Daily Net LNG Inventory Change", status = "primary", solidHeader = TRUE,
      collapsible = TRUE, collapsed = TRUE, plotlyOutput("chart2" ,height = "400px",width ="1000px"),width = 1000)),
  
  
  
 # box(title = "Map", status = "primary", solidHeader = TRUE,
     # collapsible = TRUE, collapsed = TRUE, plotlyOutput("barplot", height = 250, width = 300))
 column(width=12, box(title = "Storage capacity Terminal layout ", status = "primary", solidHeader = TRUE,
      collapsible = TRUE,collapsed = TRUE, leaflet::leafletOutput("t3_mymap" ,height = 250, width = 500),width = 1000,sliderInput("t3_range", "Magnitudes",  min(t3_temp$Utilization),  max(t3_temp$Utilization),
                                                                                                                                                   value = range(t3_temp$Utilization), step = 2
                                                                                                                                       ))) 
     )









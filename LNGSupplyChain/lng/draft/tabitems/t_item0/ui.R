  fluidRow(
   
    # Natural gas profile tab item
    shinydashboard::tabItem(
      tabName = "t_item0",
      
      # Natural gas storage facilities tab box
      shinydashboard::tabBox(
        width = 12,
        
        # Natural gas storage facilities tab panel
        tabPanel(
          "Storage Facilities",
          
          # Storage facilities map
          leaflet::leafletOutput("map2"),
          # tags$style(type = "text/css", "#map2 {height: calc(100vh - 80px) !important;}"),
          
          shinyWidgets::dropdownButton(
            
            # Panel title
            h4("List of Inputs"),
            
            # Marker size input select
            selectInput(
              "storageSize",
              h5("Marker Size:"),
              c("Total Capacity (BCF)" = "Total",
                "Working Capacity (BCF)" = "Working"
              )
            ),
            
            # Marker color input select
            selectInput("storageColor", h5("Marker Color:"),
                        c("Storage Type" =
                            "type")),
            circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
            tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
            up = TRUE
          )
        ),
        
        # LNG facilities tab panel
        tabPanel(
          "LNG Facilities",
          
          # LNG facilities map
          leaflet::leafletOutput("map3"),
          # tags$style(type = "text/css", "#map3 {height: calc(100vh - 80px) !important;}"),
          
          shinyWidgets::dropdownButton(
            
            # Panel title
            h4("List of Inputs"),
            
            # Marker size input select
            selectInput("lngSize", h5("Marker Size:"),
                        c("Total Capacity (BCFD)" = "Total")),
            
            # Marker color input select
            selectInput("lngColor", h5("Marker Color:"),
                        c("Facility Type" = "type",
                          "Status" = "status")
            ),
            circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
            tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
            up = TRUE
          )
        )
      )
   
    ),
    
    # Projects, companies, and facilities value boxes
    shiny::uiOutput("projectBox"),
    shiny::uiOutput("companyBox"),
    shiny::uiOutput("facilityBox")
  )

  


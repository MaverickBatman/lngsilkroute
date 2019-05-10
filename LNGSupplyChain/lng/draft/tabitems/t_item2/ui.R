fluidRow(
  #shinydashboard::box(
  leaflet::leafletOutput("t2_mymap"),
  #title = "Voyage", status = "primary", solidHeader = TRUE,
  #collapsible = TRUE,collapsed = FALSE, width = 12
  #),
  
  # shinyWidgets::dropdownButton(
  shinydashboard::box(
    title = "Route", width = 6, status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
    shiny::selectizeInput(
      inputId = "t2_port_select_source_country",
      label = "Source Country:",
      choices = t2_countries,
      selected = "SPAIN"
    ),
    shiny::selectizeInput(
      inputId = "t2_port_select_source_port",
      label = "Source Port:",
      choices = t2_ports_src
    ),
    shiny::selectizeInput(
      inputId = "t2_port_select_dest_country",
      label = "Destination Country:",
      choices = t2_countries,
      selected = "INDIA"
    ),
    shiny::selectizeInput(
      inputId = "t2_port_select_dest_port",
      label = "Destination Post:",
      choices = t2_ports_dest
    ),
    shiny::actionButton(
      inputId = "t2_route_calc",
      label = "Find Route")
    
    # ,
    # circle = TRUE,
    # icon = icon("gear"),
    # width = "300px",
    # status = "danger",
    # tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
    # up = TRUE
  ),
  
  shinydashboard::box(
    title = "Route Calculation Input", width = 6, status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
    shiny::numericInput(inputId = "t2_route_speed",
                        label = "Speed:",
                        value = 15),
    shiny::numericInput(inputId = "t2_route_weather_days",
                        label = "Weather Days:",
                        value = 1),
    shiny::numericInput(inputId = "t2_route_fuel_consumption",
                        label = "Fuel consumption:",
                        value = 18),
    shiny::numericInput(inputId = "t2_route_fuel_price",
                        label = "Fuel Price:",
                        value = 135)
  ),
  
  shinydashboard::box(
    title = "Live Tracking", width = 12, status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
    shiny::numericInput(inputId = "t2_mmsi_code",
                 label = "Enter the MMSI Code:",
                 value = 311000760),
    shiny::actionButton(
      inputId = "t2_track_find",
      label = "Find Vessel"),
    shiny::actionButton(
      inputId = "t2_track_clear",
      label = "Clear")
    
    # ,
    # circle = TRUE,
    # icon = icon("gear"),
    # width = "300px",
    # status = "danger",
    # tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
    # up = TRUE
  )
  
)

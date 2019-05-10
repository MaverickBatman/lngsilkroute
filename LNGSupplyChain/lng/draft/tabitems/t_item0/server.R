# Load data from 'energyr' package
data(electric, package = "energyr")
data(hydropower, package = "energyr")
data(gas, package = "energyr")
data(oil, package = "energyr")
data(storage, package = "energyr")
data(pipeline, package = "energyr")
data(lng, package = "energyr")


# Aggregate pipeline data for googleVis chart
motionData <- dplyr::select(pipeline, Type, Year, Cost, Miles, Capacity)
motionData <- dplyr::filter(motionData,!is.na(Year))
motionData[is.na(motionData)] <- 0
motionData <- aggregate(
  motionData[, 3:5],
  by = list(Year = motionData$Year, Type = motionData$Type),
  FUN = sum
)
motionData$Year <- as.Date(as.character(motionData$Year), format = "%Y")

# Calculate the number of unique companies, projects, and facilities in database
company <-  length(unique(gas[, 1])) + length(unique(storage[, "Company"])) + length(unique(lng[, "Company"]))
project <- length(unique(pipeline[, "Name"]))
facility <- length(unique(storage[, "Field"]))


# Create the projects box
output$projectBox <- shiny::renderUI({
  shinydashboard::valueBox(
    project,
    "Pipeline Profiles",
    icon = shiny::icon("database"),
    color = "green"
  )
})

# Create the companies box
output$companyBox <- shiny::renderUI({
  shinydashboard::valueBox(company,
                           "Company Profiles",
                           icon = shiny::icon("users"),
                           color = "purple")
})

# Create the facilities box
output$facilityBox <- shiny::renderUI({
  shinydashboard::valueBox(
    facility,
    "Storage Facilities",
    icon = shiny::icon("building"),
    color = "yellow"
  )
})

# Plot the storage map
output$map2 <- renderLeaflet({
  
  # Get the complete cases from storage data
  storage <- storage[complete.cases(storage), ]
  
  # Create the popup content
  content <- paste0(
    "<strong>Company: </strong>",
    storage$Company,
    "<br><strong>Field: </strong>",
    storage$Field,
    "<br><strong>Total Capacity (BCF): </strong>",
    storage$Total
  )
  
  # Create the color palette
  pal <- colorFactor(c("navy", "red", "green"),
                              domain = c("Depleted Field", "Salt Dome", "Aquifer"))
  
  # Plot the leaflet map based on 'Total Capacity' variable
  if (input$storageSize == "Total") {
    
    leaflet(storage) %>%
      
      # Add provider tiles to the map
      addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
      addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%
      
      # Add circle markers to the map
      addCircles(
        radius = ~ Total / 1000,
        color = ~ pal(Type),
        popup = ~ content
      ) %>%
      
      # Add a control widget to the map
      addLayersControl(
        baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
        position = "bottomright",
        options = layersControlOptions(collapsed = TRUE)
      ) %>%
      
      # Add a legend to the map
      addLegend(
        "topright",
        pal = pal,
        values = ~ Type,
        title = "Storage Type"
      )
    
    # Plot the leaflet map based on 'Working Capacity' variable
  } else if (input$storageSize == "Working") {
    
    leaflet(storage) %>%
      
      # Add provider tiles to the map
      addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
      addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%
      
      # Add circle markers to the map
      addCircles(
        radius = ~ Working / 1000,
        color = ~ pal(Type),
        popup = ~ content
      ) %>%
      
      # Add a control widget to the map
      addLayersControl(
        baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
        position = "bottomright",
        options = layersControlOptions(collapsed = TRUE)
      ) %>%
      
      # Add a legend to the map
      addLegend(
        "topright",
        pal = pal,
        values = ~ Type,
        title = "Storage Type"
      )
  }
})

# Plot the LNG map
output$map3 <- renderLeaflet({

  # Get the complete cases from lng data
  lng <- lng[complete.cases(lng), ]

  # Create the popup content
  content <- paste0(
    "<strong>Company: </strong>",
    lng$Company,
    "<br><strong>Capacity (BCFD): </strong>",
    lng$Capacity
  )

  # Create the leaflet map based on 'type' variable
  if (input$lngColor == "type") {

    # Create the color palette
    pal <- colorFactor(c("navy", "red"), domain = c("Export", "Import"))

    leaflet(lng) %>%

      # Add provider tiles to the map
      addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
      addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

      # Add circle markers to the map
      addCircles(
        radius = ~ Capacity,
        color = ~ pal(Type),
        popup = ~ content
      ) %>%

      # Add a legend to the map
      addLegend(
        "topright",
        pal = pal,
        values = ~ Type,
        title = "Facility Type"
      ) %>%

      # Add a control widget to the map
      addLayersControl(
        baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
        position = "bottomright",
        options = layersControlOptions(collapsed = TRUE)
      )

    # Create the leaflet map based on 'status' variable
  } else if (input$lngColor == "status") {

    # Create the color palette
    pal <- colorFactor(c("navy", "red", "green", "orange"),
                                domain = c(
                                  "Not under construction",
                                  "Under construction",
                                  "Existing",
                                  "Proposed"
                                )
    )

    leaflet(lng) %>%

      # Add provider tiles to the map
      addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
      addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

      # Add circle markers to the map
      addCircles(
        radius = ~ Capacity,
        color = ~ pal(Status),
        popup = ~ content
      ) %>%

      # Add a legend to the map
      addLegend(
        "topright",
        pal = pal,
        values = ~ Status,
        
        title = "Facility Status"
      ) %>%

      # Add a control widget to the map
      addLayersControl(
        baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
        position = "bottomright",
        options = layersControlOptions(collapsed = TRUE)
      )
  }
})

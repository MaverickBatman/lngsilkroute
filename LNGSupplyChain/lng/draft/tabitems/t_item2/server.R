t2_routeFile <- readLines("out.csv")
t2_routeFileLine <- t2_routeFile[2]
t2_inputstr  <- str_extract(string = t2_routeFileLine, ".*[}]")
write_file(t2_inputstr, "out.geojson")
t2_route <- geojsonio::geojson_read("out.geojson", what = "sp")
t2_apikey_apiaprsfi <- read.delim(file = "./apikey/api.aprs.fi.txt")


observeEvent(input$t2_route_calc, {
  #browser()
  t2_src <- input$t2_port_select_source_port
  t2_dest <- input$t2_port_select_dest_port
  
  t2_src_lat = t2_ports[which(t2_ports[,3] == t2_src & t2_ports[,4] == input$t2_port_select_source_country, arr.ind = TRUE),]$lat
  t2_src_lon = t2_ports[which(t2_ports[,3] == t2_src & t2_ports[,4] == input$t2_port_select_source_country, arr.ind = TRUE),]$lon
  t2_dest_lat = t2_ports[which(t2_ports[,3] == t2_dest & t2_ports[,4] == input$t2_port_select_dest_country, arr.ind = TRUE),]$lat
  t2_dest_lon = t2_ports[which(t2_ports[,3] == t2_dest & t2_ports[,4] == input$t2_port_select_dest_country, arr.ind = TRUE),]$lon
  
  t2_routeFileInput <- paste("route name,olon,olat,dlon,dlat\n",
                             t2_src, "-", t2_dest, ",",
                             t2_src_lon, ",", t2_src_lat, ",",
                             t2_dest_lon, ",", t2_dest_lat, sep = "")
  write.table(x = t2_routeFileInput, file = "test_input.csv", row.names = FALSE, col.names = FALSE, quote = FALSE)
  system("java -jar searoute.jar -i \"test_input.csv\"")
  t2_routeFile <- readLines("out.csv")
  t2_routeFileLine <- t2_routeFile[2]
  t2_inputstr  <- str_extract(string = t2_routeFileLine, ".*[}]")
  t2_route_distance <- as.numeric(unlist(str_split(str_extract(string = t2_routeFileLine, "(?:\\},)(.*)$"), ","))[6])
  write_file(t2_inputstr, "out.geojson")
  t2_route <- geojsonio::geojson_read("out.geojson", what = "sp")
  
  t2_route_eta <- round((t2_route_distance/input$t2_route_speed)/24, digits = 2) + input$t2_route_weather_days
  t2_route_port_charges_src <- t2_ports[which(t2_ports[,3] == t2_src & t2_ports[,4] == input$t2_port_select_source_country, arr.ind = TRUE),]$Port_Charges
  t2_route_port_charges_dest <- t2_ports[which(t2_ports[,3] == t2_dest & t2_ports[,4] == input$t2_port_select_dest_country, arr.ind = TRUE),]$Port_Charges
  t2_route_bunker_cost <- round((t2_route_eta*input$t2_route_fuel_consumption*input$t2_route_fuel_price),0)
  t2_route_port_charges <- round(t2_route_port_charges_src + t2_route_port_charges_dest,0)
  t2_route_est_total_cost <- round(t2_route_bunker_cost + t2_route_port_charges,0)
  
  leafletProxy("t2_mymap") %>%
    clearShapes() %>%
    clearMarkers() %>%
    addMarkers(lng = t2_src_lon,
               lat = t2_src_lat,
               #popup = t2_src,
               label = t2_src,
               #popupOptions = popupOptions(keepInView = TRUE), 
               labelOptions = labelOptions(noHide = TRUE),
               #options = leaflet::markerOptions(riseOnHover = TRUE),
               group = "Route"
    ) %>%
    addMarkers(lng = t2_dest_lon,
               lat = t2_dest_lat,
               #popup = t2_dest,
               label = t2_dest,
               #popupOptions = popupOptions(keepInView = TRUE), 
               labelOptions = labelOptions(noHide = TRUE),
               #options = leaflet::markerOptions(riseOnHover = TRUE),
               group = "Route"
    ) %>%
    addPolylines(data = t2_route,
                 group = "Route",
                 popup = paste("From: <b>", t2_src, "</b></br>", 
                               "To: <b>", t2_dest, "</b></br>", 
                               "Distance: " , t2_route_distance, "</br>",
                               "ETA: ", t2_route_eta, " days</br></br>",
                               "Bunker Cost: $ " , t2_route_bunker_cost, "</br>",
                               "Port charges : $ ", t2_route_port_charges, "</br>",
                               "Estimated Voyage Cost: $ " , t2_route_est_total_cost)) %>%
    flyToBounds(lng1 = t2_src_lon, lat1 = t2_src_lat, lng2=t2_dest_lon, lat2=t2_dest_lat)
})

observeEvent(input$t2_port_select_source_country, {
  t2_ports_src <- t2_ports[t2_ports$Wpi_country_code == input$t2_port_select_source_country,]$Main_port_name
  updateSelectInput(session = session, inputId = "t2_port_select_source_port",
                    choices = t2_ports_src)
})

observeEvent(input$t2_port_select_dest_country, {
  t2_ports_dest <- t2_ports[t2_ports$Wpi_country_code == input$t2_port_select_dest_country,]$Main_port_name
  updateSelectInput(session = session, inputId = "t2_port_select_dest_port",
                    choices = t2_ports_dest)
})

observeEvent(input$t2_track_find, {
  t2_mmsi_code <- t2_vessel[which(t2_vessel[,1] == input$t2_vessel_input, arr.ind = TRUE),]$vessel_id
  t2_aprs_url <- paste("https://api.aprs.fi/api/get?name=",t2_mmsi_code,"&what=loc&apikey=124120.5mDkwDKjOaSnSH&format=json", sep = "")
  t2_aprs_data <- jsonlite::fromJSON(t2_aprs_url)
  t2_vessel_details <- t2_aprs_data[["entries"]]

  leafletProxy("t2_mymap") %>%
    addMarkers(data = t2_vessel_details,
               lng = as.numeric(t2_vessel_details$lng),
               lat = as.numeric(t2_vessel_details$lat),
               popup = paste("Vessel: ", t2_vessel_details$name, "</br>",
                             "MMSI: ", t2_vessel_details$mmsi, "</br>",
                             "IMO: ", t2_vessel_details$imo, "</br>",
                             "Speed: ", t2_vessel_details$speed, "km/h</br>",
                             "Dimensions: ", "Length ", t2_vessel_details$length,"m, Width ", t2_vessel_details$width, "m, Draught ", t2_vessel_details$length, "m",  "</br>",
                             "ETA: ", str_extract(string = t2_vessel_details$comment, "(?<=\\(ETA )(.*)(?=\\))"), "</br>",
                             "Destination: ",str_extract(string = t2_vessel_details$comment, "(.*)(?= \\()"), "</br>",
                             sep = ""),
               label = ~name,
               icon = list(iconUrl = "icon/ship.png", iconSize = c(20, 20)),
               group = "Route"
    ) %>%
    flyToBounds(lng1 = as.numeric(t2_vessel_details$lng)+1, lat1 = as.numeric(t2_vessel_details$lat)+1, lng2=as.numeric(t2_vessel_details$lng)-1, lat2=as.numeric(t2_vessel_details$lat)-1)
})

observeEvent(input$t2_track_find_mmsi, {
  t2_aprs_url <- paste("https://api.aprs.fi/api/get?name=",input$t2_mmsi_code_input,"&what=loc&apikey=124120.5mDkwDKjOaSnSH&format=json", sep = "")
  t2_aprs_data <- jsonlite::fromJSON(t2_aprs_url)
  t2_vessel_details <- t2_aprs_data[["entries"]]
  
  leafletProxy("t2_mymap") %>%
    addMarkers(
    #addAwesomeMarkers(
               data = t2_vessel_details,
               lng = as.numeric(t2_vessel_details$lng),
               lat = as.numeric(t2_vessel_details$lat),
               popup = paste("Vessel: ", t2_vessel_details$name, "</br>",
                             "MMSI: ", t2_vessel_details$mmsi, "</br>",
                             "IMO: ", t2_vessel_details$imo, "</br>",
                             "Speed: ", t2_vessel_details$speed, "km/h</br>",
                             "Dimensions: ", "Length ", t2_vessel_details$length,"m, Width ", t2_vessel_details$width, "m, Draught ", t2_vessel_details$length, "m",  "</br>",
                             "ETA: ", str_extract(string = t2_vessel_details$comment, "(?<=\\(ETA )(.*)(?=\\))"), "</br>",
                             "Destination: ",str_extract(string = t2_vessel_details$comment, "(.*)(?= \\()"), "</br>",
                             sep = ""),
               label = ~name,
               icon = list(iconUrl = "icon/ship.png", iconSize = c(20, 20)),
               group = "Route"
    ) %>%
    flyToBounds(lng1 = as.numeric(t2_vessel_details$lng)+1, lat1 = as.numeric(t2_vessel_details$lat)+1, lng2=as.numeric(t2_vessel_details$lng)-1, lat2=as.numeric(t2_vessel_details$lat)-1)
})

output$t2_mymap <- renderLeaflet({
  leaflet() %>%
    #addTiles(options = tileOptions(noWrap = TRUE, minZoom = 2)) %>%
    addProviderTiles(providers$Esri.WorldStreetMap, options = providerTileOptions(noWrap = TRUE), group = "Esri.WorldStreetMap") %>%
    addProviderTiles(providers$Stamen.Terrain, options = providerTileOptions(noWrap = TRUE), group = "Stamen.Terrain") %>%
    addProviderTiles(providers$Esri.WorldImagery, options = providerTileOptions(noWrap = TRUE), group = "Esri.WorldImagery") %>%
    addProviderTiles(providers$OpenStreetMap.Mapnik, options = providerTileOptions(noWrap = TRUE), group = "OpenStreetMap.Mapnik") %>%
    addProviderTiles(providers$OpenInfraMap.Water, options = providerTileOptions(noWrap = TRUE), group = "OpenInfraMap.Water") %>%
    addProviderTiles(providers$Stamen.TonerLite, options = providerTileOptions(noWrap = TRUE), group = "Stamen.TonerLite") %>%
    addProviderTiles(providers$Thunderforest.Landscape, options = providerTileOptions(noWrap = TRUE), group = "Thunderforest.Landscape") %>%
    addProviderTiles(providers$Esri.NatGeoWorldMap, options = providerTileOptions(noWrap = TRUE), group = "Esri.NatGeoWorldMap") %>%
    addProviderTiles(providers$CartoDB.Positron, options = providerTileOptions(noWrap = TRUE), group = "CartoDB.Positron") %>%
    setView(lng = 0, lat = 0, zoom = 2) %>%
    addCircleMarkers(
      data = t2_ports,
      lat =  ~ lat,
      lng = ~ lon,
      radius = 3,
      label =  ~ Main_port_name,
      clusterOptions = markerClusterOptions(),
      group = "Ports"
    ) %>%
    addLayersControl(
      baseGroups = c("Esri.WorldStreetMap","Stamen.Terrain","Esri.WorldImagery","OpenStreetMap.Mapnik","OpenInfraMap.Water","Stamen.TonerLite","Thunderforest.Landscape","Esri.NatGeoWorldMap","CartoDB.Positron","CartoDB.Voyager"),
      overlayGroups = c("Ports", "Route"),
      position = "topright",
      options = layersControlOptions(collapsed = TRUE)
    )
  
  
})

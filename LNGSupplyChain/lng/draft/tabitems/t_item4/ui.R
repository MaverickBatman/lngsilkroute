tabItems(
    
    # Natural gas profile tab item
    # tabItem(
    #   tabName = "gasProfile",

    #   # Natural gas storage facilities tab box
    #   tabBox(
    #     width = 12,
    #     
    #     # Natural gas storage facilities tab panel
    #     tabPanel(
    #       "Storage Facilities",
    #       
    #       # Storage facilities map
    #       leaflet::leafletOutput("map2"),
    #       # tags$style(type = "text/css", "#map2 {height: calc(100vh - 80px) !important;}"),
    #       
    #       shinyWidgets::dropdownButton(
    #         
    #         # Panel title
    #         h4("List of Inputs"),
    #         
    #         # Marker size input select
    #         selectInput(
    #           "storageSize",
    #           h5("Marker Size:"),
    #           c("Total Capacity (BCF)" = "Total",
    #             "Working Capacity (BCF)" = "Working"
    #           )
    #         ),
    #         
    #         # Marker color input select
    #         selectInput("storageColor", h5("Marker Color:"),
    #                            c("Storage Type" =
    #                                "type")),
    #         circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
    #         tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
    #         up = TRUE
    #       )
    #     ),
    #     
    #     # LNG facilities tab panel
    #     tabPanel(
    #       "LNG Facilities",
    #       
    #       # LNG facilities map
    #       leaflet::leafletOutput("map3"),
    #       # tags$style(type = "text/css", "#map3 {height: calc(100vh - 80px) !important;}"),
    #       
    #       shinyWidgets::dropdownButton(
    #         
    #         # Panel title
    #         h4("List of Inputs"),
    #         
    #         # Marker size input select
    #         selectInput("lngSize", h5("Marker Size:"),
    #                            c("Total Capacity (BCFD)" = "Total")),
    #         
    #         # Marker color input select
    #         selectInput("lngColor", h5("Marker Color:"),
    #                            c("Facility Type" = "type",
    #                              "Status" = "status")
    #         ),
    #         circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
    #         tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
    #         up = TRUE
    #       )
    #     )
    #   )
    # ),
    
    # Natural gas performance tab item
    tabItem(
      tabName = "gasPerform",
      fluidRow(
        
        # Natural gas performance box
        box(
          title = "Performance Indicator",
          status = "primary",
          width = 6,
          collapsible = T,
          
          # Natural gas performance histogram
          plotly::plotlyOutput("hist5")
        ),
        
        # Natural gas heatmap box
        box(
          title = "Heatmap",
          status = "primary",
          width = 6,
          collapsible = T,
          
          # Natural gas heatmap
          plotly::plotlyOutput("heatmap")
        )
      ),
      fluidRow(
        
        shinyWidgets::dropdownButton(
          
          # Panel title
          h4("List of Inputs"),
          
          # Performance variable input select
          selectInput(
            "perform",
            h5("Select Performance Indicator:"),
            c(
              "Cost/Mile (kUSD/Mile)" = "costMile",
              "Cost/Added Capacity (kUSD/MMcf/d)" = "costCap"
            )
          ),
          
          # Heatmap type input select
          selectInput(
            "sensitivity",
            h5("Select Type of Sensitivity Measure:"),
            c(
              "Contribution to Variance" = "varr",
              "Rank Correlation" = "corr"
            )
          ),
          circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
          tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs !"),
          up = TRUE
        )
      )
    ),
    
    # Natural gas trends tab item
    tabItem(
      tabName = "gasTrends",
      
      # Natural gas trends tab box
      tabBox(
        width = 12,
        
        # Natural gas cost trends tab panel
        tabPanel(
          "Cost Trends",
          fluidRow(
            
            # Natural gas cost trends box
            box(
              title = "Project Cost Trends",
              status = "primary",
              width = 12,
              collapsible = T,
              
              # Natural gas cost trends box plots
              plotly::plotlyOutput("boxplot"),
              
              shinyWidgets::dropdownButton(
                
                # Panel title
                h4("List of Inputs"),
                
                # Cost variable input select
                selectInput(
                  "gas",
                  h5("Select Input:"),
                  c("Cost (mUSD)" = "cost",
                    "Cost/Mile (mUSD/Mile)" = "costMile")
                ),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                up = TRUE
              )
            )
          )
        ),
        
        # Natural gas revenue trends tab panel
        tabPanel(
          "Revenue Trends",
          fluidRow(
            
            # Natural gas revenue trends box
            box(
              title = "Revenue Trends",
              status = "primary",
              width = 12,
              collapsible = T,
              
              # Natural gas revenue line chart
              plotly::plotlyOutput("lineChart3"),
              
              shinyWidgets::dropdownButton(
                
                # Panel title
                h4("List of Inputs"),
                
                # Revenue variable input select
                selectInput(
                  "gasRates",
                  h5("Select Input:"),
                  c("Revenue (USD)" = "Revenue",
                    "Bill (USD)" = "Bill")
                ),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                up = TRUE
              )
            )
          )
        )
      )
    ),
    
    # Natural gas explorer tab item
    tabItem(
      tabName = "gasExplorer",
      
      # Natural gas explorer box
      box(
        title = "Explorer",
        status = "primary",
        width = 12,
        collapsible = T,
        
        # Natural gas googleVis motion chart
        htmlOutput("motion1"),
        style = "overflow:hidden;"
      )
    ),
    
    # Natural gas data tab item
    tabItem(
      tabName = "gasData",
      
      
      # Natural gas data tab box
      tabBox(
        width = 12,
        
        # Natural gas project data tab panel
        tabPanel("Project Data",
                        DT::dataTableOutput("pipelineTable")),
        
        # Natural gas revenue data tab panel
        tabPanel("Revenue Data",
                        DT::dataTableOutput("gasTable"))
      )
    )

  )
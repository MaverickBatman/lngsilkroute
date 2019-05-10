data <- read.csv("db/Natural_Gas_Forward_Prices.csv")

mydb <- dbConnect(RSQLite::SQLite(), "db/my-db.db")
dbWriteTable(mydb, "user_market_prices",data, overwrite = TRUE, append = FALSE) 

market_prices <- dbGetQuery(mydb, 'SELECT * FROM user_market_prices')

fluidPage(
  navbarPage("Natural Gas Prices",
             # Create a new Row in the UI for selectInputs
             tabPanel("Price Plots Based on Location",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("Market",
                                      "Market:",
                                      c("All",unique(as.character(market_prices$Market))),
                                      selected = TRUE,
                                      multiple = TRUE
                          ),
                          dateRangeInput("daterange", "Select Date range:",
                                         start = "2019-01-01",
                                         end = "2019-08-01")
                        ),
                        mainPanel(
                          fluidRow(
                            column(width = 12,
                                   plotOutput("plot1", height = 500,
                                              # Equivalent to: click = clickOpts(id = "plot_click")
                                              click = "plot1_click",
                                              brush = brushOpts(
                                                id = "plot1_brush"
                                              )
                                   )
                            )
                          )
                        )
                      )
             ),
             tabPanel("Natural Gas Prices",
                      DT::dataTableOutput("table"))
  )
)

#              
#   
#                fluidRow(
#                  column(4,
#                         selectInput("Market",
#                                     "Market:",
#                                     c("All",unique(as.character(market_prices$Market))),
#                                     selected = TRUE,
#                                     multiple = TRUE
#                         )
#                  )
#                ),
#                
#                # select date range
#                fluidRow(
#                  column(4,
#                         dateRangeInput("daterange", "Select Date range:",
#                                        start = "2019-01-01",
#                                        end = "2019-08-01")
#                         
#                  )
#                ),
#                
#                #plot the graph
#                mainPanel(
#                  fluidRow(
#                    column(width = 12,
#                           plotOutput("plot1", height = 500,
#                                      # Equivalent to: click = clickOpts(id = "plot_click")
#                                      click = "plot1_click",
#                                      brush = brushOpts(
#                                        id = "plot1_brush"
#                                      )
#                           )
#                    )
#                  )),
#                # Create a new row for the table.
#            
#              
#   )
# )
#   
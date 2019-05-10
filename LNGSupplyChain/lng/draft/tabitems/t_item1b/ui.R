fluidPage(
  
  navbarPage("Effective Gas Cost",
             # tabPanel("Plot",
             #          sidebarLayout(
             #            sidebarPanel(
             #              radioButtons("plotType", "Plot type",
             #                           c("Scatter"="p", "Line"="l")
             #              )
             #            ),
             #            mainPanel(
             #              plotOutput("plot")
             #            )
             #          )
             # ),
             tabPanel("Storage Data",
                      DT::dataTableOutput("price")
             ),
             tabPanel("Calculate Gas Cost",
                      sidebarPanel
                      (
                        # fileInput("file", "File input:"),
                        # textInput("txt", "Text input:", "general"),
                        
                        # Default value is the date in client's time zone
                        dateInput("date", "Date:"),
                        numericInput("bal", "Balance:", 0,min = 1, max = 1000000),
                        numericInput("inj", "Injections:", 0,min = 1, max = 1000000),
                        numericInput("wth", "Withdrawals:", 0,min = 1, max = 1000000),
                        numericInput("loss", "Losses:", 0,min = 1, max = 1000000),
                        numericInput("gas_price", "Gas Price(Buy):", 0,min = 1, max = 1000000),
                        numericInput("wacog", "Gas Price(In Store):", 0,min = 1, max = 1000000)
                        
                        # actionButton("action2", "Gas Cost", class = "btn-primary")
                      ),
                      mainPanel(
                        
                        h4("Effective Gas Cost"),
                        verbatimTextOutput("txtout")
                        # h4("Gas Storage Details"),
                        # DT::dataTableOutput("table")
                      )
                      
             ),
             tabPanel("COST vs MARKET PRICES",
                      headerPanel("Gas Cost VS Prices from Different Locations"),
                      mainPanel(
                        plotlyOutput('trendPlot', height = "500px")
                      )
             )
  )
)

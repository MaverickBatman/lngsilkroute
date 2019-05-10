fluidRow(
  titlePanel("t1_abcd"),
  box(
    title = "Distribution",
    status = "primary",
    plotOutput("t1_plot1", height = 240),
    height = 300
  ),
  tabBox(
    height = 300,
    tabPanel("t1_View 1",
             plotOutput("t1_scatter1", height = 230)
    ),
    tabPanel("t1_View 2",
             plotOutput("t1_scatter2", height = 230)
    )
  )
)

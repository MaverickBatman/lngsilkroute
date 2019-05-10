

library(shiny)
library(shinyWidgets)
library(DBI)
library(jsonlite)
mainbody <- div(tabItems(
  tabItem(tabName = "t_item0", class = "active", source("tabitems/t_item0/ui.R")$value),
  tabItem(tabName = "gasProfile",source("tabitems/t_item4/ui.R")$value),
  
  
  #tabItem(tabName = "t_item1", source("tabitems/t_item1/ui.R")$value)
  tabItem(tabName = "t_item1a", source("tabitems/t_item1a/ui.R")$value),
  tabItem(tabName = "t_item1b", source("tabitems/t_item1b/ui.R")$value),
  tabItem(tabName = "t_item2", source("tabitems/t_item2/ui.R")$value),
  tabItem(tabName = "t_item3", source("tabitems/t_item3/ui.R")$value)
  
))
# Define server logic required to draw a histogram
shinyServer(function(input, output, session){
  output$sidebarpanel <- renderUI({
    source(file.path("sidebarpanel", paste0("sidebarpanel", ".R")), local=TRUE)$value
  })  
  
  output$body <- renderUI({
    mainbody
  })
  source("tabitems/t_item0/server.R", local = TRUE)
  source("tabitems/t_item1a/server.R", local = TRUE)
  source("tabitems/t_item1b/server.R", local = TRUE)
  source("tabitems/t_item2/server.R", local = TRUE)
  source("tabitems/t_item3/server.R", local = TRUE)
  source("tabitems/t_item4/server.R", local = TRUE)
})





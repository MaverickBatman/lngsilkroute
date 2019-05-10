
div(
  sidebarMenu(id="tabs",
    menuItem("Dashboard", tabName = "t_item0", icon = icon("dashboard")),
    # Natural gas menu item
    menuItem(
      "Natural Gas",
      icon = shiny::icon("th"),
      tabName = "naturalgas",
      
      # Natural gas profile menu sub-item
      # menuSubItem(
      #   "Profile",
      #   tabName = "gasProfile",
      #   icon = shiny::icon("globe")
      # ),
      # 
      # # Natural gas performance menu sub-item
      # menuSubItem(
      #   "Performance",
      #   tabName = "gasPerform",
      #   icon = shiny::icon("bar-chart")
      # ),
      # 
      # # Natural gas trends menu sub-item
      # menuSubItem(
      #   "Trends",
      #   tabName = "gasTrends",
      #   icon = shiny::icon("line-chart")
      # ),
      # 
      # # Natural gas explorer menu sub-item
      # menuSubItem(
      #   "Explorer",
      #   tabName = "gasExplorer",
      #   icon = shiny::icon("gear")
      # ),
      
      # Natural gas data menu sub-item
      menuSubItem(
        "Data",
        tabName = "gasData",
        icon = shiny::icon("table"))
    ),
    menuItem("Prices", tabName = "t_item1", icon = icon("line-chart"),selected = TRUE,
             menuSubItem('Natural Gas Prices',
                          tabName = 't_item1a',
                          icon = icon('line-chart')),
             menuSubItem('Effective Gas Cost',
                          tabName = 't_item1b',
                          icon = icon('line-chart'))
             ),
    menuItem("Voyage", tabName = "t_item2", icon = icon("ship")),
    menuItem("Inventory", tabName = "t_item3", icon = icon("dollar"))
  )
  
)


library(shinyWidgets)
sidebar <- dashboardSidebar(
  uiOutput("sidebarpanel")
  )
body <- dashboardBody(
  uiOutput("body")
)
messages <- dropdownMenu(type = "messages",
                         messageItem(
                           from = "Calendar",
                           message = "Upcoming Events"
                         ),
                         messageItem(
                           from = "New User",
                           message = "How do I register?",
                           icon = icon("question"),
                           time = "13:45"
                         ),
                         messageItem(
                           from = "Support",
                           message = "Pending Tickets.",
                           icon = icon("life-ring"),
                           time = "2014-12-01"
                         )
)

notifications <- dropdownMenu(type = "notifications", badgeStatus = "warning",
                              notificationItem(
                                text = "Prices Received",
                                icon("users")
                              ),
                              notificationItem(
                                text = "EOD Completed",
                                icon("process"),
                                status = "warning"
                              ),
                              notificationItem(
                                text = "Reports Generated",
                                icon = icon("exclamation-triangle"),
                                status = "success"
                              )
)

tasks <- dropdownMenu(type = "tasks", badgeStatus = "success",
                      taskItem(value = 90, color = "green",
                               "Revenue Forecast"
                      ),
                      taskItem(value = 17, color = "aqua",
                               "Expence Forecast"
                      ),
                      taskItem(value = 75, color = "yellow",
                               "Realized Revenue"
                      )
)
header <- dashboardHeader(
  title = "LNG Silk Route Dashboard",
  messages,
  notifications,
  tasks
)
ui <- dashboardPage(header, sidebar, body)

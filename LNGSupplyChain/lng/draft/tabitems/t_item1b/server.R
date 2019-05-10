
mydb <- dbConnect(RSQLite::SQLite(), "db/my-db.db")
if(dbExistsTable(mydb,"wacog"))  {
  data <- dbGetQuery(mydb, 'SELECT * FROM wacog') 
}
if(!dbExistsTable(mydb,"wacog"))
{
  wacog <- read.csv("db/WACOG_Input.csv")
  dbWriteTable(mydb, "wacog", wacog)
  data <- dbGetQuery(mydb, 'SELECT * FROM wacog') 
}

newWacog <- c()
prevWacog <- c()
for (row in 1:nrow(data)) {
  price <- data[row, "InjGasPrice"]
  date  <- data[row, "Date"]
  openBal  <- data[row, "OpeningBal"]
  inj  <- data[row, "Injections"]
  loss  <- data[row, "Losses"]
  if(row == 1)
  {
    #pWacog <- data[row, "PrevWACOG"]
    pWacog <- 0
  }
  else
  {
    pWacog <- data[row-1, "CurrWACOG"]
  }
  
  numerator = (openBal * pWacog)+((inj+loss)*price)
  denom = (openBal + inj)
  
  curWacog = round(numerator/denom,2)
  data[row, "CurrWACOG"] <- curWacog
  newWacog <- c(newWacog,curWacog)
}

cbind(data, newWacog)
if(dbExistsTable(mydb,"wacog"))
{
  dbRemoveTable(mydb,"wacog")
}

dbWriteTable(mydb, "wacog", data)


output$price <- DT::renderDataTable({
  data})



newday = as.Date(data$Date, "%d-%b-%y")

df1 = data.frame(Date = newday,
                 Price = data$CurrWACOG)

# output$plot <- renderPlot({
#   plot(Price ~ Date,df1,xaxt = "n", type=input$plotType)
# })

vals <- reactiveValues()
observe({
  vals$i <- input$inj
  vals$b <- input$bal
  vals$l <- input$loss
  vals$g <- input$gas_price
  vals$w <- input$wacog
  vals$cost <- (((vals$i+vals$l)*vals$g)+(vals$b * vals$w))/(vals$i + vals$b)
})


output$txtout <- renderText({
  paste("On ",format(input$date)," Effective Cost = ,",vals$cost )
})

newday = as.Date(data$Date, "%d-%b-%y")
mydb <- dbConnect(RSQLite::SQLite(), "db/my-db.db")
if(dbExistsTable(mydb,"wacog"))  {
  data <- dbGetQuery(mydb, 'SELECT * FROM wacog') 
}
if(!dbExistsTable(mydb,"wacog"))
{
  wacog <- read.csv("db/WACOG_Input.csv")
  dbWriteTable(mydb, "wacog", wacog)
  data <- dbGetQuery(mydb, 'SELECT * FROM wacog') 
}
newday = as.Date(data$Date, "%d-%b-%y")

# output$table <- DT::renderDataTable({ 
#   data
# })

df2 <- data.frame(Date = newday ,Location = "Gas Storage", Price = data$CurrWACOG)

fileInput <- read.csv("db/Prices.csv")
newday1 = as.Date(fileInput$Date, "%m/%d/%Y")
df3 <- data.frame(Date = newday1,Location = fileInput$Location,Price = fileInput$Price)

both <- rbind(df3, df2)

output$trendPlot <- renderPlotly({
  p <- ggplot(data=both, aes(x=Date, 
                             y=Price,  
                             group = Location, 
                             colour = Location)
  )   +  geom_line() 
  
  ggplotly(p) 
})

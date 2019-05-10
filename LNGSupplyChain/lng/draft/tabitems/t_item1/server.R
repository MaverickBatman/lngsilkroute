
output$t1_scatter1 <- renderPlot({
  spread <- as.numeric(10) / 100
  x <- rnorm(1000)
  y <- x + rnorm(1000) * spread
  plot(x, y, pch = ".", col = "blue")
})

output$t1_scatter2 <- renderPlot({
  spread <- as.numeric(11) / 100
  x <- rnorm(1000)
  y <- x + rnorm(1000) * spread
  plot(x, y, pch = ".", col = "red")
})

output$t1_plot1 <- renderPlot({

  data <- histdata[seq(1, 10)]
  color <- "red"
  if (color == "none")
    color <- NULL
  hist(data, col = color, main = NULL)
})
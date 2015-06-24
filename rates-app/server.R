library(shiny)
source('03-graphs.R')


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    #x    <- faithful[, 2]  # Old Faithful Geyser data
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    current_rate <- get_current_rate()
    if(current_rate == input$target_rate) {
      # Don't show a plot
      par(mar = c(0,0,0,0))
      plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n',
           xaxt = 'n', yaxt = 'n')
      text(x = 0.5, y = 0.5, paste("No change"), cex = 1.6, col = "black")
    } else {
      par(par.default)
      par(las=2)
      barplot(calculate_probs(prices, current_rate, input$target_rate)$p_change, 
              names.arg = strftime(prices$Meeting.Month, format = '%b-%y',),
              main=pretty_title(current_rate, input$target_rate))
    }
  })
})
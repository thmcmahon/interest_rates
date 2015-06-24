source('02-analysis.R')

par.default <- par()


pretty_title <- function(current_rate, target_rate) {
  # Make a pretty title
  cut_binary <- ifelse(current_rate < target_rate, 'rise', 'cut')
  bp <- abs(current_rate - target_rate) * 100
  paste('Probability of a ', bp, ' basis point rate ', cut_binary, sep='')
}


create_graph <- function(current_rate, target_rate) {
  # Create a sick bar chart
  if(current_rate == target_rate) {
    # Don't show a plot
    par(mar = c(0,0,0,0))
    plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n',
         xaxt = 'n', yaxt = 'n')
    text(x = 0.5, y = 0.5, paste("No change"), cex = 1.6, col = "black")
  } else {
    par(par.default)
    par(las=2)
    barplot(calculate_probs(prices, current_rate, target_rate)$p_change, 
            names.arg = strftime(prices$Meeting.Month, format = '%b-%y',),
            main=pretty_title(current_rate, target_rate))
  }         
}
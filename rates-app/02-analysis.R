source('01-prep_data.R')


month_prop <- function(days, days_in_month) {
  # A function to show what proportion X days represents as a proportion of
  # days in the month
  return(as.integer(days) / as.integer(days_in_month))
}


rate_to_yield <- function(rate) {
  # Convert rates into yield e.g. interest rate of 1.75% is expressed as 98.25
  return(100 - rate)
}


probability_of_change <- function(trading_price, current_rate, implied_yield) {
  # Probability of change is the ratio of:
  # difference between the trading price and the current price and
  # the market adjusted implied yield
  p_change <- (trading_price - current_rate) / implied_yield
  return(p_change)
}


calculate_probs <- function(prices, current_rate, target_rate) {
  # Calculate the price using the proportion before the meeting * current price
  # plus the proportion after * target price minus the current price to see 
  # the difference between current prices and future expectations
  
  # Convert rates
  current_rate <- rate_to_yield(current_rate)
  target_rate <- rate_to_yield(target_rate)

  # Do the maths
  price_before <- month_prop(prices$days_before, prices$days_total) * current_rate
  price_after <- month_prop(prices$days_after, prices$days_total) * target_rate
  prices$implied_yield <- (price_before + price_after) - current_rate
  
  # Add probability of change
  prices$p_change <- probability_of_change(
                     trading_price = prices$Trading.Price,
                     current_rate = current_rate,
                     implied_yield = prices$implied_yield)
  return(prices)
}
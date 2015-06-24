library(rvest) # for the scraping
library(lubridate)
library(timeDate) # to get the second Tuesday of the month
library(magrittr)

get_prices <- function() {
  # Download price data and return as dataframe
  price_url <- 'http://www.sfe.com.au/content/prices/rtp15SFIB.html'
  price_data <- html(price_url) %>%
                html_nodes(".data table") %>%
                html_table(header=TRUE)
  price_data <- as.data.frame(price_data)
  
  # Add a trading price variable if it exists or compute it
  price_data$Trading.Price <- ifelse(!is.na(as.double(price_data$Last.Trade)), 
                                     as.double(price_data$Last.Trade),
                                     (price_data$Bid + price_data$Ask) / 2)
  return(as.data.frame(price_data))
}


add_datetime <- function(prices) {
  # Date and Time are spread across columns this combines and then
  # converts to a lubridate object
  prices$Last.Trade.DateTime <- dmy_hm(paste(prices$Last.Trade.Date,
                                       prices$Last.Trade.Time,
                                       sep = " "))
  return(prices)
}

add_rba_meeting_date <- function(prices) {
  # The RBA meets on the first Tuesday of the month
  # http://www.rba.gov.au/schedules-events/calendar-2015.html

  # Add a `1` to the Expiry variable to create the meeting date variable
  # 2 is for second day of the week i.e. Tuesday
  prices$Meeting.Month <- dmy(paste('1', prices$Expiry))
  prices$Meeting.Date <- timeNthNdayInMonth(prices$Meeting.Month,
                                            2) # 1 = Monday, 2 = Tuesday etc.
  return(prices)
}

add_days <- function(prices) {
  # Necessary for calculating pre and post prices
  prices$days_after <- timeLastDayInMonth(prices$Meeting.Month) - prices$Meeting.Date
  prices$days_before <- difftime(prices$Meeting.Date, prices$Meeting.Month,
                            units="days") + 1
  # Total days is number before plus after plus one for the actual meeting day
  prices$days_total <- prices$days_before + prices$days_after
  return(prices)
}

get_current_rate <- function() {
  return(2)
}

# Main
prices <- get_prices() %>%
  add_datetime %>%
  add_rba_meeting_date %>%
  add_days()
          
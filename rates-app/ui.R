library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Market expectation of RBA cash rate change",
             windowTitle = "RBA cash rate forecast"),
  
  mainPanel(width = 6,
    # Graph
    fluidRow(align="center",
      plotOutput("distPlot"),
      sliderInput("target_rate",
                  "Interest Rate:",
                  min = 0,
                  max = 5,
                  step = .25,
                  value = 1.75)
    ),
    
    # Explanation
    fluidRow(
      h2('How does this work?'),
      p('This  interactive graph shows the market\'s expectation of a change 
        in the RBA cash rate. You can adjust the slider to examine the 
        market\'s view as to how likely a particular change would be in a
        give month.'),
      p('The market in question is the ASX 30-Day Interbank Cash Rate Futures
        contract. Its prices show how likely market participants believe
        it is that the cash rate will increase or decrease.'),
      p('This market provides a helpful alternative to pundits that do not have
        any skin in the game when it comes to their predictions.'),
      
      h2('How is this calculated?'),
      p('Interest rate futures are quoted as 100 yield, so an RBA cash rate
        of 2% is quoted as 98 (100 - 2 = 98). But examining the price for
        a given month is not sufficient, as in any month there is a period
        where the price is known (before the RBA sits we know the rate), and
        a period where the price is unknown (after the RBA sits).'),
      p('So we need to adjust this price to account for the proportion of the
        month where the price is known. Luckily we know that the RBA meets
        on the first Tuesday of the month. So we can then adjust the price
        to determine the price for the unknown period.'),
      p('Once we have this price, we subtract the actual current
        rate. The difference shows the market\'s expectation
        of change.'),
      p('For further information,',
        a(href="http://github.com/thmcmahon/interest_rates",
          'check out the code'),
        'or if you\'re into maths, you can check out the ASX\'s formula at:',
        a(href="http://www.asx.com.au/prices/targetratetracker.htm",
          'ASX Target Rate Tracker.')),
      
      h2('Feedback'),
      p("If you'd like to provide feedback or have questions, feel free to
        get in touch on twitter",
        a(href="http://twitter.com/thmcmahon", '@thmcmahon.')),
      
      h2('Acknowledgements'),
      p("I found the following useful in understanding how this all works:"),
      tags$ul(
        tags$li(a(href='http://www.theaustralian.com.au/business/wealth/handy-rate-tracker-ase-30-day-interbank-cash-rate/story-e6frgac6-1225757911860',
                  'The Australian: Handy Rate Tracker')),
        tags$li(a(href='http://calebennett.com/', 'calebennett.com')))
    )
  )
)
)
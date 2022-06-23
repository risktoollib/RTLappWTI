#' fundies UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_fundies_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h5(tags$span(style = "color:aqua;font-style: italic;font-size:0.8em", "Global EIA STEO Oil Balances")),
    plotly::plotlyOutput(ns("steoPlot"))

  )
}

#' fundies Server Functions
#'
#' @noRd
mod_fundies_server <- function(id,r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$steoPlot <- plotly::renderPlotly({
      r$steoPlot
    })


  })
}

## To be copied in the UI
# mod_fundies_ui("fundies_1")

## To be copied in the server
# mod_fundies_server("fundies_1")

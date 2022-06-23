#' utilization UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_utilization_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h5(tags$span(style = "color:aqua;font-style: italic;font-size:0.8em", "Storage Utilization and c1c2 Spread Dynamics")),
    plotly::plotlyOutput(ns("utilization"))
  )
}

#' utilization Server Functions
#'
#' @noRd
mod_utilization_server <- function(id,r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$utilization <- plotly::renderPlotly({
      r$utilization
    })

  })
}

## To be copied in the UI
# mod_utilization_ui("utilization_1")

## To be copied in the server
# mod_utilization_server("utilization_1")

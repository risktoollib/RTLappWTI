#' betas UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_betas_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h5(tags$span(style = "color:aqua;font-style: italic;font-size:0.8em", "WTI Futures Betas to 1st Line contract")),
    plotly::plotlyOutput(ns("betas"))


  )
}

#' betas Server Functions
#'
#' @noRd
mod_betas_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$betas <- plotly::renderPlotly({
      r$betas
    })


  })
}

## To be copied in the UI
# mod_betas_ui("betas_1")

## To be copied in the server
# mod_betas_server("betas_1")

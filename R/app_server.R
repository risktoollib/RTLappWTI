#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  r <- shiny::reactiveValues()
  mod_compute_server("compute_1", r = r)
  mod_fundies_server("fundies_1", r = r)
  mod_betas_server("betas_1", r = r)
  mod_utilization_server("utilization_1", r = r)
}

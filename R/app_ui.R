#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::fluidPage(
    theme = bslib::bs_theme(version = 5,
                            bg = "#333333", # 626C70
                            fg = "White",
                            primary = "Cyan",
                            heading_font = bslib::font_google("Prompt"),
                            base_font = bslib::font_google("Prompt"),
                            code_font = bslib::font_google("JetBrains Mono"),
                            "progress-bar-bg" = "lime"),
    golem_add_external_resources(),
    # UI logic
    shiny::fluidRow(shiny::column(8, titlePanel("Global Oil Balances & WTI Market")),
                    shiny::column(4, align = "right",tags$h5(
                      tags$span(style = "color:White;;font-size:0.8em;font-style:italic", "created by pcote@ualberta.ca"),
                      tags$a(href = "https://www.linkedin.com/in/philippe-cote-88b1769/", icon("linkedin", "My Profile", target = "_blank"))
                    ))),
    shiny::fluidRow(
      tags$ul(
        tags$li(tags$span(style = "color:lime;font-size:1.0em", "You need to input your EIA API Key. https://www.eia.gov/opendata/ if you don't have one.")),
        tags$li(tags$span(style = "color:lime;font-size:1.0em", "Early WIP ... contact pcote or Bryan for ideas"))
      )),
    mod_compute_ui("compute_1"),
    shiny::tabsetPanel(
      type = "tabs",
      shiny::tabPanel("Fundamentals", mod_fundies_ui("fundies_1")),
      shiny::tabPanel("Futures betas", mod_betas_ui("betas_1")),
      shiny::tabPanel("Utilization", mod_utilization_ui("utilization_1"))
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "RTLappWTI"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

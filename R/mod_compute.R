#' compute UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_compute_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidPage(
      shiny::fluidRow(
        shiny::column(4,shiny::textInput(inputId = ns("eiaKey"),label = "EIA API Key:", value = "NfivbHasatuaGKdMkbh41RIqWNDPJTfdwVQZxs6n")),
        shiny::column(8,shiny::numericInput(ns("days"),"Number of days for Betas (0 for all):", value = "0",min = 0,max = 500,step = 20))
      )
    )
  )
}

#' compute Server Functions
#'
#' @noRd
mod_compute_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    shiny::observeEvent(c(input$eiaKey,input$days),{

      x <- series <- CL01 <- CL02 <- c1c2 <- value <- capacity <- stocks <- server <- product <- NULL

      r$eiaKey <- shiny::req(input$eiaKey)
      r$days <- ifelse(input$days == 0, "all",as.character(input$days))
      r$steoPlot <- RTL::chart_eia_steo(key = r$eiaKey)
      #r$steoData <- RTL::chart_eia_steo(key = r$eiaKey, output = "data")
      r$stocks <- RTL::eia2tidy(ticker = "PET.W_EPC0_SAX_YCUOK_MBBL.W", key = r$eiaKey, name = "stocks")
      r$futs <- RTL::dfwide %>%
        dplyr::transmute(date,CL01,CL02,c1c2 = CL01 - CL02)

      r$utilization <- rbind(r$stocks, RTL::eiaStorageCap %>% dplyr::filter(series == "Cushing") %>% dplyr::select(-product)) %>%
        tidyr::pivot_wider(names_from = series, values_from = value) %>%
        dplyr::arrange(date) %>%
        dplyr::rename(stocks = 2, capacity = 3) %>%
        tidyr::fill(capacity) %>%
        tidyr::drop_na() %>%
        dplyr::mutate(utilization = stocks / capacity,
                      year = lubridate::year(date)) %>%
        dplyr::left_join(r$futs %>% dplyr::select(date, c1c2)) %>%
        tidyr::drop_na() %>%
        plotly::plot_ly(
          x = ~c1c2 ,
          y = ~utilization,
          #name = ~ series,
          color = ~year,
          type = "scatter",
          mode = "markers"
        ) %>%
        plotly::layout(
          title = list(text = "Front Spread Market Structure vs Storage Utlization", x = 0),
          xaxis = list(title = "Front Spread Structure", tickformat = "$.1f"),
          yaxis = list(title = "Cushing Storage Utilization", tickformat = ".0%")
        )

      # data for promptBeta from RTL dataset - replace with company specific API for live update

      x <- RTL::dflong %>%
        dplyr::filter(grepl("CL", series)) %>%
        dplyr::mutate(series = readr::parse_number(series)) %>%
        dplyr::group_by(series)
      x <- RTL::returns(df = x, retType = "abs", period.return = 1, spread = TRUE)
      x <- RTL::rolladjust(x = x, commodityname = c("cmewti"), rolltype = c("Last.Trade"))
      r$dataFuts <- x %>% dplyr::filter(!grepl("2020-04-20|2020-04-21", date))

      r$betas <- RTL::promptBeta(x = r$dataFuts, period = r$days, output = "chart")

      })

  })
}

## To be copied in the UI
# mod_compute_ui("compute_1")

## To be copied in the server
# mod_compute_server("compute_1")

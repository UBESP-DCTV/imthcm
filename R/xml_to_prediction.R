#' Read an XML predicted data
#'
#' @param file [chr] path to the XML predicted file to import (e.g. the
#'   output of hm.R)
#'
#' @return a data frame of predicted data
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   default_models <- train_event_models(use_ita = TRUE)
#'   pred <- predict_hm(default_models,
#'     test_weather, test_weather[c(730L, 731L), ]
#'   )
#'   predictions_to_xml(pred, file = 'predictions.xml')
#'   imported_pred <- xml_to_prediction(file = 'predictions.xml')
#'   identical(pred, imported_pred)
#' }
xml_to_prediction <- function(file) {
  xml_data <- here::here(file) %>%
    xml2::read_xml() %>%
    xml2::as_list()

  xml_data[[1]] %>%
    purrr::map_df(~{
      attributes(.x) %>% dplyr::as_data_frame() %>%
        dplyr::bind_cols(
          purrr::map_df(.x,
            function(details) {attributes(details) %>%
                dplyr::as_data_frame()}
          )
        )
    }) %>%
  dplyr::mutate(date = lubridate::ymd(date)) %>%
  dplyr::mutate_at(dplyr::vars(-c(date, names)), as.integer) %>%
  dplyr::rename(event = names) %>%
  dplyr::select(date, dplyr::everything())
}



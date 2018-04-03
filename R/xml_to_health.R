#' Read an XML Health data
#'
#' @param file [chr] path to the XML health file to import
#'
#' @return a data frame of health data
#' @export
#'
#' @examples
#' library(imthcm)
#' \dontrun{
#'   data(test_health)
#'   xml_health <- 'test_health.xml'
#'   health_to_xml(test_health, file = xml_health)
#'   events_history <- xml_to_health(file = xml_health)
#'   identical(events_history, test_health)
#' }
xml_to_health <- function(file) {
  xml_data <- file %>%
    xml2::read_xml() %>%
    xml2::as_list()

  xml_data[[1]] %>%
    purrr::map_df(~{
      attributes(.x) %>% dplyr::as_data_frame()
    }) %>%
    dplyr::mutate_at(dplyr::vars(-date), as.integer) %>%
    dplyr::mutate(date = lubridate::ymd(date))
}



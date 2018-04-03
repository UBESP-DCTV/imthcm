#' Read an XML weather data
#'
#' @param file [chr] path to the XML weather file to import
#'
#' @return a data frame of weather data
#' @export
#'
#' @examples
#' library(imthcm)
#' \dontrun{
#'   data(test_weather)
#'   xml_weather <- 'test_weather.xml'
#'   weather_to_xml(test_weather, file = xml_weather)
#'   weather_history <- xml_to_weather(file = xml_weather)
#'   identical(weather_history, test_weather)
#' }
xml_to_weather <- function(file) {
  xml_data <- file %>%
    xml2::read_xml() %>%
    xml2::as_list()

  xml_data[[1]] %>%
    purrr::map_df(~{
      attributes(.x) %>% dplyr::as_data_frame()
    }) %>%
    dplyr::mutate_at(dplyr::vars(-date), as.double) %>%
    dplyr::mutate(date = lubridate::ymd(date))
}



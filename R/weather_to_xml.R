#' Convert weather data to XML
#'
#' This function aims to convert weather data from data a frmae to XML
#' format.
#' @param weather_data a data frame of historical weather data.
#' @param file [chr] (default is NULL) if provided as
#'             \code{"path/to/xml/output/xml"} the function write the
#'             XML in this file (note: folder must be exists).
#'
#' @return an (invisible) XML document
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
weather_to_xml <- function(weather_data, file = NULL) {
  weather_nested <- weather_data %>%
    dplyr::mutate(row_id = dplyr::row_number(date)) %>%
    dplyr::group_by(row_id) %>%
    tidyr::nest()

  weather_list <- purrr::map(weather_nested[['data']], ~{
    container <- structure(list())
    attributes(container) <- as.list(.x)
    container
  }) %>%
    magrittr::set_names(rep('environmental', nrow(weather_data)))

  weather_xml <- list(weather_history = weather_list) %>%
    xml2::as_xml_document()

  # Provide and possibly write the output -------------------------------

  if (!is.null(file)) xml2::write_xml(x = weather_xml, file = file)
  invisible(weather_xml)
}

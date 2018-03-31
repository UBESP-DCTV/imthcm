#' Convert health data to XML
#'
#' This function aims to convert health data from data a frmae to XML
#' format.
#' @param health_data a data frame of health data, i.e. events occurred each
#'             day in the history known.
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
#'   data(test_health)
#'   xml_health <- 'test_health.xml'
#'   health_to_xml(test_health, file = xml_health)
#'   events_history <- xml_to_health(file = xml_health)
#'   identical(events_history, test_health)
#' }
health_to_xml <- function(health_data, file = NULL) {
  health_nested <- health_data %>%
    dplyr::mutate(row_id = dplyr::row_number(date)) %>%
    dplyr::group_by(row_id) %>%
    tidyr::nest()

  health_list <- purrr::map(health_nested[['data']], ~{
    container <- structure(list())
    attributes(container) <- as.list(.x)
    container
  }) %>%
    magrittr::set_names(rep('events', nrow(health_data)))

  health_xml <- list(health_history = health_list) %>%
    xml2::as_xml_document()

  # Provide and possibly write the output -------------------------------

  if (!is.null(file)) xml2::write_xml(x = health_xml, file = file)
  invisible(health_xml)
}

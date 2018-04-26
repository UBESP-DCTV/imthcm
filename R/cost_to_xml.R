#' Convert cost data to XML
#'
#' This function aims to convert cost data from data a frmae to XML
#' format.
#' @param cost_data a data frame of cost data, i.e. individual cost per
#'             event considered.
#' @param file [chr] (default is NULL) if provided as
#'             \code{"path/to/xml/output/xml"} the function write the
#'             XML in this file (note: folder must be exists).
#'
#' @return an (invisible) XML document
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   data(meps_costs)
#'   xml_cost <- 'test_cost.xml'
#'   cost_to_xml(meps_costs, file = xml_cost)
#'   converted_costs <- xml_to_cost(file = xml_cost)
#'   identical(converted_costs, meps_costs)
#' }
cost_to_xml <- function(cost_data, file = NULL) {
  cost_nested <- cost_data %>%
    dplyr::mutate(row_id = dplyr::row_number(event)) %>%
    dplyr::group_by(row_id) %>%
    tidyr::nest()

  cost_list <- purrr::map(cost_nested[['data']], ~{
    container <- structure(list())
    attributes(container) <- as.list(.x)
    container
  }) %>%
    magrittr::set_names(rep('cost', nrow(cost_data)))

  cost_xml <- list(costs = cost_list) %>%
    xml2::as_xml_document()

  # Provide and possibly write the output -------------------------------

  if (!is.null(file)) xml2::write_xml(x = cost_xml, file = file)
  invisible(cost_xml)
}

#' Read an XML cost data
#'
#' @param file [chr] path to the XML cost file to import
#'
#' @return a data frame of cost data
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
xml_to_cost <- function(file) {
  xml_data <- file %>%
    xml2::read_xml() %>%
    xml2::as_list()

  xml_data[[1]] %>%
    purrr::map_df(~{
      attributes(.x) %>% dplyr::as_data_frame()
    }) %>%
    dplyr::mutate_at(dplyr::vars(individual_cost), as.double)
}

#' Convert predictions to XML
#'
#' This function aims to convert prediction from Health Module to XML format
#' @param pred a dataframe of prediction, i.e. a output from
#'             \code{\link{predict_hm}}.
#' @param file [chr] (default is NULL) if provided as
#'             \code{"path/to/xml/output/xml"} the function write the
#'             XML in this file (note: folder must be exists).
#'
#' @return an (invisible) XML document
#' @export
#'
#' @examples
#' library(imthcm)
#' default_models <- train_event_models(use_ita = TRUE)
#' pred <- predict_hm(default_models,
#'   test_weather, test_weather[c(730L, 731L), ]
#' )
#' predictions_to_xml(pred)
#' \dontrun{
#'   predictions_to_xml(pred, file = 'predictions.xml')
#' }
predictions_to_xml <- function(pred, file = NULL) {


# Main list creation --------------------------------------------------

  ## to create an XML you have to provide a possible empty list with
  ## attributes, names of attributes becam entry and value of them become
  ## the value in the XML. You have also to provide a lis with only one
  ## head element (named) for the principal node, and each child have to
  ## be a named and have to be also a (named) list...
  pred_list <- pred %>%
    dplyr::group_by(date) %>%
    tidyr::nest() %>%                               # one list for each date
    dplyr::transmute(data = magrittr::set_names(data, date)) %>%  # w/ names
    dplyr::mutate(
      data = data %>% purrr::map(~.x %>%                # inside each "date"
        dplyr::group_by(event) %>%
        tidyr::nest() %>%                          # one list for each event
        dplyr::transmute(
          data  = data %>% purrr::map(    # for the moment we create a named
            ~magrittr::set_names(                            # double vector
              list(.x$lower, .x$fit, .x$upper),
              c('lower', 'fit', 'upper')
            )
          ) %>%
          magrittr::set_names(event)
        ) %>% as.list   # we have to convert the nested data frame in a list
      ) %>% unlist(recursive = FALSE) # but the upper level is redundant and
    ) %>%                                               # have to be removed
    dplyr::mutate( # removing using `unlist` attach the previous name to the
      data = data %>% # actual onces (the dates). So, we have to remove them
        magrittr::set_names(stringr::str_remove_all(names(data), '\\.data$'))
    ) %>%
    as.list       # finally we have to convert the main data frame to a list


# XML conversion ------------------------------------------------------

  ## First of all we store the name of each records (i.e., the dates)
  pred_date <- names(pred_list[[1]])

  ## next we start to create the structure for the XML we start with purr
  ## because the head node has (as requested) only one main node, so
  ## all the prdictions are inside
  xml_output <- purrr::map(pred_list, ~.x %>%
    purrr::map2(pred_date, function(prediction, obs_name) {
      prediction %>%  # inside each prediction create an empty list with the
      purrr::map(function(event) {     # desired attributs, i.e. the content
        structure(list(),      # of the stored vectror, i.e. the predictions
          lower = event$lower, fit = event$fit, upper = event$upper
        )
      }) %>%
      structure(date = obs_name)  # next we name the overall prediction with
    }) %>%                                          # the corresponding name
    magrittr::set_names(rep('prediction', length(.)))
  ) %>%
  magrittr::set_names('predictions') %>%
  xml2::as_xml_document()


# Provide and possibly write the output -------------------------------

  if (!is.null(file)) xml2::write_xml(x = xml_output, file = file)
  invisible(xml_output)
}

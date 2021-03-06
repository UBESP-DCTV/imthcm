#' Events model trainer
#'
#' This function trains models that estimate the average daily number of
#' events.
#'
#' The output is a list of three lists, named \code{summer},
#' \code{non_summer} and \code{full_year}. The first two are used if
#' ozone data are provided. They refer to a specific set of models that
#' consider also the ozone in summer period and only other pollutants in the
#' rest of the year. The last set (i.e., list) refers to a model that is
#' used if any knowledge about ozone concentrations is provided.
#'
#'
#' @param health_events_history A data frame with historical health events
#'        data. At least one week for each month for at least one year (full
#'        years are obviusly preferrend) are needed in order to take into
#'        account seasonal trends. Colum names must be included in:
#'        - mort_all     = daily number of death (any causes);
#'        - mort_cardiac = daily number of death (cardiac causes only);
#'        - mort_resp    = daily number of death
#'          (respiratory casues only);
#'        - mort_cer     = daily number of death
#'          (cerebrovascular causes only);
#'        - hosp_cardiac = daily number of hospitalization (cardiac
#'          causes only);
#'        - hosp_resp    = daily number of hospitalization
#'          (respiratory casues only);
#'        - hosp_cer     = daily number of hospitalization
#'          (cerebrovascular causes only);
#'
#' @param weather_history [data frame] A data frame with weather historical
#'        data with number of rows equal to the lenght of
#'        \code{health_events_history} and at least the following column
#'        (with exactly the same column names):
#'        - date           = date expressed in the format 'yyyy-mm-dd';
#'        - temp_mean      = mean temperature of corresponding day
#'                           (Celsius);
#'        - press_bar_mean = mean pressure of corresponding day (hPascal);
#'        - pm10           = mean value of pm10 of corresponding day
#'                           (\eqn{\mu g/m^3});
#'        - pm25           = mean value of pm25 of corresponding day
#'                           (\eqn{\mu g/m^3});
#'        - no2            = mean value of no2  of corresponding day
#'                           (\eqn{\mu g/m^3}).
#'
#'        If provided, by a column named \code{038h}, also information
#'        of O3 daily maximum concentration for the daily 8-hours
#'        moving-means will be used (only for summer period, i.e., from
#'        April, 1st, to September, 30th).
#'
#' @param ... Other possible options passed to the function
#' @param use_ita [lgl] (default = FALSE) use italian historical
#'        data on weather if the user cannot provide more specific data.
#'
#' @return a list of three sets of gam models, one set with the summer model
#'         for each type of event provided in \code{health_events_history}
#'         (taking into account also information from O3), one set for the
#'         non-summer models (using only non-O3 pollutant information) and
#'         a set of full-year models which do not use information on O3
#'         (if not provided). Together all the model of the first two sets
#'         or the models of the third set are alternative \code{NULL}.
#'         Output is returned \code{invisible()}. See Details section for
#'         more informations.
#'
#' @import mgcv
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   test_models    <- train_event_models(test_health, test_weather)
#'   default_models <- train_event_models(use_ita = TRUE)
#' }


train_event_models <- function(health_events_history = NULL,
                               weather_history = NULL,
                               ...,
                               use_ita = FALSE
){


  # Standard output -----------------------------------------------------

  assertive::assert_is_a_bool(use_ita)

  if (use_ita) {
    return(event_models_ita)
  }


  # Input check ---------------------------------------------------------

  assertive::assert_is_inherited_from(health_events_history, 'data.frame')
  assertive::assert_is_inherited_from(weather_history,       'data.frame')
  assertive::assert_all_are_equal_to(
    nrow(weather_history),
    nrow(health_events_history)
  )

  events <- intersect(
    c(
      'mort_all', 'mort_cardiac', 'mort_resp', 'mort_cer',
      'hosp_cardiac', 'hosp_resp', 'hosp_cer'
    ),
    names(health_events_history)
  ) %>%
    purrr::set_names(.)


  assertive::assert_all_are_true(length(events) != 0)

# Run -----------------------------------------------------------------


  # Weather preprocessing to compute lags
  weather_data <- weather_history %>%
    weather_preproc()

  # full dataset
  health_events_data <- dplyr::left_join(
    weather_data,
    health_events_history
  )

  polluts <- paste0("lag_03_", c("pm10", "pm25", "no2", "o38h")) %>%
      intersect(names(weather_data)) %>%
      purrr::set_names(.)

  polluts_no_o38h <- setdiff(polluts, "lag_03_o38h") %>%
      purrr::set_names(.)

  vars_to_consider <- c(events, polluts,
    "temp_mean", "press_bar_mean",
    "date", "day", "year", "month", "day_week",
    "pm10", "pm25", "no2", "o38h"
  )

  train_data <- health_events_data[vars_to_consider] %>%
      dplyr::mutate(is_summer = month %in% c(4, 5, 6, 7, 8, 9)) %>%
      ###
      ### 20191125: Problemi di se che esplodono, possibile che sia per
      ### mancanza di dati. Provo a rimuovere questo filtro per avere
      ### più dati su cui fare il fit. In ogni modo, il modello ora
      ### dovrebbe tenere correttamente conto anche delle
      ### sovradispersioni.
      ###
      # dplyr::filter_at(c(polluts, "pm10", "pm25", "no2", "o38h"),
      #     dplyr::all_vars(. <= upper_2iqr(.))
      # ) %>%
      ggplot2::remove_missing()

  train_summer_data <- dplyr::filter(train_data, is_summer)
  train_non_summer_data <- dplyr::filter(train_data, !is_summer)


  # Train for full year data
    message("Full Year model evaluation.")
    full_year <- events %>%
        fit_hm(polluts, train_data) %>%
        stats::setNames(events)


  # check for O3 presence
  if (all(is.na(weather_history[['o38h']]))) {

    summer <- vector('list', length(events)) %>% stats::setNames(events)
    non_summer <- summer

  } else {

    # Summer model
    message("Summer model evaluation.")
    summer <- events %>%
        fit_hm(polluts, train_summer_data) %>%
        stats::setNames(events)

    # Non-summer model
    message("Non-summer model evaluation.")
    non_summer <- events %>%
        fit_hm(polluts_no_o38h, train_non_summer_data) %>%
        stats::setNames(events)

  }




# Output return -------------------------------------------------------

  invisible(list(
    summer     = summer,
    non_summer = non_summer,
    full_year  = full_year
  ))
}

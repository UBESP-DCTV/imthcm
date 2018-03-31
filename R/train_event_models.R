#' Events model trainer
#'
#' A function that trains models to estimates the average daily number of
#' events.
#'
#' The output is a list of three lists, named \code{summer},
#' \code{non_summer} and \code{full_year}. The first two are usefull if
#' ozone data are provided to assess a more specific model considering
#' also ozone in summer period and only other pollutants in the rest of the
#' year. The last set (i.e., list) of models are trained and aimed to be
#' used without any knowledge about ozone concentrations.
#'
#'
#' @param health_events_history A data frame with historical health events
#'        data for at least one month (one year is preferred to take into
#'        account the stagionality). Colum names must be included in:
#'        - mort_all     = for daily number of death (any causes);
#'        - mort_cardiac = for daily number of death (cardiac causes only);
#'        - mort_resp    = for daily number of death
#'          (respiratory casues only);
#'        - mort_cer     = for daily number of death
#'          (cerebrovascular causes only);
#'        - hosp_cardiac = for daily number of hospitalization (cardiac causes only);
#'        - hosp_resp    = for daily number of hospitalization
#'          (respiratory casues only);
#'        - hosp_cer     = for daily number of hospitalization
#'          (cerebrovascular causes only);
#'
#' @param weather_history [data frame] A data frame with weather historical
#'        data with number of rows equal to the lenght of
#'        \code{health_events_history} and at least the following column (with
#'        exactly the same column names):
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
#'        moving-mean will be used (only for summer period, i.e., from
#'        April, 1st, to September, 30th).
#'
#' @param ... Other possible options passed to the function
#' @param use_ita [lgl] (default = FALSE) use italian historical
#'        data on weather if the user cannot provide more specific data.
#'
#' @return a list of three sets of gam models, one set with the summer model
#'         for each type ov event provided in \code{health_events_history}
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


# Input check ---------------------------------------------------------

# assertive::assert_is_inherited_from()

# Run -----------------------------------------------------------------


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

  events_considered <- intersect(
    c(
      'mort_all', 'mort_cardiac', 'mort_resp', 'mort_cer', 'hosp_cardiac',
      'hosp_resp', 'hosp_cer'
    ),
    names(health_events_history)
  ) %>%
    magrittr::set_names(., .)


  assertive::assert_all_are_true(events_considered != character(0L))

# Run -----------------------------------------------------------------


  # Weather preprocessing to compute lags
  weather_data <- weather_history %>%
    weather_preproc()

  # full dataset
  health_events_data <- dplyr::left_join(
    weather_data,
    health_events_history
  )



  # Train for full year data
  full_year  <- purrr::map(events_considered,
    ~ mgcv::gam(
      formula = stats::as.formula(glue::glue({.x}, " ~ dd + lag_03_pm25 +
        s(temp_mean, bs = 'cr') + s(press_bar_mean, bs = 'cr')"
      )),
      data    = health_events_data,
      family  = stats::quasipoisson()
    )
  )


  # check for O3 presence
  if (all(is.na(weather_history[['o38h']]))) {
    summer     <- stats::setNames(
      vector('list', length(health_events_history)),
      events_considered
    )
    non_summer <- stats::setNames(
      vector('list', length(health_events_history)),
      events_considered
    )
  } else {

    # split summer and non-summer data
    health_events_data <- health_events_data %>%
      dplyr::mutate(
        is_summer = (month >= 4) & (month <= 9)
    )

    # Summer model
    summer  <- purrr::map(events_considered,
      ~ mgcv::gam(
        formula = stats::as.formula(glue::glue({.x},
          " ~ dd + lag_03_pm25 + lag_03_o38h +",
          "   s(temp_mean, bs = 'cr')  +",
          "   s(press_bar_mean, bs = 'cr')"
        )),
        data    = dplyr::filter(health_events_data, is_summer) %>%
          dplyr::select(-is_summer) %>%
          as.data.frame(),
        family  = stats::quasipoisson()
      )
    )

    # Non-summer model
    non_summer  <- purrr::map(events_considered,
      ~ mgcv::gam(
        formula = stats::as.formula(glue::glue({.x},
          " ~ dd + lag_03_pm25 +",
          "   s(temp_mean, bs = 'cr')  +",
          "   s(press_bar_mean, bs = 'cr')"
        )),
        data    = dplyr::filter(health_events_data, !is_summer) %>%
          dplyr::select(-is_summer) %>%
          as.data.frame(),
        family  = stats::quasipoisson()
      )
    )
  }





# Output return -------------------------------------------------------

  invisible(list(
    summer     = summer,
    non_summer = non_summer,
    full_year  = full_year
  ))
}

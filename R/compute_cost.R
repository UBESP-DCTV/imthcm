#' Compute costs of related health events
#'
#' This function computes the costs associated the cardiac and respiratory
#' hospitalizations. Individual available costs were associated to stroke
#' occurrence and Congenital Hearth Diseases (CHD) for cardiac events,
#' whereas they were associated to Chronic obstructive pulmonary disease
#' (COPD).
#'
#'
#' The output of the function is a data frame. The data frame is composed
#' by simulated days: n rows and 6 columns. Each row gives the fitted
#' number, with relative 95% CI, of the considered health outcomes and
#' relavite costs. Each column represents respectively the date of the
#' simulated day, the health outcomes, the 95% CI lower bound of the
#' predicted average daily number of events, the predicted average daily
#' number of events and the the 95% CI upper bound of the predicted average
#' daily number of events, the 95% CI lower bound of costs associated to a
#' particular health events, the average daily costs associated to a
#' particular health event and the 95% CI upper bound of costs associated
#' to a particular health events.
#'
#'
#' @param health_events A data frame with predicted health events
#'        and relative 95% CI. Column names must be:
#'          - `date`  = date of the simulated day;
#'          - `event` = type of event (e.g. mortality for all causes,
#'                           hospitalizations for cardiac events, ...);
#'          - `lower` = lower bound of 95% CI of average daily number
#'                           of considered health event;
#'          - `fit`   = average daily number of considered health
#'                           event;
#'          - `upper` = upper bound of 95% CI of average daily number
#'                           of considered health event.
#' @param costs A data frame with the related individual costs for events in
#'        `health_events`. Column names must be:
#'          - `event`           = events name as they appear in
#'                                     `health_event`;
#'          - `individual_cost` = individual costs for the related
#'                                     events;
#'          - `currences`       = currences in which each cost is
#'                                     expressed.
#'
#' @param ... Other possible options passed to the function
#' @param use_meps [lgl] (default = FALSE) use Medical Expenditure Panel
#'        Survey (MEPS) of the U.S. Agency for Healthcare Research and
#'        Quality costs data on weather if the user cannot provide more
#'        specific data.
#'
#' @return a data frame with `n_days` * `n` rows (where
#'         `n_days` is the number of simulated days, and `n` is
#'         the number of events for which a cost was provided), and 7
#'         columns:
#'           - `date` for which the record is referred,
#'           - `event` the event considered
#'           - `currences` the currences used for the cost
#'           - `lower_individual_cost` the 95% CI lower bound of the
#'             cost
#'           - `fit_individual_cost` the median cost
#'           - `upper_individual_cost` the 95% CI upper bound of the
#'             cost
#'
#' @export
#'
#'
#' @examples
#' \dontrun{
#' library(imthcm)
#' default_models <- train_event_models(use_ita = TRUE)
#'
#' hh_non_summer <- predict_hm(models = default_models,
#'   weather_history = test_weather,
#'   weather_today   = test_weather[731L, ]
#' )
#'
#' hh_full_year <- predict_hm(models = default_models,
#'   weather_history = test_weather,
#'   weather_today   = test_weather[c(731L, 730L), ],
#'   full_year = TRUE
#' )
#'
#' compute_cost(hh_non_summer, use_meps = TRUE)
#' compute_cost(hh_non_summer, costs = meps_costs)
#'
#' compute_cost(hh_full_year, use_meps = TRUE)
#' compute_cost(hh_full_year, costs = meps_costs)
#' }


# Compute costs ----------------------------------------------------------
compute_cost <- function(health_events, costs = NULL, ...,
    use_meps = is.null(costs)){


  # Input check ---------------------------------------------------------

  assertive::assert_is_inherited_from(health_events, 'data.frame')
  if (!is.null(cost)) {
    assertive::assert_is_inherited_from(costs, 'data.frame')
  } else {
    assertive::assert_all_are_true(use_meps)
  }
  assertive::assert_is_a_bool(health_events)


  if (use_meps) {
    costs <- meps_costs
  }

  health_events %>%
    dplyr::right_join(costs) %>%
    dplyr::mutate(
      lower_individual_cost = lower * individual_cost,
      fit_individual_cost   = fit   * individual_cost,
      upper_individual_cost = upper * individual_cost
    ) %>%
    dplyr::select(-c(lower, fit, upper, individual_cost)) %>%
    dplyr::arrange(date, event)
}


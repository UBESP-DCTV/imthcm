#' Compute costs of related health events
#'
#' This function computes the costs associated the cardiac and respiratory
#' hospitalizations. Individual available costs were associated to stroke
#' occurrence and Congenital Hearth Diseases (CHD) for cardiac events,
#' whereas they were associated to Chronic obstructive pulmonary disease
#' (COPD).
#'
#' Costs for Coronary Heart Disease (CHD) and stroke were derived from the
#' report of the American Heart Association (1) (which reported data on
#' costs derived from the Medical Expenditure Panel Survey (MEPS) of the
#' U.S. Agency for Healthcare Research and Quality), considering 2015 data.
#' Unitary costs (medical, indirect, and total) have been calculated by
#' dividing the projected number of CHD and strokes by the corresponding
#' projected costs (for 2015).
#'
#' Costs for COPD were derived from the paper of Fen et al (2). They were
#' represented only by medical costs and referred to the year 2010. Also
#' COPD costs reported in the paper were derived from the MEPS survey.
#' Cost estimates are based on an exchange rate EUR-USD of 1.233.
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
#' @param health_events_dataframe A data frame with predicted health events
#'        and relative 95% CI. Column names must be:
#'          - \code(date)  = date of the simulated day;
#'          - \code(event) = type of event (e.g. mortality for all causes,
#'                           hospitalizations for cardiac events, ...);
#'          - \code(lower) = lower bound of 95% CI of average daily number
#'                           of considered health event;
#'          - \code(fit)   = average daily number of considered health
#'                           event;
#'          - \code(upper) = upper bound of 95% CI of average daily number
#'                           of considered health event.
#'
#'
#' @return a data frame with n_days*2 rows (where n_days is the number of
#'         simulated days) and 8 columns. For each days, there are two rows
#'         in the data frame: one for hospitalizations for cardiac diseases
#'         and one for hospitalizations for respiratory diseases. The
#'         columns contain respectively: date of the date of the
#'         simulated day, the health outcomes, the 95% CI lower bound of the
#'         predicted average daily number of events, the predicted average
#'         daily number of events and the the 95% CI upper bound of the
#'         predicted average daily number of events, the 95% CI lower bound
#'         of costs associated to a particular health events, the average
#'         daily costs associated to a particular health event and the 95%
#'         CI upper bound of costs associated to a particular health events.
#'
#' @import
#' @export
#'
#' @references (1) Projections of cardiovascular disease prevalence and
#'                 costs: 2015–2035 O Khavjou, D Phelps, A Leib - 2017.
#'                 Available at: https://healthmetrics.heart.org/projections-of-cardiovascular-disease/;
#'              (2) Total and State-Specific Medical and Absenteeism Costs
#'                  of COPD Among Adults Aged 18 Years in the United States
#'                  for 2010 and Projections Through 2020. Ford, Earl S. et
#'                  al. CHEST, Volume 147, Issue 1, 31 - 45
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
#' compute_cost(hh_non_summer)
#' compute_cost(hh_full_year)
#' }


# Compute costs ----------------------------------------------------------
compute_cost <- function(health_events_dataframe){

  # Define individual cost for cardiac and respiratory hospitalizations
  # (in Euro)
  ind_cardiac_cost <- (9051.69 + 7184.98)/2
  ind_resp_cost    <- 575.83

  # Compute cardiac costs (individual average of stroke and CHD costs)
  cardiac_hosp <- health_events_dataframe %>%
    dplyr::filter(event == 'hosp_cardiac') %>%
    dplyr::mutate(
      lower_costs = ind_cardiac_cost * lower,
      fit_costs   = ind_cardiac_cost * fit,
      upper_costs = ind_cardiac_cost * upper
    )

  # Compute respiratory costs (individual COPD costs)
  resp_hosp <- health_events_dataframe %>%
    dplyr::filter(event == 'hosp_resp') %>%
    dplyr::mutate(
      lower_costs = ind_resp_cost * lower,
      fit_costs   = ind_resp_cost * fit,
      upper_costs = ind_resp_cost * upper
    )

  # Bind dataframes and rename health event columns
  dplyr::bind_rows(cardiac_hosp, resp_hosp) %>%
    dplyr::rename(
      lower_health_events = lower,
      fit_health_events   = fit,
      upper_health_events = upper
    )
}


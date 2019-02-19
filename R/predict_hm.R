#' Predict function for Health module
#'
#' This function predicts the number of considered health outcomes. Each
#' outcome is predicted with GAM models previously trained on historical
#' data. Once trained, GAM model estimates the number of health event of the
#' simulated day with relative 95% CI. Predictions are returned as
#' data frame. The data frame is composed by simulated days: n rows
#' and 6 columns. Each row gives the fitted number, with relative 95% CI, of
#' considered health outcomes for each simulated day. Each column represents
#' respectively the date of the simulated day, the health outcomes, the
#' 95% CI lower bound of the predicted average daily number of events, the
#' predicted average daily number of events and the the 95% CI upper bound
#' of the predicted average daily number of events.
#'
#' @param models [lst] A list with 7 elements. Each element corresponds to
#'        previously trained model for the outcome of interest.
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
#' @param weather_today [data frame] A data frame with data on weather of
#'        the simulated day. The dataframe must contains a number of rows
#'        equal to the lenght of \code{health_events_history} and at least
#'        the following column (with exactly the same column names):
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
#' @param ... possible further arguments passed to the function
#' @param full_year [lgl] should the models (and prediction) be made on the
#'        same full-year data or should summer or non-summer models be used?
#'        If \code{TRUE} full-year models are used. By default,
#'        full-year are used in the of missing summer- or non-summer-model
#'        or if \code{weather_history} or \code{weather_today} do not have
#'        ozone information (i.e., there are no \code{o38h} variable)
#'
#' @param digits integer indicating the number of decimal places (round).
#'        default is 4.
#'
#' @return a data frame with the fitted value (i.e., average predicted
#'         events) including 95% Confidence Interval (column \code{lower}
#'         and \code{upper}) for each type of event mange by the models used
#'         for each date considered.
#'
#' @import mgcv
#' @importFrom rlang !!
#' @export
#'
#' @examples
#' library(imthcm)
#' default_models <- train_event_models(use_ita = TRUE)
#' predict_hm(default_models, test_weather, test_weather[731L, ])
#' predict_hm(default_models, test_weather, test_weather[c(731L, 730L), ],
#'   full_year = TRUE
#' )
#'
#' no_o3_test_weather <- dplyr::select(test_weather, -o38h)
#' predict_hm(default_models, no_o3_test_weather,
#'   no_o3_test_weather[731L, ]
#' )
predict_hm <- function(
  models,
  weather_history,
  weather_today,
  ...,
  full_year = (!'o38h' %in% names(weather_today)) ||
              (all(purrr::map_lgl(models[['summer']], is.null))),
  digits = 4L
) {

# Input check ---------------------------------------------------------

  ## models
  assertive::assert_is_inherited_from(models, 'list')
  purrr::walk(models,
    ~ assertive::assert_is_inherited_from(.x, 'list')
  )
  purrr::walk(models[['full_year']],
    ~ assertive::assert_is_inherited_from(.x, c('gam', 'glm', 'lm'))
  )


  ## weather_history
  assertive::assert_is_inherited_from(weather_today, 'data.frame')


  ## weather_today
  assertive::assert_is_inherited_from(weather_today, 'data.frame')

  weather_included <- intersect(
    c('date', 'temp_mean', 'press_bar_mean', 'pm10', 'pm25', 'no2', 'o38h'),
    names(weather_today)
  ) %>%
    magrittr::set_names(., .)

  if (
    !all(c('date', 'temp_mean', 'press_bar_mean') %in% weather_included)
  ) {
    stop('`date`, `temp_mean` and `press_bar_mean` must be provided')
  }

  if (!'pm25' %in% weather_included) {
    if ('pm10' %in% weather_included) {
      main_pollutant <- 'pm10'
    } else if ('no3' %in% weather_included) {
      main_pollutant <- 'no3'
    } else {
    stop(glue::glue('none of `pm10`, `pm25` or `no3` are provided,',
      'please include at least one of them'
    ))
    }
  } else {
    main_pollutant <- 'pm25'
  }

  if (is.null(weather_history[[main_pollutant]]) ||
      all(is.na(weather_history[[main_pollutant]]))
  ) {
    stop(
      glue::glue('{main_pollutant} is the principal polutant in
        weather_today and so it must be present in weather_history, but it
        is not. Please provide a coherent weather_history dataset.'
      )
    )
  }


  if (any(
       !(weather_today[['date']][[1]] - c(1, 2, 3)) %in%
       weather_history[['date']]
  )) {
    stop(glue::glue("Date of provided today_weather is
      {weather_today[['date']][[1]]}. History_weather must contains
      information about at least three previous days, i.e.
      {paste(weather_today[['date']][[1]] - c(1, 2, 3), collapse = ', ')}.
      Please provide a more complete dataset for historical data"
    ))
  }
  assertive::assert_all_are_true(length(weather_included) != 0)

  ## full_year
  assertive::assert_is_a_bool(full_year)

  ## digits
  assertive::assert_is_an_integer(digits)

# Data preparation ----------------------------------------------------

  main_pollutant <- rlang::enquo(main_pollutant)

  weather_history <- weather_history[, names(weather_today), drop = FALSE]

  full_weather <- weather_today %>%
    dplyr::full_join(weather_history) %>%
    dplyr::rename(pm25 = !!main_pollutant) %>%
    weather_preproc() %>%
    dplyr::mutate(
      is_summer = month %in% c(4, 5, 6, 7, 8, 9)
    ) %>%
    dplyr::filter(
      date %in% weather_today[['date']]
    )


# Predictions ---------------------------------------------------------

  row_ids <- seq_len(nrow(full_weather)) %>%
    magrittr::set_names(
      full_weather[['date']]
    )

  model_used <- purrr::map_chr(row_ids,
    ~ dplyr::if_else(full_year,
        true  = 'full_year',
        false = c('non_summer', 'summer')[[
                  full_weather[['is_summer']][[.x]] + 1
        ]]
    )
  )

  purrr::map(row_ids, function(actual_case){
    purrr::map_df(models[[model_used[[actual_case]]]],
      ~ mgcv::predict.gam(
          object  = .x,
          newdata = full_weather[actual_case, ],
          type    = 'response',
          se.fit  = TRUE
      )
    ) %>%
    dplyr::transmute(
      date  = full_weather[['date']][[actual_case]],
      event = names(models[[model_used[[actual_case]]]]),
      lower = (stats::qchisq(0.025, 2 * fit) / 2) %>% round(digits),
      fit   = fit %>% round(digits),
      upper = (stats::qchisq(0.975, 2 * fit) / 2) %>% round(digits)
    )
  }) %>%
    do.call(what = dplyr::bind_rows)
}

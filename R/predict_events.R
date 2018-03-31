#' Predict function for Health module
#'
#' @param models [lst] TO BE COMMENTED
#' @param weather_history [data frame] TO BE COMMENTED
#' @param weather_today [data frame] TO BE COMMENTED
#' @param ... possible further arguments passed to the function
#' @param full_year [lgl] should be models (and prediction) made on the
#'        same full-year data or model should distinguish from summer
#'        period and non-summer period? If \code{TRUE} full-year models
#'        are used. By default, full-year are used in the case of missing
#'        summer- or non-summer-model or if \code{weather_history} or
#'        \code{weather_today} do not have ozone information (i.e., there
#'        are no \code{o38h} variable)
#'
#' @return a data frame with the fitted value (i.e., mean event predicted)
#'         including 95% Confidence Interval (column \code{lower} and
#'         \code{upper}) for each type of event mange by the models used for
#'         each date considered.
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
              (all(purrr::map_lgl(models[['summer']], is.null)))
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
      information about at least three previous date, i.e.
      {paste(weather_today[['date']][[1]] - c(1, 2, 3), collapse = ', ')}.
      Please provide a more complete dataset for historical data"
    ))
  }
  assertive::assert_all_are_true(length(weather_included) != 0)

  ## full_year
  assertive::assert_is_a_bool(full_year)



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
      lower = (stats::qchisq(0.025, 2 * fit) / 2) %>% as.integer(),
      fit   = fit %>% as.integer(),
      upper = (stats::qchisq(0.975, 2 * fit) / 2) %>% as.integer()
    )
  }) %>%
    do.call(what = dplyr::bind_rows)
}

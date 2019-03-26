#' Pre-process function
#'
#' A function that pre-process data to be take as inputs by GAM models.
#'
#' @param weather_data [data frame] A data.frame
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' library(imthcm)
#' weather_preproc(test_weather)


weather_preproc <- function(weather_data) {


# Test input ----------------------------------------------------------

  assertive::assert_is_inherited_from(weather_data, 'data.frame')



# Preporcess ----------------------------------------------------------
  outcome <- setdiff(
    c('date', 'temp_mean', 'press_bar_mean', 'pm10', 'pm25', 'no2', 'o38h'),
    names(weather_data)
  )
  weather_data[outcome] <- NA_real_


# Run -----------------------------------------------------------------

 weather_data %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(

      # time ----------------------------------------------------------
      year     = lubridate::year(date) %>% as.integer(),
      month    = lubridate::month(date) %>% as.integer(), # factor(levels = 1:12),
      day      = as.numeric(date)/1000,   # factor(levels = 1:30),
      day_week = lubridate::wday(date) %>% as.integer(),  # factor(levels = 1:7),
      # dd       = I(as.factor(year):as.factor(month):as.factor(day_week)),

      # lag -----------------------------------------------------------
      lag_01_pm25 = weather_lag01(pm25),
      lag_01_pm10 = weather_lag01(pm10),
      lag_01_no2  = weather_lag01(no2),
      lag_01_o38h = weather_lag01(o38h),
      lag_03_pm25 = weather_lag03(pm25),
      lag_03_pm10 = weather_lag03(pm10),
      lag_03_no2  = weather_lag03(no2),
      lag_03_o38h = weather_lag03(o38h)
    )
}







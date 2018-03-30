#' Pre-process function
#'
#' descrizione breve (a function that pre-process data to be take as inputs
#' by GAM models.)
#'
#' Se serve (dal secondo paragrafo in poi) ci sono i dettagli
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

  assertive::is_inherited_from(weather_data, 'data.frame')
  assertive::are_set_equal(names(weather_data),
    c('date', 'temp_mean', 'press_bar_mean', 'pm10', 'pm25', 'no2', 'o38h')
  )



# Run -----------------------------------------------------------------


 weather_data %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(

      # time ----------------------------------------------------------
      year     = lubridate::year(date),
      month    = lubridate::month(date),
      day      = lubridate::day(date),
      day_week = lubridate::wday(date),
      dd       = I(as.factor(year):as.factor(month):as.factor(day_week)),

      # lag -----------------------------------------------------------
      lag_01_pm25 = weather_lag01(pm25),
      lag_01_pm10 = weather_lag01(pm10),
      lag_01_no2  = weather_lag01(no2),
      lag_01_o38h = weather_lag01(o38h),
      lag_03_pm25 = weather_lag03(pm25),
      lag_03_pm10 = weather_lag03(pm10),
      lag_03_no2  = weather_lag03(no2),
      lag_03_o38h = weather_lag01(o38h)
    )
}







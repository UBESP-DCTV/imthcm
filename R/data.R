#' Test dataset for health input.
#'
#' A dataset containing simulated historical information on daily average
#' number of health events. Number of deaths for all causes, cardiac
#' diseases, respiratory diseases and cerebrovascular diseases are the
#' mortality events considered. Number of hospitalizations for cardiac
#' diseases, respiratory diseases and cerebrovascular diseases are the
#' hospitalization events considered.
#'
#' @format A data frame with 1827 rows and 8 variables:
#' \describe{
#'   \item{date}{date of the day}
#'   \item{mort_all}{number of deaths for all causes}
#'   \item{mort_cardiac}{number of deaths for cardiac diseases}
#'   \item{mort_resp}{number of deaths for respiratory diseases}
#'   \item{mort_cer}{number of deaths for cerebrovascular diseases}
#'   \item{hosp_cardiac}{number of hospitalizations for cardiac diseases}
#'   \item{hosp_resp}{number of hospitalizations for respiratory diseases}
#'   \item{hosp_cer}{
#'     number of hospitalizations for cerebrovascular diseases
#'   }
#' }
"test_health"


#' Test dataset for weather input.
#'
#' A dataset containing simulated historical information on daily average
#' weather variables values. Average daily temperature in Celsius, average
#' daily barometric pressure in hPa, average daily concentration of PM10 in
#' ug/m^3, avegare daily concentration of PM2.5 in ug/m^3, average daily
#' concentration of NO2 in ug/m^3 and maximum daily concentratio of O3 in
#' ug/m^3 between 8h moving averages of the period between april and
#' september are the weather variables taken as inputs.
#'
#' @format A data frame with 1827 rows and 7 variables:
#' \describe{
#'   \item{date}{date of the day}
#'   \item{temp_mean}{average daily temperature in Celsius}
#'   \item{press_bar_mean}{average daily barometric pressure in hPa}
#'   \item{pm10}{average daily concentration of PM10 in ug/m^3}
#'   \item{pm25}{average daily concentration of PM2.5 in ug/m^3}
#'   \item{no2}{average daily concentration of NO2 in ug/m^3}
#'   \item{o38h}{
#'     maximum daily concentratio of O3 in ug/m^3 between 8h moving averages
#'     of the period between april and september
#'   }
#' }
"test_weather"


#' Default italiantrained models.
#'
#' [GENERAL DESCRIPTION FOR THE MODELS, ONECE DONE DELETE ALSO THE SQUARE BRACKETS]
#'
#' @format A list of 3 list each of lenght 7:
#' \describe{
#'   \item{summer}{[GENERAL DESCRIPTION FOR SUMMER]
#'     \describe{
#'       \item{mort_all}{...}
#'       \item{mort_cardiac}{...}
#'       \item{mort_resp}{...}
#'       \item{mort_cer}{...}
#'       \item{hosp_cardiac}{...}
#'       \item{hosp_resp}{...}
#'       \item{hosp_cer}{...}
#'     }
#'   }
#'   \item{non_summer}{[GENERAL DESCRIPTION FOR SUMMER]
#'     \describe{
#'       \item{mort_all}{...}
#'       \item{mort_cardiac}{...}
#'       \item{mort_resp}{...}
#'       \item{mort_cer}{...}
#'       \item{hosp_cardiac}{...}
#'       \item{hosp_resp}{...}
#'       \item{hosp_cer}{...}
#'     }
#'   }
#'   \item{full_year}{[GENERAL DESCRIPTION FOR SUMMER]
#'     \describe{
#'       \item{mort_all}{...}
#'       \item{mort_cardiac}{...}
#'       \item{mort_resp}{...}
#'       \item{mort_cer}{...}
#'       \item{hosp_cardiac}{...}
#'       \item{hosp_resp}{...}
#'       \item{hosp_cer}{...}
#'     }
#'   }
#' }
"event_models_ita"

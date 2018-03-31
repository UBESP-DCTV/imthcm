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


#' Default italian-trained models.
#'
#' Defaul models are GAM models trained on the italian data used for EpiAir2
#' study (@source \url{http://www.epiair.it/}). In particular, GAM models
#' were trained on data belonging to Venice city. This dataset contains
#' information on health events and climate of the city of Venice in the
#' period from 2006-01-01 to 2009-12-31.
#'
#' Three different type of GAM models were trained:
#'
#' \enumerate{
#'   \item One model for the summer period, which was defined as the period
#'         that goes from 04-01 to 09-30.
#'
#'   \item One model for the non-summer period, which was defined as the
#'         period that goes from 01-01 to 03-31 and to 10-01 to 12-31.
#'
#'   \item One model for the all year.
#' }
#'
#' All the three models were implemented assuming a Poisson distribution for
#' health outcome, since the goal was to model health outcomes as count
#' events. A correction factor was applied to each model to take into
#' account overdispersion, i.e. the possibility that each outcome could
#' occur an high number of times for some days.
#' For all the three models the following variables were considered as
#' covariates: the mean of daily PM2.5 concentration of the simulated day
#' and of the three previous days (lag 0-3), the year, the month, the day
#' and all the possible combinations of them, the daily average temperature
#' (Celsius), modeled with a penalized spline, and the daily average
#' barometric pressure (hPa), modeled with a penalized spline.
#' Among all the pollutants, only one was included in the model since the
#' correlation between air pollutants is known to be relevant. In this case,
#' one pollutant acts as proxy for the others by including the effect on
#' health outcomes caused by the variation of other pollutants.
#' The reason behind the choice of an additional model for the summer period
#' relies in the different effect that pollutants can have in different
#' period of the year. Indeed, O3 has a significant effect on health
#' outcomes only in the summer period. Thus, the mean of daily O3
#' concentration of the simulated day and of the three previous days
#' (lag 0-3) was included only in the summer model, while the non-summer
#' model takes into account only PM2. Finally, a third model that predict
#' the number of health outcomes for the all year was created as a
#' replacement for the summer model if O3 are not provided as inputs.
#'
#' @format A list of 3 list each of lenght 7:
#' \describe{
#'   \item{summer}{Model for the summer period. It takes into account both
#'     the lagged concentration of PM2.5 and O3. It predictes the daily mean
#'     number of health events with relative 95% CI.
#'     \describe{
#'       \item{mort_all}{Predicted number of death for all causes.}
#'       \item{mort_cardiac}{Predicted number of death for cariac diseases.}
#'       \item{mort_resp}{Predicted number of death for respiratory
#'         diseases.
#'       }
#'       \item{mort_cer}{Predicted number of death for cerebrovascular
#'         diseases.
#'       }
#'       \item{hosp_cardiac}{Predicted number of hospitalizations for
#'         cardiac diseases.
#'       }
#'       \item{hosp_resp}{Predicted number of hospitalizations for
#'         respiratory diseases.
#'       }
#'       \item{hosp_cer}{Predicted number of hospitalizations for
#'         cerebrovascular diseases.
#'       }
#'     }
#'   }
#'   \item{non_summer}{Model for the non-summer period. It takes into
#'     account only the lagged PM2.5 concentration. It predictes the daily
#'     mean number of health events with relative 95% CI.
#'     \describe{
#'       \item{mort_all}{Predicted number of death for all causes.}
#'       \item{mort_cardiac}{Predicted number of death for cariac diseases.}
#'       \item{mort_resp}{Predicted number of death for respiratory
#'         diseases.
#'       }
#'       \item{mort_cer}{Predicted number of death for cerebrovascular
#'         diseases.
#'       }
#'       \item{hosp_cardiac}{Predicted number of hospitalizations for
#'         cardiac diseases.
#'       }
#'       \item{hosp_resp}{Predicted number of hospitalizations for
#'         respiratory diseases.
#'       }
#'       \item{hosp_cer}{Predicted number of hospitalizations for
#'         cerebrovascular diseases.
#'       }
#'     }
#'   }
#'   \item{full_year}{Model for the full year period. It takes into account
#'                    only the lagged PM2.5 concentration. It predictes
#'                    the daily mean number of health events with relative
#'                    95% CI.
#'     \describe{
#'       \item{mort_all}{Predicted number of death for all causes.}
#'       \item{mort_cardiac}{Predicted number of death for cariac diseases.}
#'       \item{mort_resp}{Predicted number of death for respiratory
#'         diseases.
#'       }
#'       \item{mort_cer}{Predicted number of death for cerebrovascular
#'         diseases.
#'       }
#'       \item{hosp_cardiac}{Predicted number of hospitalizations for
#'         cardiac diseases.
#'       }
#'       \item{hosp_resp}{Predicted number of hospitalizations for
#'         respiratory diseases.
#'       }
#'       \item{hosp_cer}{Predicted number of hospitalizations for
#'         cerebrovascular diseases.
#'       }
#'     }
#'   }
#' }
"event_models_ita"


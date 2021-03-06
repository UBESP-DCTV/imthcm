% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{event_models_ita}
\alias{event_models_ita}
\title{Default italian-trained models.}
\format{A list of 3 list each of lenght 7:
\describe{
  \item{summer}{Model for the summer period. It takes into account both
    the lagged concentration of PM2.5 and O3. It predictes the daily mean
    number of health events with relative 95% CI.
    \describe{
      \item{mort_all}{Predicted number of death for all causes.}
      \item{mort_cardiac}{Predicted number of death for cariac diseases.}
      \item{mort_resp}{Predicted number of death for respiratory
        diseases.
      }
      \item{mort_cer}{Predicted number of death for cerebrovascular
        diseases.
      }
      \item{hosp_cardiac}{Predicted number of hospitalizations for
        cardiac diseases.
      }
      \item{hosp_resp}{Predicted number of hospitalizations for
        respiratory diseases.
      }
      \item{hosp_cer}{Predicted number of hospitalizations for
        cerebrovascular diseases.
      }
    }
  }
  \item{non_summer}{Model for the non-summer period. It takes into
    account only the lagged PM2.5 concentration. It predictes the daily
    mean number of health events with relative 95% CI.
    \describe{
      \item{mort_all}{Predicted number of death for all causes.}
      \item{mort_cardiac}{Predicted number of death for cariac diseases.}
      \item{mort_resp}{Predicted number of death for respiratory
        diseases.
      }
      \item{mort_cer}{Predicted number of death for cerebrovascular
        diseases.
      }
      \item{hosp_cardiac}{Predicted number of hospitalizations for
        cardiac diseases.
      }
      \item{hosp_resp}{Predicted number of hospitalizations for
        respiratory diseases.
      }
      \item{hosp_cer}{Predicted number of hospitalizations for
        cerebrovascular diseases.
      }
    }
  }
  \item{full_year}{Model for the full year period. It takes into account
                   only the lagged PM2.5 concentration. It predictes
                   the daily mean number of health events with relative
                   95% CI.
    \describe{
      \item{mort_all}{Predicted number of death for all causes.}
      \item{mort_cardiac}{Predicted number of death for cariac diseases.}
      \item{mort_resp}{Predicted number of death for respiratory
        diseases.
      }
      \item{mort_cer}{Predicted number of death for cerebrovascular
        diseases.
      }
      \item{hosp_cardiac}{Predicted number of hospitalizations for
        cardiac diseases.
      }
      \item{hosp_resp}{Predicted number of hospitalizations for
        respiratory diseases.
      }
      \item{hosp_cer}{Predicted number of hospitalizations for
        cerebrovascular diseases.
      }
    }
  }
}}
\usage{
event_models_ita
}
\description{
Defaul models are GAM models trained on the italian data used for EpiAir2
study (@source \url{http://www.epiair.it/}). In particular, GAM models
were trained on data belonging to Venice city. This dataset contains
information on health events and climate of the city of Venice in the
period from 2006-01-01 to 2009-12-31.
}
\details{
Three different type of GAM models were trained:

\enumerate{
  \item One model for the summer period, which was defined as the period
        that goes from 04-01 to 09-30.

  \item One model for the non-summer period, which was defined as the
        period that goes from 01-01 to 03-31 and to 10-01 to 12-31.

  \item One model for the all year.
}

All the three models were implemented assuming a Poisson distribution for
health outcome, since the goal was to model health outcomes as count
events. A correction factor was applied to each model to take into
account overdispersion, i.e. the possibility that each outcome could
occur an high number of times for some days.
For all the three models the following variables were considered as
covariates: the mean of daily PM2.5 concentration of the simulated day
and of the three previous days (lag 0-3), the year, the month, the day
and all the possible combinations of them, the daily average temperature
(Celsius), modeled with a penalized spline, and the daily average
barometric pressure (hPa), modeled with a penalized spline.
Among all the pollutants, only one was included in the model since the
correlation between air pollutants is known to be relevant. In this case,
one pollutant acts as proxy for the others by including the effect on
health outcomes caused by the variation of other pollutants.
The reason behind the choice of an additional model for the summer period
relies in the different effect that pollutants can have in different
period of the year. Indeed, O3 has a significant effect on health
outcomes only in the summer period. Thus, the mean of daily O3
concentration of the simulated day and of the three previous days
(lag 0-3) was included only in the summer model, while the non-summer
model takes into account only PM2. Finally, a third model that predict
the number of health outcomes for the all year was created as a
replacement for the summer model if O3 are not provided as inputs.
}
\keyword{datasets}

# (Auto) load needed package ==========================================
check_pkg('imthcm') %>%
  please_install(
    install_fun = devtools::install_github,
    repo        = 'https://github.com/UBESP-DCTV/imthcm'
  )
library(imthcm)
# source('path/to/epiair_db_venice_pre_proc.rda')            # reserved data

# Create base dataset -------------------------------------------------


ita_weather_history <- db_venice_fin %>%
  dplyr::select(date, temp_mean, press_bar_mean, pm25, pm10, no2, o38h)

ita_events_history <- db_venice_fin %>%
  dplyr::select(
    date, mort_all, mort_cardiac, mort_cer, mort_resp,
    hosp_cardiac, hosp_resp, hosp_cer
  )

# Train default models ------------------------------------------------

event_models_ita <- train_event_models(
  ita_events_history,
  ita_weather_history
)


# Save and store models -----------------------------------------------

usethis::use_data(event_models_ita)

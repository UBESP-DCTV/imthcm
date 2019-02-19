library(here)
library(janitor)
library(readxl)
library(lubridate)
library(tidyverse)

west_data <- here::here(
    'data-raw', 'dati_orari_da_ARPAV', 'TV West Road Hourly data.xlsx'
  ) %>%
  read_xlsx(skip = 9, col_names = FALSE)

colnames(west_data) <- c(
  'end_period', 'benzene', 'co', 'dvp', 'etilbenzene', 'mpxylene', 'no',
  'no2', 'nox', 'o_xylene', 'o3', 'pm25', 'so2', 'temp', 'toluene', 'umr',
  'vvp'
)


west_data <- west_data %>%
  mutate(
    end_period = end_period %>%
      dmy_h()
  )

save(west_data, file = here::here('data', 'west_data.rda'))

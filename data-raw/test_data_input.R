# Check packages dependencies =========================================

check_pkg(c('MASS', 'lubridate', 'tibble', 'stats'))


# global constants ====================================================

first_date <- lubridate::ymd('2012-01-01')
last_date  <- lubridate::ymd('2016-12-31')
n_days     <- as.integer(last_date - first_date) + 1L




# Test data for health input ==========================================


# constants for health ------------------------------------------------

## death simulation function
mu_death    <- 3
theta_death <- 10
sim_death <- function(n = n_days, mu = mu_death, theta = theta_death) {
  MASS::rnegbin(n = n, mu = mu, theta = theta)
}

## hospitalization simulation function
mu_hosp    <- 5
theta_hosp <- 10
sim_hosp <- function(n = n_days, mu = mu_hosp, theta = theta_hosp) {
  MASS::rnegbin(n = n, mu = mu, theta = theta)
}


# test_health data creation -------------------------------------------

test_health <- tibble::data_frame(
  date = seq(
    from = first_date,
    to   = last_date,
    by   = '1 day'
  ),
  mort_all     = sim_death(),
  mort_cardiac = sim_death(),
  mort_resp    = sim_death(),
  mort_cer     = sim_death(),
  hosp_cardiac = sim_hosp(),
  hosp_resp    = sim_hosp(),
  hosp_cer     = sim_hosp()
)


# test_health data saving ---------------------------------------------

usethis::use_data(test_health)




# Test data for weather input =========================================


# test_weather data creation ==========================================


test_weather <- tibble::data_frame(
  date = seq(
    from = first_date,
    to   = last_date,
    by   = '1 day'
  ),
  temp_mean      = stats::rnorm(n = n_days, mean = 18.6,   sd = 20.1  ),
  press_bar_mean = stats::rnorm(n = n_days, mean = 1021.3, sd = 150.21),
  pm10           = stats::rnorm(n = n_days, mean = 46.23,  sd = 26.77 ),
  pm25           = stats::rnorm(n = n_days, mean = 37,     sd = 15    ),
  no2            = stats::rnorm(n = n_days, mean = 37,     sd = 15    ),
  o38h           = stats::rnorm(n = n_days, mean = 37,     sd = 15    )
)


# test_health data saving ---------------------------------------------

usethis::use_data(test_weather)

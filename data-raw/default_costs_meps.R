# Create base dataset -------------------------------------------------

meps_costs <- tibble::tribble(
  ~event,          ~individual_cost, ~currences,
   'hosp_cardiac',  8118.335,         'euro', # (9051.69 + 7184.98)/2
   'hosp_resp',     575.83,           'euro'
)


# Save and store meps costs -------------------------------------------

usethis::use_data(meps_costs)

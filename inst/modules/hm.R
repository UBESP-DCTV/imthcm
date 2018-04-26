#!/usr/bin/env Rscript


# Options setup -------------------------------------------------------

if (!requireNamespace('docopt', quietly = TRUE)) stop(
  paste0(
    'package `docopt` required\n',
    '       tip: run `install.packages(docopt, dependencies = TRUE)`\n',
    '            and rerun the program.'
  ),
  call. = FALSE
)

## First, we store the command line options in a string represented by the
## variable `doc` and then let docopt parse them with `docopt(doc)`, which
## returns a list in which the command line arguments are accessible in the
## usual way.

'Usage:
  hm.R [((--weather=<weather_history> --events=<events_history>) | --default) --new=<weather_new> --output=<output> --figures=<figures_path> --single]

Options:
  -w <weather_history> --weather=<weather_history>  historical weather informations [default: weather_history.xml]
  -e <events_history> --events=<events_history>     historical events informations  [default: events_history.xml]
  -d --default                                      flag to use default italian weather and events data
  -n <weather_new> --new=<weather_new>              new weather informations        [default: weather_new.xml]
  -o <output> --output=<output>                     tabular output file             [default: hm_output.xml]
  -f <figures_path> --figures=<figures_path>        figure file (type based on the extension) [default: hm_figures.png]
  -s --single                                       flag to save a windowed daily plot [default: TRUE] or time smooth pattern

]' -> doc

opts <- docopt::docopt(doc)

# BEGIN ===============================================================
if (!requireNamespace('imthcm', quietly = TRUE)) stop(
  paste0(
    'package `imthcm` required\n',
    '       tip: run `devtools::install_github("UBESP-DCTV/imthcm")`\n',
    '       and rerun the program.'
  ),
  call. = FALSE
)
library(imthcm)
check_pkg(c(
  'magrittr', 'lubridate', 'tibble', 'stats', 'assertive', 'dplyr', 'purrr',
  'glue', 'nlme', 'mgcv', 'rlang', 'tidyr', 'stringr', 'xml2', 'here',
  'ggplot2'
))

if (packageVersion('mgcv') < '1.8.23') {
  imthcm:::please_install('mgcv', dependencies = TRUE)
}
# Read and manage XML of input ----------------------------------------

weather_history <- if (opts[['--default']]) {
    test_weather
  } else {
    xml_to_weather(opts[['--weather']])
}

# Run the module

hm_models <- train_event_models(
  health_events_history = xml_to_health(opts[['--events']]),
  weather_history       = weather_history,
  use_ita               = opts[['--default']]
)

hm_predictions <- predict_hm(
  models          = hm_models,
  weather_history = weather_history,
  weather_today   = xml_to_weather(opts[['--new']])
)

# Provide/Save the output

predictions_to_xml(hm_predictions, file = opts[['--output']])

if (opts[['--single']]) {
  plot_pred_event_outcomes(hm_predictions,
    plot_file = opts[['--figure']]
  )
} else {
  plot_pred_event_outcomes_time(hm_predictions,
    plot_file = opts[['--figures']]
  )
}

# END =================================================================

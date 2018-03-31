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
hm.R [(-w <weather_history> -e <events_history.xml> | -d)  -t <weather_new> -o <output.xml> -f <figures_path>]

Options:
-w --weather  historical weather informations [default: weather_history.xml]
-e --events   historical events informations  [default: events_history.xml]
-d --default  flag to use default italian weather and events data [default: FALSE]
-n --new      new weather informations        [default: weather_new.xml]
-o --output   tabular output file             [default: hm_output.xml]
-f --figures  zip file containing pictures    [default: hm_figures]

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


# Read and manage XML of input ----------------------------------------

weather_history <- xml_to_weather(opts[['--weather']])


# Run the module

hm_models <- train_event_models(
  health_events_history = read_xml_health(opts[['--events']]),
  weather_history       = weather_history,
  use_ita               = opts[['--default']]
)

hm_predictions <- predict_hm(
  models          = hm_models,
  weather_history = weather_history,
  weather_today   = xml_to_weather(opts[['--new']])
)


# Prepare the output



# Provide/Save the output

predictions_to_xml(hm_predictions, file = opts[['--output']])


# END =================================================================

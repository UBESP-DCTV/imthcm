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
  cm.R [--events=<predicted_events> (--costs=<costs_tablesl> | --default) --output=<output> --figures=<figures_path> --single]

Options:
  -e <predicted_events> --events=<predicted_events>  Predicted events (hm.R module) [default: hm_output.xml]
  -c <costs_table> --costs=<costs_table>             Costs tables for the events predicted [default: cost_data.xml]
  -d --default                                       flag to use default MEPS cost data
  -o <output> --output=<output>                      tabular output file [default: cm_output.xml]
  -f <figures_path> --figures=<figures_path>         figure file (type based on the extension) [default: cm_figures.png]
  -s --single                                        flag to save a windowed daily plot [default: TRUE] or time smooth pattern

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

# Package check and loading -------------------------------------------

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

cost_data <- if (opts[['--default']]) {
  NULL
} else {
  xml_to_cost(opts[['--costs']])
}


# Run the module

cm_model <- compute_cost(
  health_events = xml_to_prediction(opts[['--events']]),
  costs         = cost_data,
  use_meps      = opts[['--default']]
)



# Provide/Save the output
cost_to_xml(cm_model, file = opts[['--output']])

if (opts[['--single']]) {
  plot_computed_cost(cm_model, plot_file = opts[['--figures']]
  )
} else {
  plot_computed_cost_time(cm_model, plot_file = opts[['--figures']]
  )
}

# END =================================================================

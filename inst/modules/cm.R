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
  hm.R [--events=<predicted_events> --costs=<costs_tablesl> --output=<output> --figures=<figures_path>]

Options:
-e <predicted_events> --events=<predicted_events>  Predicted events (hm.R module) [default: predicted_events.xml]
-c <costs_table> --costs=<costs_table>             Costs tables for the events predicted [default: weather_new.xml]
-o <output> --output=<output>                      tabular output file [default: cm_output.xml]
-f <figures_path> --figures=<figures_path>         figure file (type based on the extension) [default: cm_figures.png]

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

# Package check and loading -------------------------------------------


# Read and manage XML of input ----------------------------------------


# Process input for the module


# Run the module


# Prepare the output


# Provide/Save the output


# END =================================================================

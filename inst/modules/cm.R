#!/usr/bin/env Rscript

# Options setup -------------------------------------------------------

if (!requireNamespace('docopt', quietly = TRUE)) stop(
  paste0(
    'package `docopt` required\n',
    '       tip: run `install.packages(docopt, dependencies = TRUE)`\n',
    '            or better `install_github("docopt/docopt.R")`\n',
    '            and rerun the program.'
  ),
  call. = FALSE
)

## First, we store the command line options in a string represented by the
## variable `doc` and then let docopt parse them with `docopt(doc)`, which
## returns a list in which the command line arguments are accessible in the
## usual way.

'usage: cm.R [-i <input> (-c <costs> | -d) -o <output>]


options:
  -i --input=<input>    base input file output of hm.R [default: hm_out.xml]
  -d                    ciao
  -c --costs=<costs>    input XML file [default: cm_costs.xml]
  -o --output=<output>  output file [default: cm_out.xml]
]' -> doc

opts <- docopt(doc)



# BEGIN ===============================================================

str(opts)
# Package check and loading -------------------------------------------


# Read and manage XML of input ----------------------------------------


# Process input for the module


# Run the module


# Prepare the output


# Provide/Save the output


# END =================================================================

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
hm.R [--historical <mean> -s <sd> -n <nsamples> -o <output>]
hm.R --option <argument>
hm.R [<optional-argument>]
hm.R --another-option=<with-argument>
hm.R (--either-that-option | <or-this-argument>)
hm.R <repeating-argument> <repeating-argument>...
hm.R [options] FILE

Options:
-o --output=OUTPUT  output file [default: out.csv] (at least two spaces)
-m Mean of distribution to sample from [default: 0]
-s SD of distribution to sample from [default: 1]
-n Number of samples [default: 100]
-o Output file [default: sim_data.csv]

]' -> doc

opts <- docopt::docopt(doc)



# BEGIN ===============================================================


# Read and manage XML of input ----------------------------------------


# Process input for the module


# Run the module


# Prepare the output


# Provide/Save the output


# END =================================================================

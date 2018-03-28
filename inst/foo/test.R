#!/usr/bin/env Rscript
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
   test.R [-m <mean> -s <sd> -n <nsamples> -o <output>]

Options:
   -m Mean of distribution to sample from [default: 0]
   -s SD of distribution to sample from [default: 1]
   -n Number of samples [default: 100]
   -o Output file [default: sim_data.csv]

 ]' -> doc

opts <- docopt::docopt(doc)

x  <- rnorm(
  opts[['n']],
  mean = as.numeric(opts[['m']]),
  sd   = as.numeric(opts[['s']])
)

df <- data.frame(x = x)

write.csv(df, file = opts[['o']])

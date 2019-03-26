* Changed day in `weather_preproc()` as numeric, i.e., as absolute 
  number of day from a fixed point.
* General restyling
* Fixed a bug in `predict_hm()` in a test to check the correctness of
  the input classes.

# imthcm 0.2.1

* Added `update_me()` function to automatically check for an updated version
  of the package on GitHub.
* Removed marginal interaction on the models for the dates
* Predicted counts of events returner as real with custom number of digits
  (default is 4).

# imthcm 0.2

* Release 0.2

# imthcm 0.1.2

* Updated `README` file
* Added `plot_computed_cost.R` and `plot_computed_cost_time.R` to compute
    and stor the plot for cm
* Added `compute_cost.R` to compute the cost
* Added `data-raw/meps_costs.rda` and `data/meps_costs` files to provide the
    default costs retrieved from MEPA (cardiac: CHD, stroke; and
    respiratory).
* Added `.github/CONTRIBUTING.md` file 
* Added support for AppVeyor CI

# imtchm 0.1

* Release 0.1

# imtchm 0.0.11

* Updated `.travis.yml`
* Updated dependency from `R (3.4)`
* Added `xml_to_prediction.R` to import predicted data

# imtchm 0.0.10

* Updated `DESCRIPTION` to add specific dependencies to `mgcv (>= 1.8.23)`.
* Reshaped `inst/` folders.
* Added `plot_pred_event_outcomes.R` and `plot_pred_event_outcomes_time.R`
    to create basic plots.


# imtchm 0.0.9

* Updated `hm.R`


# imtchm 0.0.8

* Added `data-raw/test_xml_input.R` to create example of XML input file,
    which are stored in `data/`.
* Updated `hm.R`.


# imtchm 0.0.7.2

* Updated `hm.R`


# imtchm 0.0.7

* Minor update to documentations.
* Added `health_to_xml.R` and `xml_to_health` to convert health historical
    data frame from/to xml format.
* Added `weather_to_xml.R` and `xml_to_weather` to convert weather
    historical data frame from/to xml format.


# imtchm 0.0.6

* Minor update to documentations.
* Renamed `predict_event.R` in `predict_hm` as the provided function.
* Updated `inst/modules/hm.R`.
* Added `prediction_to_xml.R` to convert and write prediction to XML file.


# imtchm 0.0.5

* Updated test and default datased and models.
* Added `predict_event.R` to comput the predictions.
* Removed `dd` variable in the preprocessing and in themodel and included
    interaction between its component (with `dd` no future-prediction were
    possible because levels for future year were not present).


# imtchm 0.0.4

* Improved function to preprocess data, changing its name from `pre_proc.R`
    to `weather_preproc.R`.
* Modified `weather_lag.R` to be self-contained, removing dependencies from
    `zoo` package.
* Added `event_models_ita` as default models already trained (row data
    masked).
* Updated documentation on datasets.
* Added `train_event_models.R` to train the models.

`
# imtchm 0.0.3.9000

* Updated `data.R` with more comments.
* Added `weather_lag.R` to provide base function to compute lags.
* Added `preproc.R` to preproces weather data to comput lags.


# imtchm 0.0.3.9000

* Added `R/check_pkg.R` to test the presence of suggested packages in 
    interactive sessions.
* Added Giulia Lorenzoni and Cristina Canova as contributed authors to the
    package.
* Added `data/test_health.rda` and `data/test_weather.rda` as basic test
    data input.
* Added `data-raw/test_data_input.R` to creat input data sample
    (data frames).


# imthcm 0.0.2.9000

* Added a short instructions to set up an R executable in `inst/foo/README`.
* Added a test file `inst/foo/test.R` to check executable capability.


# imthcm 0.0.1.9000

* Added a `.travis.yml` file to configure travis CI.
* Added a `.codecov.yml` file to configure codecov.
* Added a `.gitignore` file to configure git ignored files.
* Added a `.Rbuildignore` file to configure pkg build ignored files.
* Added a `LICENSE.md` file to report the license for the pkg.
* Added a `README.Rmd` file to produce the README in Rmarkdown.
* Added a `NEWS.md` file to track changes to the package.

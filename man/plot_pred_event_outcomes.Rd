% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_pred_event_outcomes.R
\name{plot_pred_event_outcomes}
\alias{plot_pred_event_outcomes}
\title{Plot number of predicted events in function of type of outcomes}
\usage{
plot_pred_event_outcomes(pred_events, plot_file)
}
\arguments{
\item{pred_events}{[data frame] A data frame containing the
following variables:
     - `date` : date of simulated day in format 'yyyy-mm-dd';
     - `event`: name of the outcomes;
     - `lower`: lower bound of 95% CI of average daily predicted number
                of events;
     - `fit`  : average daily predicted number of events;
     - `upper`: upper bound of 95% CI of average daily predicted number
                of events.}

\item{plot_file}{[chr] filename of the destination path. Format of image
is automatically decided by the filename extension}
}
\value{
A boxplot showing the number of predicted events for each type of
        event
}
\description{
A plot that shows the number of average daily predicted events in
function of considered outcome is shown. The bold line represents the
point estimate of the predicted mean value of the number of health
outcome events. The crossbar represents the 95% confidence interval.
}
\examples{
\dontrun{
  library(imthcm)
  default_models <- train_event_models(use_ita = TRUE)
  predicted_events <- predict_hm(default_models,
    test_weather, test_weather[c(728L, 731L), ]
  )
  plot_pred_event_outcomes(predicted_events,
    plot_file = 'outcome_plot.png'
  )
}
}

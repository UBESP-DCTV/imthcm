% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predictions_to_xml.R
\name{predictions_to_xml}
\alias{predictions_to_xml}
\title{Convert predictions to XML}
\usage{
predictions_to_xml(pred, file = NULL)
}
\arguments{
\item{pred}{a dataframe of prediction, i.e. a output from
\code{\link{predict_hm}}.}

\item{file}{[chr] (default is NULL) if provided as
\code{"path/to/xml/output/xml"} the function write the
XML in this file (note: folder must be exists).}
}
\value{
an (invisible) XML document
}
\description{
This function aims to convert prediction from Health Module to XML format
}
\examples{
\dontrun{
  library(imthcm)
  default_models <- train_event_models(use_ita = TRUE)
  pred <- predict_hm(default_models,
    test_weather, test_weather[c(730L, 731L), ]
  )
  predictions_to_xml(pred, file = 'predictions.xml')
  imported_pred <- xml_to_prediction(file = 'predictions.xml')
  identical(pred, imported_pred)
}
}

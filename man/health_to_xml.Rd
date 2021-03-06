% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/health_to_xml.R
\name{health_to_xml}
\alias{health_to_xml}
\title{Convert health data to XML}
\usage{
health_to_xml(health_data, file = NULL)
}
\arguments{
\item{health_data}{a data frame of health data, i.e. events occurred each
day in the history known.}

\item{file}{[chr] (default is NULL) if provided as
\code{"path/to/xml/output/xml"} the function write the
XML in this file (note: folder must be exists).}
}
\value{
an (invisible) XML document
}
\description{
This function aims to convert health data from data a frmae to XML
format.
}
\examples{
library(imthcm)
\dontrun{
  data(test_health)
  xml_health <- 'test_health.xml'
  health_to_xml(test_health, file = xml_health)
  events_history <- xml_to_health(file = xml_health)
  identical(events_history, test_health)
}
}

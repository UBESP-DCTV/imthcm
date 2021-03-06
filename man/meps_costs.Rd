% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{meps_costs}
\alias{meps_costs}
\title{Medical Expenditure Panel Survey (MEPS) costs.}
\format{A data frame with 2 rows and 6 variables:
\describe{
  \item{event}{event considered}
  \item{individual_cost}{individual cost event}
  \item{currences}{currences for the cost considered}
}}
\usage{
meps_costs
}
\description{
Costs for Coronary Heart Disease (CHD) and stroke were derived from the
report of the American Heart Association (1) (which reported data on
costs derived from the Medical Expenditure Panel Survey (MEPS) of the
U.S. Agency for Healthcare Research and Quality), considering 2015 data.
Unitary costs (medical, indirect, and total) have been calculated by
dividing the projected number of CHD and strokes by the corresponding
projected costs (for 2015).
}
\details{
Costs for Chronic Obstructive Pulmonary Disease (COPD) were derived from
the paper of Fen et al (2). They were
represented only by medical costs and referred to the year 2010. Also
COPD costs reported in the paper were derived from the MEPS survey.
Cost estimates are based on an exchange rate EUR-USD of 1.233.
}
\references{
(1) Projections of cardiovascular disease prevalence and costs:
     2015–2035 O Khavjou, D Phelps, A Leib - 2017. Available at:
 https://healthmetrics.heart.org/projections-of-cardiovascular-disease/
 (2) Total and State-Specific Medical and Absenteeism Costs of COPD Among
     Adults Aged 18 Years in the United States for 2010 and Projections
     Through 2020. Ford, Earl S. et al. CHEST, Volume 147, Issue 1, 31-45
}
\keyword{datasets}

#' Plot number of predicted events in function of time
#'
#' A plot that shows the number of predicted events in function of time.
#' The points represent the predicted average daily number of health events.
#' The colours refer to the type of outcome.
#'
#' @param plot_data [data frame] A data frame containing the
#'   following variables:
#'        - `date` : date of simulated day in format 'yyyy-mm-dd';
#'        - `event`: name of the outcomes;
#'        - `lower`: lower bound of 95% CI of average daily predicted number
#'                   of events;
#'        - `fit`  : average daily predicted number of events;
#'        - `upper`: upper bound of 95% CI of average daily predicted number
#'                   of events.
#'
#' @param plot_file [chr] filename of the destination path. Format of image
#'   is automatically decided by the filename extension
#' @return A plot with time trends of the average daily number of predicted
#'         health outcomes considered.
#' @export
#'
#' @examples
#' \dontrun{
#'   library(imthcm)
#'   default_models <- train_event_models(use_ita = TRUE)
#'   predicted_events <- predict_hm(default_models,
#'     test_weather, test_weather[-c(1, 2, 3), ]
#'   )
#'   plot_pred_event_outcomes_time(predicted_events,
#'     plot_file = 'timeoutcome_plot.png'
#'   )
#' }

plot_pred_event_outcomes_time <- function(plot_data, plot_file){

  outcome_plot <- plot_data %>%
    ggplot2::ggplot(ggplot2::aes(x = date, y = fit, colour = event)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth() +
    ggplot2::ggtitle('Predicted health outcome time trends.') +
    ggplot2::xlab('Date') +
    ggplot2::ylab('Average number of predicted values') +
    ggplot2::scale_color_discrete(name = 'Health outcomes') +
    ggplot2::theme_bw()


    # Provide and possibly write the output -------------------------------

  ggplot2::ggsave(filename = plot_file, plot = outcome_plot)
}

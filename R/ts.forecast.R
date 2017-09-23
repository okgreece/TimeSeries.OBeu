#' @title 
#' Time series forecast results of OBEU Time Series
#'  
#' @description
#' Univariate time series forecasts for short and long time series data using the appropriate model.
#' 
#' @usage ts.forecast(ts_modelx, h=1, tojson=F)
#' 
#' @param ts_modelx The input univariate time series data
#' @param h The number of prediction steps
#' @param tojson If TRUE the results are returned in json format, default returns a list
#' 
#' @details 
#' This function is used internally in ts.analysis and forecasts the model 
#' that fits the input data using the auto.arima function(see forecast package). 
#' The model selection depends on the results of some diagnostic tests (acf,pacf,pp adf and kpss).
#' For short time series the selected arima model is among various orders of the AR part using 
#' the first differences and the first order moving average component, with the lower AIC value.
#' 
#' @return A list with the parameters:
#' 
#' \itemize{ 
#'
#' \item ts.model a string indicating the arima orders
#' 
#' \item data_year The time that time series data were sampled
#'
#' \item data The time series values
#' \item predict_time The time that defined by the prediction_steps parameter
#' \item predict_values The predicted values that defined by the prediction_steps parameter
#' \item up80: The upper limit of the 80\% predicted confidence interval
#' \item low80: The lower limit of the 80\% predicted confidence interval
#' \item up95: The upper limit of the 95\% predicted confidence interval
#' \item low95: The lower limit of the 95\% predicted confidence interval}
#'
#' @author Kleanthis Koupidis
#' 
#' 
#' @seealso \code{\link{ts.analysis}}, \code{\link[forecast]{forecast}}
#' 
#' @examples
#' Athens_draft <- ts.non.seas.model(Athens_draft_ts)
#' #Hold the model object of non seasonal modeling
#' draft<-Athens_draft$model.summary 
#' ts.forecast(draft)
#' 
#' @rdname ts.forecast
#'
#' @export
############################################################################

ts.forecast<-function(ts_modelx, h=1, tojson=F){

  ## Model Forecasting
  forecasts<-forecast::forecast(ts_modelx,h)
  
  forecast.param<-list(
                       ts.model=forecasts$method,
                       data_year=stats::time(ts_modelx$x),
                       data=ts_modelx$x,
                       predict_time=stats::time(forecasts$mean),
                       predict_values=forecasts$mean,
                       up80=forecasts$upper[,"80%"],
                       low80=forecasts$lower[,"80%"],
                       up95=forecasts$upper[,"95%"],
                       low95=forecasts$lower[,"95%"] )
  
  if (tojson==T){
    
    forecast.param=jsonlite::toJSON(forecast.param)
  }
  
  ##  Result
  return(forecast.param)
}


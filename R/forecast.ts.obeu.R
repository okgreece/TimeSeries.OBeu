#' @title 
#' Time series forecast results of OBEU Time Series
#'  
#' @description
#' Univariate time series forecasts for short and long time series data using the appropriate model.
#' 
#' @usage forecast.tsa.obeu(ts_model, h=1)
#' 
#' @param ts_model The input univariate time series data
#' @param h The number of prediction steps
#' 
#' @details 
#' This function is used internally in tsa.obeu and forecasts the model 
#' that fits the input data using the auto.arima function(see forecast package). 
#' The model selection depends on the results of some diagnostic tests (acf,pacf,pp adf and kpss).
#' For short time series the selected arima model is among various orders of the AR part using 1st differences and MA(1), with the lower AIC value.
#' 
#' @return A list with the parameters:
#' ts.name a string indicating the name of the time series data
#' ts.model a string indicating the arima orders
#' data_year The time that time series data were sampled.
#' data The time series values.
#' predict_time The time that defined by the prediction_steps parameter.
#' predict_values The predicted values that defined by the prediction_steps parameter.
#' up80 The upper limit of the 80% predicted confidence interval.
#' low80 The lower limit of the 80% predicted confidence interval.
#' up95 The upper limit of the 95% predicted confidence interval.
#' low95 The lower limit of the 95% predicted confidence interval.
#'
#' @author Kleanthis Koupidis
#' 
#' 
#' @seealso tsa.obeu, forecast(forecast package)
#' 
#' @examples
#' 
#' 
#' @rdname forecast.ts.obeu
#' 
#' @import forecast

#' @export
############################################################################

forecast.tsa.obeu<-function(ts_model,h=1){
    options(warn=-1)

  ## Model Forecasting
  forecasts<-forecast::forecast(ts_model,h)
  
  forecast.param<-list(ts.name= ts_model$series,
                       ts.model=forecasts$method,
                       data_year=stats::time(ts_model$x),
                       data=ts_model$x,
                       predict_time=stats::time(forecasts$mean),
                       predict_values=forecasts$mean,
                       up80=forecasts$upper[,"80%"],
                       low80=forecasts$lower[,"80%"],
                       up95=forecasts$upper[,"95%"],
                       low95=forecasts$lower[,"95%"] )
  
  ##  to JSON
  #parameters<-jsonlite::toJSON(forecast.param)
  
  ##  Result
  return(forecast.param)
}


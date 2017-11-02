#' @title 
#' Time series analysis results for OBEU Time series
#'  
#' @description
#' Univariate time series analysis for short and long time series data using the appropriate model.
#' 
#' @usage ts.analysis(tsdata, x.order=NULL, prediction.steps=1, tojson=T)
#' 
#' @param tsdata The input univariate time series data
#' @param x.order An integer vector of length 3 specifying the order of the Arima model
#' @param prediction.steps The number of prediction steps
#' @param tojson If TRUE the results are returned in json format, default returns a list
#' 
#' @details 
#' This function automatically tests for stationarity of the input time series data using \code{\link{ts.stationary.test}}
#' function. Depending the nature of the time series data and the stationary tests there are four branches:
#' a.)short and non seasonal, b.)short and seasonal, c.)long and non seasonal and d.)long and seasonal.
#' For branches a and c \code{\link{ts.non.seas.model}} is used and for b and d \code{\link{ts.seasonal.model}} is used.
#' 
#' This function also decomposes both seasonal and non seasonal time series through \code{\link{ts.non.seas.decomp}} and 
#' \code{\link{ts.seasonal.decomp}} and forecasts h steps ahead the user selected(default h=1) using \code{\link{ts.forecast}}.
#' 
#' 
#' @return A json string with the parameters:
#' 
#' \itemize{
#' \item acf.param
#' \itemize{
#'  \item acf.parameters: 
#'  \itemize{ 
#'  \item acf The estimated acf values of the input time series
#'  \item acf.lag The lags at which the acf is estimated
#'  \item confidence.interval.up The upper limit of the confidence interval
#'  \item confidence.interval.low The lower limit of the confidence interval}
#'  
#'  \item pacf.parameters: 
#'  \itemize{ 
#'  \item pacf The estimated pacf values of the input time series
#'  \item pacf.lag The lags at which the pacf is estimated
#'  \item confidence.interval.up The upper limit of the confidence interval
#'  \item confidence.interval.low The lower limit of the confidence interval}
#'  
#'  \item acf.residuals.parameters: 
#'  \itemize{ \item acf.res The estimated acf values of the model residuals
#'  \item acf.res.lag The lags at which the acf is estimated of the model residuals
#'  \item confidence.interval.up The upper limit of the confidence interval
#'  \item confidence.interval.low The lower limit of the confidence interval}
#'  
#'  \item pacf.residuals.parameters: 
#'  \itemize{ 
#'  \item pacf.res The estimated pacf values of the model residuals
#'  \item pacf.res.lag The lags at which the pacf is estimated of the model residuals
#'  \item confidence.interval.up The upper limit of the confidence interval
#'  \item confidence.interval.low The lower limit of the confidence interval}}
#'  
#' \item param
#' \itemize{
#' \item stl.plot: 
#' \itemize{
#'  \item trend The estimated trend component
#'  \item trend.ci.up The estimated up limit for trend component (for non seasonal
#'  time series)
#'  \item trend.ci.low The estimated low limit for trend component (for non seasonal
#'  time series)
#'  \item seasonal The estimated seasonal component
#'  \item remainder The estimated remainder component
#'  \item time The time of the series was sampled}
#'
#' \item stl.general:
#' \itemize{
#'  \item stl.degree The degree of fit
#'  \item degfr The effective degrees of freedom for non seasonal time series
#'  \item degfr.fitted The fitted degrees of freedom for non seasonal time series
#'  \item fitted The model's fitted values }
#'  
#' \item residuals The residuals of the model (fitted innovations)
#' 
#' \item compare: 
#'  \itemize{
#'  \item arima.order The Arima order for seasonal time series
#'  \item arima.coef A vector of AR, MA and regression coefficients for seasonal time series
#'  \item arima.coef.se The standard error of the coefficients for seasonal time series
#'  \item covariance.coef The matrix of the estimated variance of the coefficients for seasonal time series
#'  \item resid.variance The residuals variance
#'  \item not.used.obs The number of not used observations for the fitting for seasonal time series
#'  \item used.obs The used observations for the fitting
#'  \item loglik The maximized log-likelihood (of the differenced data), or the approximation to it used
#'  \item aic The AIC value corresponding to the log-likelihood
#'  \item bic The BIC value corresponding to the log-likelihood
#'  \item gcv The generalized cross-validation statistic for non seasonal time series or
#'  \item aicc The second-order Akaike Information Criterion corresponding to the log-likelihood
#'  for seasonal time series}}
#'
#' \item forecasts
#' \itemize{
#' \item ts.model a string indicating the arima orders
#' \item data_year The time that time series data were sampled
#' \item data The time series values
#' \item predict_time The time that defined by the prediction_steps parameter
#' \item predict_values The predicted values that defined by the prediction_steps parameter
#' \item up80 The upper limit of the 80\% predicted confidence interval
#' \item low80 The lower limit of the 80\% predicted confidence interval
#' \item up95 The upper limit of the 95\% predicted confidence interval
#' \item low95 The lower limit of the 95\% predicted confidence interval}
#' }
#' @author Kleanthis Koupidis
#' 
#' 
#' @seealso \code{\link{ts.stationary.test}}, \code{\link{ts.acf}}, \code{\link{ts.seasonal.model}}, \code{\link{ts.seasonal.decomp}},
#' \code{\link{ts.non.seas.model}}, \code{\link{ts.non.seas.decomp}}, \code{\link{ts.forecast}}
#' 
#' @examples
#' ts.analysis(Athens_draft_ts, prediction.steps=3)
#' 
#' @rdname ts.analysis
#'
#' @export

ts.analysis<-function(tsdata, x.order=NULL, prediction.steps=1, tojson=T){
  
  # Stop if no time series data provided
  
  if( length(tsdata)<5 ) {
    stop("Invalid time series object.")}
  
  # Stop if no time series data provided
  
  if( is.nan(prediction.steps)==T | is.na(prediction.steps)==T |
      is.character(prediction.steps)==T | is.numeric(as.numeric(as.character(prediction.steps)))==F){
    stop("Please give an integer input as 'prediction.steps', e.g. prediction.steps= 4.")}
  
  
  # Extract the time series name
  #ts_name<-deparse(substitute(tsdata))
  
  #Stationarity testing
  check_stat=ts.stationary.test(tsdata)
    
  
  ## If TS is <20 and non seasonal 
  if ( length(tsdata)<=20 && stats::frequency(tsdata)<=2) {
    
    #decomposition
    decomposition <- ts.non.seas.decomp(tsdata)

    #model
    model <- ts.non.seas.model(tsdata,x.ord=x.order)
    
    ts_model <- model$model.summary
    residuals <- model$residuals
    
    model.param <- model[-1]
    
    ## If TS is <20 and seasonal 
  }else if ( length(tsdata)<=20 && stats::frequency(tsdata)>2) {
    
    #decomposition
    decomposition <- ts.seasonal.decomp(tsdata)
    
    #model
    
    model <- ts.seasonal.model(tsdata,x.ord=x.order)
    
    #model param for >20 and seasonal
    
    if(is.null(x.order)){
      ts_model <- decomposition$model.summary
      residuals <- decomposition$residuals_fitted$residuals
      
    }else if (is.null(x.order)==F){
      ts_model <- model$model.summary
      residuals <- model$residuals
    }
    
    decomposition <- decomposition[-1]
    model.param <- model[-1]
   
    ## If TS is >20 and non seasonal
    
    }else if(length(tsdata)>20 && stats::frequency(tsdata)<2) {
    
    # Decomposition
    decomposition <- ts.non.seas.decomp(tsdata)
    
    # Stationary 
    if(check_stat=="Stationary") {
      
      model <- ts.non.seas.model(tsdata,x.ord=x.order)
      
      # ΝΟΝ Stationary 
    }else if(check_stat=="Non Stationary") {
      
      #log transform
      #tsr <- log(tsdata+0.000000001) #log(tsdata)-> tsr
      #model
      model <- ts.non.seas.model(tsdata,x.ord=x.order)
      }
      
    #model param for >20 and non seasonal
   
    ts_model <- model$model.summary
    residuals <- model$residuals
    
    model.param <- model[-1]
     
    ## If TS is >20 and seasonal
  }else if(length(tsdata)>20 && stats::frequency(tsdata)>2) {
    
    #Decomposition
    decomposition <- ts.seasonal.decomp(tsdata)
    
    # Stationary 
    if(check_stat=="Stationary") {
      
      model <- ts.seasonal.model(tsdata,x.ord=x.order)
    
    # ΝΟΝ Stationary 
    }else if(check_stat=="Non Stationary") {
      
      #log transform
      #tsr <- log(tsdata+0.000000001)
      
      #model
      
      model <- ts.seasonal.model(tsdata,x.ord=x.order)} #log(tsdata)-> tsr
      
    #model param for >20 and seasonal
    
    if(is.null(x.order)){
      ts_model <- decomposition$model.summary
      residuals <- decomposition$residuals_fitted$residuals
      
    }else if (is.null(x.order)==F){
      ts_model <- model$model.summary
      residuals <- model$residuals
      }
    decomposition <- decomposition[-1]
    model.param <- model[-1]
}
  #ACF and PACF extraction before and after model fit
  acf.param <- ts.acf(tsdata,model_residuals=residuals, a=0.95)
  
  ## Forecasts
  forecasts <- ts.forecast(ts_modelx=ts_model,h=prediction.steps)
  
  ##  Parameter Extraction
  parameters <- list(acf.param=acf.param,
                     decomposition=decomposition,
                     model.param=model.param,
                     forecasts=forecasts)
  
  ##  to JSON
  
  if (tojson==T){
    
    parameters=jsonlite::toJSON(parameters)
  }
  
  ##  Return
  
  return(parameters)
} 
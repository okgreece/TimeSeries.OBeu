#' @title 
#' Time series analysis results for OBEU Time series
#'  
#' @description
#' Univariate time series analysis for short and long time series data using the appropriate model.
#' 
#' @usage ts.analysis(tsdata, h)
#' 
#' @param tsdata The input univariate time series data
#' @param h The number of prediction steps
#' 
#' @details 
#' This function automatically tests for stationarity of the input time series data using \code{\link{ts.stationary.test}}
#' function. Depending the nature of the time series data and the stationary tests there are four branches:
#' a.)short and non seasonal, b.)short and seasonal, c.)long and non seasonal and d.)long and seasonal.
#' For a,b and c branches \code{\link{ts.non.seas.model}} is used and for long and seasonal time series 
#' \code{\link{ts.seasonal}} is used.
#' 
#' This function also decomposes both seasonal and non seasonal time series and forecasts h steps ahead the user selected(default h=1).
#' 
#' 
#' @return A json string with the parameters:
#' 
#' \itemize{
#' \item acf.param
#' \itemize{
#'  \item acf.parameters: 
#'  \itemize{ 
#'  \item acf: The estimated acf values of the input time series
#'  \item acf.lag: The lags at which the acf is estimated
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}
#'  
#'  \item pacf.parameters: 
#'  \itemize{ 
#'  \item pacf: The estimated pacf values of the input time series
#'  \item pacf.lag: The lags at which the pacf is estimated
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}
#'  
#'  \item acf.residuals.parameters: 
#'  \itemize{ \item acf.res: The estimated acf values of the model residuals
#'  \item acf.res.lag: The lags at which the acf is estimated of the model residuals
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}
#'  
#'  \item pacf.residuals.parameters: 
#'  \itemize{ 
#'  \item pacf.res: The estimated pacf values of the model residuals
#'  \item pacf.res.lag: The lags at which the pacf is estimated of the model residuals
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}}
#'  
#' \item param
#' \itemize{
#' \item stl.plot: 
#' \itemize{
#'  \item trend: The estimated trend component
#'  \item trend.ci.up: The estimated up limit for trend component (for non seasonal
#'  time series)
#'  \item trend.ci.low: The estimated low limit for trend component (for non seasonal
#'  time series)
#'  \item seasonal: The estimated seasonal component
#'  \item remainder: The estimated remainder component
#'  \item time: The time of the series was sampled}
#'
#' \item stl.general:
#' \itemize{
#'  \item stl.degree: The degree of fit
#'  \item degfr: The effective degrees of freedom for non seasonal time series
#'  \item degfr.fitted: The fitted degrees of freedom for non seasonal time series
#'  \item fitted: The model's fitted values }
#'  
#' \item residuals: The residuals of the model (fitted innovations)
#' 
#' \item compare: 
#'  \itemize{
#'  \item arima.order: The Arima order for seasonal time series
#'  \item arima.coef: A vector of AR, MA and regression coefficients for seasonal time series
#'  \item arima.coef.se: The standard error of the coefficients for seasonal time series
#'  \item covariance.coef: The matrix of the estimated variance of the coefficients for seasonal time series
#'  \item resid.variance: The residuals variance
#'  \item not.used.obs: The number of not used observations for the fitting for seasonal time series
#'  \item used.obs: The used observations for the fitting
#'  \item loglik: The maximized log-likelihood (of the differenced data), or the approximation to it used
#'  \item aic: The AIC value corresponding to the log-likelihood
#'  \item bic: The BIC value corresponding to the log-likelihood
#'  \item gcv: The generalized cross-validation statistic for non seasonal time series or
#'  \item aicc: The second-order Akaike Information Criterion corresponding to the log-likelihood
#'  for seasonal time series}}
#'
#' \item forecasts
#' \itemize{
#' \item ts.model: a string indicating the arima orders
#' \item data_year: The time that time series data were sampled
#' \item data: The time series values
#' \item predict_time: The time that defined by the prediction_steps parameter
#' \item predict_values: The predicted values that defined by the prediction_steps parameter
#' \item up80: The upper limit of the 80\% predicted confidence interval
#' \item low80: The lower limit of the 80\% predicted confidence interval
#' \item up95: The upper limit of the 95\% predicted confidence interval
#' \item low95: The lower limit of the 95\% predicted confidence interval}
#' }
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso \code{\link{ts.analysis}}
#' 
#' @examples
#' ts.analysis(Athens_draft_ts,h=3)
#' @rdname ts.analysis
#' 
#' @import forecast
#' @import tseries
#' @import trend
#' @import jsonlite
#'
#' @export
############################################################################

ts.analysis<-function(tsdata,h=1){
  
  # Stop if no time series data provided
  
  if( length(tsdata)<3 ) {
    stop("Invalid time series object.")}
  
  # Stop if no time series data provided
  
  if( is.nan(h)==T | is.na(h)==T |
      is.character(h)==T | is.numeric(as.numeric(as.character(h)))==F){
    stop("Please give an integer input as 'h', e.g. h= 3.")}
  
  
  # Extract the time series name
  #ts_name<-deparse(substitute(tsdata))
  
  #Stationarity testing
  check_stat=ts.stationary.test(tsdata)
    
  
  ## If TS is <20 and non seasonal 
  if ( length(tsdata)<=20 && stats::frequency(tsdata)<=2) {
    
    #decomposition
    decomposition=ts.non.seas.decomp(tsdata)

    #model
    model<-ts.non.seas.model(tsdata)
    ts_model=model$model.summary
    residuals=model$residuals
    param<-list(decomposition,model[-1])
    
    ## If TS is <20 and seasonal 
  }else if ( length(tsdata)<=20 && stats::frequency(tsdata)>2) {
    
    #decomposition
    decomposition=stats::stl(tsdata)
    
    #model
    model<-ts.non.seas.model(tsdata)
    ts_model=model$model.summary
    residuals=model$residuals
    param<-list(decomposition,model[-1])
    
    ## If TS is >20 and non seasonal
  }else if(length(tsdata)>20 && stats::frequency(tsdata)<2) {
    
    #decomposition
    decomposition=ts.non.seas.decomp(tsdata)
    
    # Stationary 
    if(check_stat=="Stationary") {
      
      ts_model<-forecast::auto.arima(tsdata,trace=F)
      
      # ΝΟΝ Stationary 
    }else if(check_stat=="Non-Stationary") {
      
      #log transform
      tsr<-log(tsdata+0.000000001)
      #model
      ts_model<-forecast::auto.arima(tsr,trace=F)
      
    }
    param<-list(decomposition,model,ts_model)
    
    ## If TS is >20 and seasonal
  }else if(length(tsdata)>20 && stats::frequency(tsdata)>2) {
    
    #Model and decomposition
    tsmodel=ts.seasonal(tsdata)
    ts_model=tsmodel$ts_model
    residuals=tsmodel$residuals
    
    param<-tsmodel
  }	
  
  #ACF and PACF extraction before and after model fit
  acf.param<-ts.acf(tsdata,residuals, a=0.95)
  
  ## Forecasts
  forecasts<-  ts.forecast(ts_model,h)
  
  ##  Parameter Extraction
  par<-list(
            acf.param=acf.param,param=param,forecasts=forecasts)
  
  ##  to JSON
  
  parameters<-jsonlite::toJSON(par)
  
  ##  Return
  
  return(parameters)
}
## more comparison results
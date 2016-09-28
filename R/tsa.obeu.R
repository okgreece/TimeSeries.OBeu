#' @title 
#' Time series forecast results for OBEU Time series
#'  
#' @description
#' Univariate time series forecasts for short and long time series data using the appropriate model.
#' 
#' @usage tsa.obeu(tsdata, prediction_steps)
#' 
#' @param tsdata The input univariate time series data
#' @param prediction_steps The number of prediction steps
#' 
#' @details 
#' This function automatically selects the appropriate arima model that fits the input data using the auto.arima function(see forecast package). 
#' The model selection depends on the results of some diagnostic tests (acf,pacf,pp adf and kpss).
#' For short time series the selected arima model is among various orders of the AR part using 1st differences and MA(1), with the lower AIC.
#' 
#' @return A json string with the parameters:
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
#' @references add
#' 
#' @seealso add
#' 
#' @examples
#' tsa.obeu(Athens_draft_ts)
#' tsa.obeu(Athens_revised_ts,2)
#' tsa.obeu(Athens_reserved_ts,3)
#' tsa.obeu(Athens_approved_ts,4)
#' tsa.obeu(Athens_executed_ts,5)
#' 
#' @rdname tsa.obeu
#' 
#' @import forecast
#' @import tseries
#' @import trend
#' @import jsonlite
#'
#' @export
############################################################################

tsa.obeu<-function(tsdata,prediction_steps=1){
  
  # Stop if no time series data provided
  
  if( length(tsdata)<3 ) {
    stop("Invalid time series object.")}
  
  # Stop if no time series data provided
  
  if( is.nan(prediction_steps)==T | is.na(prediction_steps)==T |
      is.character(prediction_steps)==T | is.numeric(as.numeric(as.character(prediction_steps)))==F){
    stop("Please give an integer input as 'prediction_steps', e.g. prediction_steps= 3.")}
	
	
  # Extract the time series name
  ts_name<-deparse(substitute(tsdata))
  
  #Stationarity testing
  check_stat=stationary.test(tsdata)
  
  
  ## If TS is <20 and non seasonal 
  if ( length(tsdata)<=20 && frequency(tsdata)<2) {
	
	#decomposition
	decomposition=ts.non.seas.decomp(tsdata)

	#model
    model<-ts.non.seas.model(tsdata)
	ts_model<-model$ts_model
	param<-list(decomposition,model,ts_model)
	
	## If TS is <20 and seasonal 
	 }else if ( length(tsdata)<=20 && frequency(tsdata)>=2) {
	
	#decomposition
	decomposition=stl(tsdata)

	#model
    model<-ts.non.seas.model
	ts_model<-model$ts_model
	param<-list(decomposition,model,ts_model)
	## If TS is >20 and non seasonal
  }else if(length(tsdata)>20 && frequency(tsdata)<2) {
	
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
    }else if(length(tsdata)>20 && frequency(tsdata)>2) {
	#Model and decomposition
	tsmodel=ts.seasonal.obeu(tsdata)
	ts_model=tsmodel$ts_model$model.summary
	param<-list(tsmodel)
}	
	
	#ACF and PACF extraction before and after model fit
	acf.param<-ts.acf.obeu(tsdata,ts_model$residuals, a=0.95)
  
  ## Forecasts
  forecasts<-  forecast.ts.obeu(ts_model,h = 1)
  
  ##  Parameter Extraction
  par<-list(ts_name,param,forecasts)
  
  ##  to JSON
  
  parameters<-jsonlite::toJSON(par)
  
  ##  Return
  
  return(parameters)
}
## more comparison results
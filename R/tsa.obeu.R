#' @title 
#' Time series analysis results for OBEU Time series
#'  
#' @description
#' Univariate time series analysis for short and long time series data using the appropriate model.
#' 
#' @usage tsa.obeu(tsdata, h)
#' 
#' @param tsdata The input univariate time series data
#' @param h The number of prediction steps
#' 
#' @details 
#' This function automatically tests for stationarity of the input time series data in order to 
#' select the appropriate arima model that fits the input data using the auto.arima function(see forecast package). 
#' For short time series the selected arima model is among various orders of the AR part using 1st differences and MA(1), with the lower AIC.
#' This function also decomposes both seasonal and non seasonal time series and forecasts h steps ahead the user selected(default h=1).
#' 
#' 
#' @return A json string with the parameters (Missing some):
#' ts_name
#' param
#' forecasts
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso \code{\link{babbage.tsa.obeu}}
#' 
#' @examples
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

tsa.obeu<-function(tsdata,h=1){
  
  # Stop if no time series data provided
  
  if( length(tsdata)<3 ) {
    stop("Invalid time series object.")}
  
  # Stop if no time series data provided
  
  if( is.nan(h)==T | is.na(h)==T |
      is.character(h)==T | is.numeric(as.numeric(as.character(h)))==F){
    stop("Please give an integer input as 'h', e.g. h= 3.")}
  
  
  # Extract the time series name
  ts_name<-deparse(substitute(tsdata))
  
  #Stationarity testing
  check_stat=stationary.test(tsdata)
    
  
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
    tsmodel=ts.seasonal.obeu(tsdata)
    ts_model=tsmodel$ts_model
    residuals=tsmodel$residuals
    
    param<-tsmodel[-1]
  }	
  
  #ACF and PACF extraction before and after model fit
  acf.param<-ts.acf.obeu(tsdata,residuals, a=0.95)
  
  ## Forecasts
  forecasts<-  forecast.ts.obeu(ts_model,h)
  
  ##  Parameter Extraction
  par<-list(ts_name,param,forecasts)
  
  ##  to JSON
  
  parameters<-jsonlite::toJSON(par)#,force=T)
  
  ##  Return
  
  return(parameters)
}
## more comparison results
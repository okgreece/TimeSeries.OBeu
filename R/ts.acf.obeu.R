#' @title 
#' Extract the acf and pacf parameters of time series and their model's residuals 
#'  
#' @description
#' This function is included in tsa.obeu function and aims to extract the acf and pacf details 
#' of the input time series data and the acf and pacf of the residuals after fitting an Arima model. 
#' 
#' @usage ts.acf.obeu<-function(tsdata,model_residuals,a=0.95)
#' 
#' @param tsdata The input univariate time series data
#' @param model_residuals The model's residuals after fitting a model to the time series
#' @param a The significant level
#' 
#' @details 
#' 
#' The output of this function is a list with all the parameters needed for graphical purposes.
#' 
#' @return 
#' A list with the parameters:
#' 
#' acf The estimated acf values
#' acf.lag The lags at which the acf is estimated
#' pacf The estimated pacf values
#' pacf.lag The lags at which the pacf is estimated
#' ci.up The upper limit of the confidence interval
#' ci.low The lower limit of the confidence interval
#' acf.res The estimated acf values of the model’s residuals
#' acf.res.lag The lags at which the acf is estimated of the model’s residuals
#' pacf.res The estimated pacf values of the model’s residuals
#' pacf.res.lag The lags at which the pacf is estimated of the model’s residuals
#' ci.res.up The upper limit of the confidence interval
#' ci.res.low The lower limit of the confidence interval
#' 
#' 
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso add
#' 
#' @examples 
#' 
#' @rdname ts.acf.obeu
#' 
#' @import forecast
#'
#' @export
###################################################################################

ts.acf.obeu<-function(tsdata, model_residuals=NULL, a=0.95){
  model_residuals=as.numeric(unlist(model_residuals))
  # acf, pacf of ts 
  acff<-forecast::Acf(tsdata,plot=F)
  pacff<-forecast::Pacf(tsdata,plot=F)
  climits.up <- stats::qnorm((1 + a)/2)/sqrt(length(tsdata))
  climits.low <- stats::qnorm((1 - a)/2)/sqrt(length(tsdata))
  
  acf.parameters=list(  
    acf= as.vector(acff$acf),
    acf.lag= as.vector(acff$lag),
    confidence.interval.up=as.vector(climits.up),
    confidence.interval.low=as.vector(climits.low))
  
  pacf.parameters=list( 
    pacf= as.vector(pacff$acf),
    pacf.lag= as.vector(pacff$lag),
    confidence.interval.up=as.vector(climits.up),
    confidence.interval.low=as.vector(climits.low)
  )
  
  acf.residuals.parameters=NULL
  pacf.residuals.parameters=NULL
  
  if (!is.null(model_residuals)){
    # acf, pacf of model's residuals
    acff.res<-forecast::Acf(model_residuals,plot=F)
    pacff.res<-forecast::Pacf(model_residuals,plot=F)
    climits.res.up <- stats::qnorm((1 + a)/2)/sqrt(length(model_residuals))
    climits.res.low <- stats::qnorm((1 - a)/2)/sqrt(length(model_residuals))
    
    acf.residuals.parameters=list(
      acf.residuals= as.vector(acff.res$acf),
      acf.residuals.lag= as.vector(acff.res$lag),
      confidence.interval.up=as.vector(climits.up),
      confidence.interval.low=as.vector(climits.low))
    
    pacf.residuals.parameters=list(
      pacf.residuals= as.vector(pacff.res$acf),
      pacf.residuals.lag= as.vector(pacff.res$lag),
      confidence.interval.up=as.vector(climits.up),
      confidence.interval.low=as.vector(climits.low))
  }
  parameters<-list(
    acf.parameters=acf.parameters,
    pacf.parameters=pacf.parameters,
    acf.residuals.parameters=acf.residuals.parameters,
    pacf.residuals.parameters=pacf.residuals.parameters)
  
  # return
  return(parameters)
}
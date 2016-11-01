#' @title 
#' Extract the ACF and PACF parameters of time series and their model residuals 
#'  
#' @description
#' This function is included in ts.analysis function and aims to extract the ACF and PACF details 
#' of the input time series data and the ACF, PACF of the residuals after fitting an Arima model. 
#' 
#' @usage ts.acf(tsdata,model_residuals,a=0.95)
#' 
#' @param tsdata The input univariate time series data
#' @param model_residuals The model's residuals after fitting a model to the time series
#' @param a The significant level (default a=0.95)
#' 
#' @details 
#' 
#' This function is used internally in ts.analysis function and the output is a list with grouped 
#' ACF and PACF parameters of the input time series data, as well as the ACF and PACF parameters 
#' of the residuals needed for the graphical purposes in OBEU.
#' 
#' @return A list with the parameters:
#'\itemize{
#'  \item acf.parameters: 
#'  \itemize{ \item acf: The estimated acf values of the input time series
#'  \item acf.lag: The lags at which the acf is estimated
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}
#'  \item pacf.parameters: 
#'  \itemize{ \item pacf: The estimated pacf values of the input time series
#'  \item pacf.lag: The lags at which the pacf is estimated
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}
#'  \item acf.residuals.parameters: 
#'  \itemize{ \item acf.res: The estimated acf values of the model residuals
#'  \item acf.res.lag: The lags at which the acf is estimated of the model residuals
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}
#'  \item pacf.residuals.parameters: 
#'  \itemize{ \item pacf.res: The estimated pacf values of the model residuals
#'  \item pacf.res.lag: The lags at which the pacf is estimated of the model residuals
#'  \item confidence.interval.up: The upper limit of the confidence interval
#'  \item confidence.interval.low: The lower limit of the confidence interval}}
#' 
#' @author Kleanthis Koupidis
#' 
#' @seealso \code{\link{ts.analysis}}
#' 
#' @examples 
#' 
#' @rdname ts.acf
#' 
#' @import forecast
#'
#' @export
###################################################################################

ts.acf<-function(tsdata, model_residuals=NULL, a=0.95){
  
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
    
    model_residuals=as.numeric(unlist(model_residuals))
    
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
#' @title 
#' Model fit of seasonal time series
#'
#' @description
#' Model fit of seasonal time series
#'
#' @usage ts.seasonal.model(tsdata,x.ord=NULL)
#' 
#' @param tsdata The input univariate seasonal time series data
#' @param x.ord An integer vector of length 3 specifying the order of the Arima model
#' 
#' 
#' @details 
#' Model fit of seasonal time series using arima models of seasonal time series data.
#' The model with the lowest AIC value is selected for forecasts.
#' 
#' @return 
#' A list with the following components:
#' \itemize{
#' \item model.summary: 
#' \itemize{
#' \item ts_model: The summary model details returned as Arima object for internal use in ts.analysis function}
#'
#' \item model:
#' \itemize{
#'  \item ts_model: 
#'  \item arima.order: The Arima order
#'  \item arima.coef: A vector of AR, MA and regression coefficients
#'  \item arima.coef.se: The standard error of the coefficients }
#' 
#' \item residuals: The residuals of the model (fitted innovations)
#' 
#' \item compare:
#' \itemize{
#'  \item variance.coef: The matrix of the estimated variance of the coefficients
#'  \item resid.variance: The MLE of the innovations variance
#'  \item not.used.obs: The number of not used observations for the fitting
#'  \item used.obs: the number of used observations for the fitting
#'  \item loglik: The maximized log-likelihood (of the differenced data), or the approximation to it used
#'  \item aic: The AIC value corresponding to the log-likelihood
#'  \item bic: The BIC value corresponding to the log-likelihood
#'  \item aicc: The second-order Akaike Information Criterion corresponding to the log-likelihood}}
#'  
#' @author Kleanthis Koupidis
#' 
#' 
#' @seealso \code{\link{ts.analysis}}, Arima
#' 
#' @rdname ts.seasonal.model
#' @import forecast
#' @export
####################################################################################################################################

ts.seasonal.model<-function(tsdata,x.ord=NULL){
  
  if (is.null(x.ord)){
    ts_model<-forecast::auto.arima(tsdata)
  } else if (is.null(x.ord)==F){
    ts_model<-forecast::Arima(tsdata,order=x.ord)
  }
  
  
  model.summary = ts_model
  
  model=list(	# Model
    arima.order = ts_model$arma,
    arima.coef = ts_model$coef,
    arima.coef.se = round(sqrt(diag(ts_model$var.coef)),digits=4))
  
  residuals=list(	# Residuals
    residuals = ts_model$residuals)
  
  compare=list(
    resid.variance = ts_model$sigma2,
    variance.coef = ts_model$var.coef,
    
    # Used-not used observations
    not.used.obs = ts_model$n.cond,
    used.obs = ts_model$nobs,
    
    loglik = ts_model$loglik,
    aic = ts_model$aic,
    bic = ts_model$bic,
    aicc = ts_model$aicc)
  
  model.details<-list(model.summary=model.summary, 
                      model=model,
                      residuals=residuals,
                      compare=compare
                      )
  
  return(model.details)
}
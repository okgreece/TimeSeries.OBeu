#' @title 
#' Decomposition of seasonal time series
#'  
#' @description
#' Decomposition of seasonal time series data using stlm from forecast package. 
#' This function is used internally in tsa.obeu.
#' 
#' @usage ts.seasonal.obeu(tsdata)
#' 
#' @param tsdata The input univariate seasonal time series data
#' 
#' @details 
#' Decomposition of seasonal time series data is based on stlm from forecast package and
#' returns a list with useful parameters for OBEU.
#'
#' @return 
#' ts_model Summary of the arima model
#' stl.general
#'  trend The estimated trend component
#'  seasonal The estimated seasonal component
#'  remainder The estimated remainder component
#'  weights The final robust weights (if robust=F all weights are one)
#'  window A vector with the spans used for the "s", "t", and "l" smoothers
#'  stl.degree A vector with the polynomial degrees for these smoothers
#'  lambda Box-Cox transformation parameter
#'  tsdata.stl$x
#'  tsdata.stl$m
#'  fitted The model's fitted values 
#' ts_model
#'  arima.order The Arima order
#'  arima.coef A vector of AR, MA and regression coefficients
#'  arima.coef.se The standard error of the coefficients
#' residuals The residuals of the model (fitted innovations)
#' residuals.other 
#'  resid.variance The MLE of the innovations variance
#'  covariance.coef The matrix of the estimated variance of the coefficients
#' used.notused.observations
#'  not.used.obs The number of not “used” observations for the fitting
#'  used.obs the number of “used” observations for the fitting
#' comparison
#'  loglik The maximized log-likelihood (of the differenced data), or the approximation to it used
#'  aic The AIC value corresponding to the log-likelihood
#'  bic The BIC value corresponding to the log-likelihood
#'  aicc The second-order Akaike Information Criterion corresponding to the log-likelihood
#' data The time series data
#'
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso tsa.obeu, stlm (forecast package)
#' 
#' @examples
#'
#' @rdname ts.obeu
#' 
#' @import forecast
#' @import tseries
#' @import trend
#' @import jsonlite
#'
#' @export
############################################################################

ts.seasonal.obeu<-function(tsdata){
  options(warn=-1)

tsdata.stl <- forecast::stlm(tsdata, s.window="periodic", robust=FALSE, method="arima",
                             modelfunction=forecast::auto.arima,allow.multiplicative.trend=TRUE)
# Components   
trend <- tsdata.stl$stl$time.series[,"trend"]
season <- tsdata.stl$stl$time.series[,"seasonal"]
remainder <-  tsdata.stl$stl$time.series[,"remainder"]

stl.general=list( #stl general
				  trend=trend,
				  seasonal=season,
				  remainder=remainder,
				  weights=tsdata.stl$stl$weights,
                  window=tsdata.stl$stl$win,
                  stl.degree=tsdata.stl$stl$deg,
                  lambda=tsdata.stl$lambda,
                  tsdata.stl$x,##??
                  tsdata.stl$m,##??
                  fitted=tsdata.stl$fitted)
				  

model=list( 	  #model
				  arima.order=tsdata.stl$model$arma,
				  arima.coef=tsdata.stl$model$coef,
                  arima.coef.se=round(sqrt(diag(tsdata.stl$model$var.coef)),digits=4))
residuals=list(
                  residuals=tsdata.stl$model$residuals)
residuals.other=list(
				  resid.variance=tsdata.stl$model$sigma2,
                  covariance.coef=tsdata.stl$model$var.coef)
				  
used.notused.observations= list(#used-notused observations
                  not.used.obs=tsdata.stl$model$n.cond,
                  used.obs=tsdata.stl$model$nobs)
comparison=list(  #Comparison
				  loglik=tsdata.stl$model$loglik,
                  aic=tsdata.stl$model$aic,
                  bic=tsdata.stl$model$bic,
                  aicc=tsdata.stl$model$aicc)
				  
data=list(        #time series data
                  tsdata=tsdata.stl$model$x,
                  ts.name=tsdata.stl$model$series)
				  
model.details<-list(
					ts_model=tsdata.stl$model,
					stl.general=stl.general,
					ts_model=model,
					residuals=residuals,
					residuals.other,
					used.notused.observations=used.notused.observations,
					comparison=comparison,
					data=data)

return(model.details)

}
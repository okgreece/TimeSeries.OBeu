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
#' Decomposition of seasonal time series data through arima models is based on stlm from forecast package
#' and returns a list with useful parameters for OBEU.
#'
#' @return 
#' A list with the following components:
#' \itemize{
#' \item stl.plot: 
#' \itemize{
#'  \item trend: The estimated trend component
#'  \item seasonal: The estimated seasonal component
#'  \item remainder: The estimated remainder component
#'  \item time: The time of the series was sampled}
#'
#' \item stl.general:
#' \itemize{
#'  \item stl.degree: A vector with the polynomial degrees for these smoothers
#'  \item fitted: The model's fitted values }
#'  
#' \item residuals: The residuals of the model (fitted innovations)
#' 
#' \item compare: 
#'  \itemize{
#'  \item arima.order: The Arima order
#'  \item arima.coef: A vector of AR, MA and regression coefficients
#'  \item arima.coef.se: The standard error of the coefficients
#'  \item covariance.coef: The matrix of the estimated variance of the coefficients
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
#' @references add
#' 
#' @seealso \code{\link{tsa.obeu}}, stlm (forecast package)
#' 
#' @examples
#'
#' @rdname ts.seasonal.obeu
#' 
#' @import forecast
#' @import tseries
#' @import trend
#' @import jsonlite
#'
#' @export
##############################################################################################################

ts.seasonal.obeu<-function(tsdata){

tsdata.stl <- forecast::stlm(tsdata, s.window="periodic", robust=FALSE, method="arima",
                             modelfunction=forecast::auto.arima,allow.multiplicative.trend=TRUE)
# Components   
trend <- tsdata.stl$stl$time.series[,"trend"]
season <- tsdata.stl$stl$time.series[,"seasonal"]
remainder <-  tsdata.stl$stl$time.series[,"remainder"]

stl.plot=list( #stl plot
				  trend=trend,
				  seasonal=season,
				  remainder=remainder,
				  time=time(tsdata)
				  )

stl.general=list( #stl general
				          #weights=tsdata.stl$stl$weights,
                  #window=tsdata.stl$stl$win,
                  stl.degree=tsdata.stl$stl$deg,
                  #lambda=tsdata.stl$lambda,
                  fitted=tsdata.stl$fitted)

residuals=list(
          residuals=tsdata.stl$model$residuals)

				  

compare=list(  #Comparison
                  #model
                  arima.order=tsdata.stl$model$arma,
                  arima.coef=tsdata.stl$model$coef,
                  arima.coef.se=round(sqrt(diag(tsdata.stl$model$var.coef)),digits=4),
                  
                  variance.coefs=tsdata.stl$model$var.coef,
                  
                  resid.variance=tsdata.stl$model$sigma2,
                  not.used.obs=tsdata.stl$model$n.cond,
                  used.obs=tsdata.stl$model$nobs,
                  
				          loglik=tsdata.stl$model$loglik,
                  aic=tsdata.stl$model$aic,
                  bic=tsdata.stl$model$bic,
                  aicc=tsdata.stl$model$aicc)
				  

model.details<-list(
					stl.plot=stl.plot,
					stl.general=stl.general,
					residuals=residuals,
					compare=compare
					)

return(model.details)

}
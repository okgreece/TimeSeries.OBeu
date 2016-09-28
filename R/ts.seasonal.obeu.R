#' @title 
#' ...
#'  
#' @description
#' ...
#' 
#' @usage ts.seasonal.obeu(tsdata)
#' 
#' @param tsdata The input univariate time series data
#' 
#' @details 
#' ...
#' @return 
#' ...
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso add
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
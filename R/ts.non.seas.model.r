#' @title 
#' Decomposition of non seasonal time series
#'
#' @description
#' Decomposition of time series with no seasonal component
#'
#' @usage ts.non.seas.decomp(tsdata)
#' 
#' @param tsdata The input univariate non seasonal time series data
#' 
#' @details 
#' For non-seasonal time series there is no seasonal component. We use Local Polynomial Regression Fitting (LOESS)
#' in order to extract the trend component and then we subtract the trend from the initial values to extract the irregular terms.
#'
#' @return A list with the following components
#' timeseries The time series data
#' season There is no seasonality, this parameter is set NULL
#' loess.trend
#'  trend The trend values
#'  conf.interval.up The upper limit of the trend confidence interval
#'  conf.interval.low The lower limit of the trend confidence interval
#' loess.comparison
#'  number.observation The time series length
#'  loess.residuals The loess residuals
#'  loess.enp 
#'  loess.s 
#'  loess.onedelta 
#'  loess.twodelta 
#'  loess.tracehat 
#'  loess.divisor 
#'  loess.robust 
#'  loess.weights

#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso tsa.obeu, loess, predict.loess (stats package)
#' 
#' @examples
#' 
#' @rdname ts.non.seas.decomp
#' 
#'
#' @export
############################################################################

ts.non.seas.model<-function(tsdata){
  options(warn=-1)

#arima obeu
arima.obeu = function(tsdata,x) {
  tryCatch(forecast::Arima(tsdata,order=c(x,1,1)),
           warning = function(w) {print(paste("next order", x)); 
             NULL},
           error = function(e) {print(paste("next order", x)); 
             NULL} ) 
}

aic.obeu = function(aic,x) {
  tryCatch( c(aic=modelss[[i]]$aic,order=c(i,1,1)),
           warning = function(w) {print(paste("next order", x)); 
             NULL},
           error = function(e) {print(paste("next order", x)); 
             NULL} ) 
}


  #Selection of the appropriate model
  aiccc<-list()
  modelss<-list()
 
  for(i in 1:9){
  
    modelss[[i]]<-arima.obeu(tsdata,i)
    aiccc[[i]]<-aic.obeu(modelss[[i]]$aic,i)
  }
  
  df<-data.frame(matrix(unlist(aiccc),ncol=4,byrow = T))
  colnames(df)=c("aic","ar","diff","ma")
  mindf<-df[df$aic==min(df$aic),]
  x<-c(mindf$ar,mindf$diff,mindf$ma)
  
  #Fit the appropriate model
  ts_model<-forecast::Arima(tsdata,order=x)
  
  model.summary = ts_model
  
  model=list(			#model
    ts_model=ts_model$model,
    arima.order = ts_model$arma,
    arima.coef = ts_model$coef,
    arima.coef.se = round(sqrt(diag(ts_model$var.coef)),digits=4))
  
  residuals=list(		#residuals
    residuals = ts_model$residuals)
  residuals.other=list(
    resid.variance = ts_model$sigma2,
    covariance.coef = ts_model$var.coef)
  
  used.notused.observations=list(	#used-notused observations
    not.used.obs = ts_model$n.cond,
    used.obs = ts_model$nobs)
  
  comparison=list(		#Comparison
    loglik = ts_model$loglik,
    aic = ts_model$aic,
    bic = ts_model$bic,
    aicc = ts_model$aicc)
  
  data=list(				#time series data
    tsdata = ts_model$x,
    ts.name = ts_model$series)
  
  model.details<-list(model.summary=model.summary, model=model,residuals=residuals,residuals.other=residuals.other,used.notused.observations=used.notused.observations,comparison=comparison,data=data)
  
  return(model.details)
}

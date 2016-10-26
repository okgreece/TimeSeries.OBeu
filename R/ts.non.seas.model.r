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
#' @return A list with the following components:
#'
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso \code{\link{tsa.obeu}}, loess, predict.loess (stats package)
#' 
#' @examples
#' 
#' @rdname ts.non.seas.model
#' 
#'
#' @export
############################################################################

ts.non.seas.model<-function(tsdata){

#arima obeu
arima.obeu = function(tsdata,x) {
  tryCatch(forecast::Arima(tsdata,order=c(x,1,1)),
           warning = function(w) {print(paste("next order", x)); 
             NULL},
           error = function(e) {print(paste("next order", x)); 
             NULL} ) 
}
#aic.obeu
aic.obeu = function(aic,x) {
  tryCatch( c(aic=modelss[[x]]$aic,order=c(x,1,1)),
           warning = function(w) {print(paste("next order", x)); 
             NULL},
           error = function(e) {print(paste("next order", x)); 
             NULL} ) 
}


  #Selection of the appropriate model
  aiccc<-list()
  modelss<-list()
 
  for(i in 1:7){
  
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
  
  other=list(
    resid.variance = ts_model$sigma2,
    variance.coef = ts_model$var.coef)
  
  used.notused.observations=list(	#used-notused observations
    not.used.obs = ts_model$n.cond,
    used.obs = ts_model$nobs)
  
  comparison=list(		#Comparison
    loglik = ts_model$loglik,
    aic = ts_model$aic,
    bic = ts_model$bic,
    aicc = ts_model$aicc)
  
  #data=list(				#time series data
   # tsdata = ts_model$x,
  #  ts.name = ts_model$series)
  
  model.details<-list(model.summary=model.summary, 
                      model=model,
                      residuals=residuals,
                      other=other,
                      used.notused.observations=used.notused.observations,
                      comparison=comparison
                      #data=data
                      )
  
  return(model.details)
}

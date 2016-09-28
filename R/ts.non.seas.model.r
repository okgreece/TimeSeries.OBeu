#' @title 
#' ... 
#' @description
#' ...
#' @usage ts.non.seas.model(tsdata)
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
#' @rdname ts.non.seas.model
#' 
#' @import forecast
#'
#' @export
############################################################################

ts.non.seas.model<-function(tsdata){
  options(warn=-1)

#arima obeu
arima.obeu = function(tsdata,x) {
  tryCatch(forecast::Arima(tsdata,order=c(x,1,1)),
           warning = function(w) {print(paste("next order", x)); 
             "x"},
           error = function(e) {print(paste("next order", x)); 
             "x"} ) 
}


  #Selection of the appropriate model
  aiccc<-list()
  modelss<-list()
 
  for(i in 1:(length(tsdata)-3)){
  
    modelss[[i]]<-arima.obeu(tsdata,i)
    aiccc[[i]]<-c(aic=modelss[[i]]$aic,order=c(i,1,1))
  }
  df<-data.frame(matrix(unlist(aiccc),ncol=4,byrow = T))
  colnames(df)=c("aic","ar","diff","ma")
  mindf<-df[df$aic==min(df$aic),]
  x<-c(mindf$ar,mindf$diff,mindf$ma)
  
  #Fit the appropriate model
  ts_model<-forecast::Arima(tsdata,order=x)
  
  model=list(			#model
						ts_model=ts_model,
						model.summary = ts_model$model,
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
  model.details<-list(model=model,residuals=residuals,residuals.other=residuals.other,used.notused.observations=used.notused.observations,comparison=comparison,data=data)
					
  return(model.details)
}

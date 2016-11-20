#' @title 
#' Model fit of non seasonal time series
#'
#' @description
#' Model fit of non seasonal time series
#'
#' @usage ts.non.seas.model(tsdata,x.ord=NULL)
#' 
#' @param tsdata The input univariate non seasonal time series data
#' @param x.ord An integer vector of length 3 specifying the order of the Arima model
#' 
#' @details 
#' Model fit of non seasonal time series using arima models of non seasonal time series data.
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
#' @references add
#' 
#' @seealso \code{\link{ts.analysis}}, Arima
#' 
#' @examples
#' ts.non.seas.model(Athens_draft_ts)
#' 
#' @rdname ts.non.seas.model
#' 
#' @import forecast
#' @export
####################################################################################################################################

ts.non.seas.model<-function(tsdata, x.ord=NULL){

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

if (is.null(x.ord)==F|all(x.ord==c(0,0,0))==F){
  x=x.ord
} else  {
  #Selection of the appropriate model
  aiccc<-list()
  modelss<-list()
 
  for(i in 1:7){
  
    modelss[[i]]<-arima.obeu(tsdata,i)
    aiccc[[i]]<-aic.obeu(modelss[[i]]$aic,i)
  }
  
  df<-data.frame(matrix(unlist(aiccc),ncol=4,byrow = T))
  colnames(df)=c("aic","ar","diff","ma")
  mindf<-df[order(df$aic),]
  mindf<-mindf[2,]
  
  x<-c(mindf$ar,mindf$diff,mindf$ma)
} 
  # Fit the appropriate model
  ts_model<-forecast::Arima(y=tsdata, order=x)

  model.summary = ts_model
  
  model=list(	# Model
    arima.order = ts_model$arma,
    arima.coef = ts_model$coef,
    arima.coef.se = round(sqrt(diag(ts_model$var.coef)),digits=4))
  
 
  residuals_fitted=list(
    residuals=ts_model$residuals,
    fitted=stats::fitted(ts_model),
    time=stats::time(tsdata),
    line=0)
  
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
                      residuals_fitted=residuals_fitted,
                      compare=compare
                      )
  
  return(model.details)
}

#' @title 
#' Decomposition of seasonal time series
#'  
#' @description
#' Decomposition of seasonal time series data using stlm from forecast package. 
#' This function is used internally in ts.analysis.
#' 
#' @usage ts.seasonal.decomp(tsdata, tojson = FALSE)
#' 
#' @param tsdata The input univariate seasonal time series data
#' @param tojson If TRUE the results are returned in json format, default returns a list
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
#'  \item model.summary The summary object of the arima model to use in forecast if needed
#'  \item stl.win: An integer vector of length 3 indicating the spans used for the "s", "t", and "l" smoothers
#'  \item stl.degree: An integer vector of length 3 indicating the polynomial degrees for these smoothers}
#'  
#' \item residuals_fitted: 
#' \itemize{
#' \item residuals: The residuals of the model (fitted innovations)
#' \item fitted: The model's fitted values
#' \item time the time of tsdata
#' \item line The y=0 line} 
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
#' @seealso \code{\link{ts.analysis}}, \code{\link{stlm}} 
#' 
#' @rdname ts.seasonal.decomp
#'
#' @export
#' 

ts.seasonal.decomp <- function(tsdata, tojson = FALSE) {
  
  tsdata.stl <- forecast::stlm(
    tsdata, 
    s.window = "periodic", 
    robust = FALSE, 
    method = "arima",
    modelfunction = forecast::auto.arima,
    allow.multiplicative.trend = TRUE)
  
  # Components   
  trend <- tsdata.stl$stl$time.series[,"trend"]
  season <- tsdata.stl$stl$time.series[,"seasonal"]
  remainder <- tsdata.stl$stl$time.series[,"remainder"]
  
  model.summary <- tsdata.stl$model
  
  stl.plot <- list( #stl plot
    trend = trend,
    seasonal = season,
    remainder = remainder,
    time = stats::time(tsdata))
  
  
  stl.general <- list( #stl general
    stl.win = tsdata.stl$stl$win,
    stl.degree = tsdata.stl$stl$deg) #lambda=tsdata.stl$lambda
  
  residuals_fitted <- list(
    residuals = tsdata.stl$model$residuals,
    fitted = tsdata.stl$fitted,
    time = stats::time(tsdata),
    line = 0)
  
  compare <- list(  #Comparison
    #model
    arima.order = tsdata.stl$model$arma,
    arima.coef = tsdata.stl$model$coef,
    arima.coef.se = round(sqrt(diag(tsdata.stl$model$var.coef)), digits = 4),
    variance.coefs = tsdata.stl$model$var.coef,
    resid.variance = tsdata.stl$model$sigma2,
    not.used.obs = tsdata.stl$model$n.cond,
    used.obs = tsdata.stl$model$nobs,
    loglik = tsdata.stl$model$loglik,
    aic = tsdata.stl$model$aic,
    bic = tsdata.stl$model$bic,
    aicc = tsdata.stl$model$aicc)
  
  
  model.details <- list(
    model.summary = model.summary,
    stl.plot = stl.plot,
    stl.general= stl.general,
    residuals_fitted = residuals_fitted,
    compare = compare)
  
  if (tojson == TRUE) {
    model.details <- jsonlite::toJSON(model.details)
  }
  
  return(model.details)
}

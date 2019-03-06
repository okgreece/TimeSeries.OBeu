#' @title 
#' Non seasonal decomposition
#'
#' @description
#' Decomposition of time series with no seasonal component using local regression models  
#'
#' @usage ts.non.seas.decomp(tsdata, tojson = FALSE)
#' 
#' @param tsdata The input univariate non seasonal time series data
#' @param tojson If TRUE the results are returned in json format, default returns a list
#' 
#' @details 
#' For non-seasonal time series there is no seasonal component. Local regression and likelihood models (locfit package) are used
#' in order to extract the trend and remaider components.
#'
#' @return 
#' A list with the following components:
#' \itemize{
#' \item stl.plot: 
#' \itemize{
#'  \item trend The estimated trend component
#'  \item trend.ci.up The estimated up limit for trend component
#'  \item trend.ci.low The estimated low limit for trend component
#'  \item seasonal The estimated seasonal component
#'  \item remainder The estimated remainder component
#'  \item time The time of the series was sampled}
#'
#' \item stl.general:
#' \itemize{
#'  \item stl.degree The degree of fit
#'  \item degfr The effective degrees of freedom 
#'  \item degfr.fitted The fitted degrees of freedom }
#'  
#' \item residuals_fitted:
#' \itemize{
#' \item residuals The residuals of the model (fitted innovations)
#' \item fitted The model's fitted values 
#' \item time the time of tsdata
#' \item line The y=0 line}
#' 
#' \item compare: 
#'  \itemize{
#'  \item resid.variance The residuals variance
#'  \item used.obs The used observations for the fitting
#'  \item loglik The maximized log-likelihood (of the differenced data), or the approximation to it used
#'  \item aic The AIC value corresponding to the log-likelihood
#'  \item bic The BIC value corresponding to the log-likelihood
#'  \item gcv The generalized cross-validation statistic }}
#'  
#' @author Kleanthis Koupidis
#' 
#' @seealso \code{\link{ts.analysis}}, \code{\link[locfit]{locfit}}, 
#' \code{\link[locfit]{predict.locfit}}
#' @import locfit
#' 
#' @examples
#' ts.non.seas.decomp(Athens_draft_ts)
#' 
#' @rdname ts.non.seas.decomp
#' @export
#' 

ts.non.seas.decomp <- function(tsdata, tojson = FALSE){
  
  ## Decompose
  tsdata.stl <- locfit(tsdata ~ stats::time(tsdata))
  trend <- stats::fitted(tsdata.stl)
  seasonal <- NULL
  remainder <- tsdata - trend
  
  # Trend Confidence Intervals
  
  trend.ci.up <- stats::predict(tsdata.stl, data.frame(x=stats::time(tsdata))) +
    stats::predict(tsdata.stl, data.frame(x = stats::time(tsdata)), se = TRUE)$se.fit * 1.96
  
  trend.ci.low <- stats::predict(tsdata.stl, data.frame(x=stats::time(tsdata))) -
    stats::predict(tsdata.stl, data.frame(x = stats::time(tsdata)), se = TRUE)$se.fit * 1.96
  
  # Fitted
  degfr <- tsdata.stl$dp["df1"] 
  degfr.fitted <- tsdata.stl$dp["df2"] 
  stl.degree <- unique(lfknots(tsdata.stl, what = "deg"))
  fitted <- fitted(tsdata.stl, what = "coef")
  
  # Residuals
  residuals <- residuals(tsdata.stl)
  sigma2 <- sum( residuals^2 ) / (length(tsdata)-1)
  
  # Compare
  influence.function <- fitted(tsdata.stl, what = "infl")
  max.local.likelihood <- fitted(tsdata.stl, what = "lik")
  local.residual.deg.freedom <- fitted(tsdata.stl, what = "rdf")
  variance.function <- fitted(tsdata.stl, what = "vari")
  loglik <- tsdata.stl$dp["lk"]
  aic <- aic(tsdata.stl)["aic"]
  bic <- aic(tsdata.stl, pen = log(length(tsdata)))["aic"]
  gcv <- gcv(tsdata.stl)["gcv"]
  
  ##
  stl.plot <- list( #stl plot
    trend = trend,
    conf.interval.up = trend.ci.up,
    conf.interval.low = trend.ci.low,
    seasonal = seasonal,
    remainder = remainder,
    time = stats::time(tsdata))
  
  stl.general <- list( #stl general
    degfr = degfr,
    degfr.fitted = degfr.fitted,
    stl.degree = stl.degree)
  
  residuals_fitted <- list(
    residuals = residuals,
    fitted = fitted,
    time = stats::time(tsdata),
    line = 0)
  
  compare <- list(  #Compare
    resid.variance = sigma2,
    used.obs = tsdata.stl$eva$xev,
    loglik = loglik,
    aic = aic,
    bic = bic,
    gcv = gcv)
  
  model.details <- list(
    stl.plot = stl.plot,
    stl.general = stl.general,
    residuals_fitted = residuals_fitted,
    compare = compare)
  
  if (tojson == TRUE) {
    model.details <- jsonlite::toJSON(model.details)
  }
  
  return(model.details)
} 

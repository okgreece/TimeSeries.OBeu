#' @title 
#' Non seasonal decomposition
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
#' \itemize{
#' \item timeseries: The time series data
#' 
#' \item season: There is no seasonality, this parameter is set NULL
#' 
#' \item loess.trend:
#' 
#'  \itemize{
#'  \item trend: The trend values
#'  \item conf.interval.up: The upper limit of the trend confidence interval
#'  \item conf.interval.low: The lower limit of the trend confidence interval}
#'  
#'  
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso \code{\link{tsa.obeu}}, loess, predict.loess (stats package)
#' 
#' @examples
#' 
#' @rdname ts.non.seas.decomp
#' 
#' @export
############################################################################

ts.non.seas.decomp<-function(tsdata){

  ## decompose
  tsdata.stl <- stats::loess(tsdata~stats::time(tsdata))
  trend<-stats::fitted(tsdata.stl)
  seasonal <- NULL
  remainder <- tsdata - trend

  # Trend Confidence Intervals

  trend.ci.up= stats::predict(tsdata.stl, data.frame(x=stats::time(tsdata)))+
    stats::predict(tsdata.stl, data.frame(x=stats::time(tsdata)), se=TRUE)$se.fit*1.96
  
  #trend.ci.up=ts(trend.ci.up,
    #             start=min(time(tsdata)),
   #              end = max(time(tsdata)),
    #             frequency =frequency(trend) )

  trend.ci.low= stats::predict(tsdata.stl, data.frame(x=stats::time(tsdata)))-
    stats::predict(tsdata.stl, data.frame(x=stats::time(tsdata)), se=TRUE)$se.fit*1.96
  
 # trend.ci.low=ts(trend.ci.low,
           #       start=min(time(tsdata)),
          #        end = max(time(tsdata)),
         #         frequency =frequency(trend) )
  
  residuals=residuals(tsdata.stl)

  # loglik=locfit::aic(tsdata.stl)["lik"]
  
  # aic=locfit::aic(tsdata.stl)["aic"]
 
  
  ##
    stl.plot=list( #stl plot
    trend=trend,
    conf.interval.up = trend.ci.up,
    conf.interval.low = trend.ci.low,
    
    seasonal=seasonal,
    remainder=remainder,
    time=time(tsdata)
  )
  
   
    #  stl.general=list( #stl general
    #   #weights=tsdata.stl$stl$weights,
    #   window=tsdata.stl$stl$win,
    #   stl.degree=tsdata.stl$stl$deg,
    #   lambda=tsdata.stl$lambda,
    # fitted=tsdata.stl$fitted)
  
  residuals=list(
    residuals=residuals)

  # compare=list(  #Comparison
  #   #model
  #   order=2,
  #   coef=tsdata.stl$model$coef,
  #   arima.coef.se=round(sqrt(diag(tsdata.stl$model$var.coef)),digits=4),
    
  # variance.coefs=
    
  #  resid.variance=
  #  not.used.obs=
  #  used.obs=
    
  #   loglik=loglik,
  # aic=aic,
    # bic=
    #   aicc=
  # )
    

	model.details<-list(
	  stl.plot=stl.plot
	  #stl.general=stl.general,
	  #residuals=residuals,
	  #compare=compare
	)
  return(model.details)
} 

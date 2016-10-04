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

ts.non.seas.decomp<-function(tsdata){
    
  ## trend
  trend <- c()
  loess.model <- stats::loess(tsdata~stats::time(tsdata)) #,  span=0.3)
  trend<-stats::fitted(loess.model)
  seasonal <- NULL
  remainder <- tsdata - trend

  #Confidence Intervals
  ci = cbind(
    trend= stats::predict(loess.model, data.frame(x=stats::time(tsdata))),
  
    trend.ci.up= stats::predict(loess.model, data.frame(x=stats::time(tsdata)))+
      stats::predict(loess.model, data.frame(x=stats::time(tsdata)), se=TRUE)$se.fit*1.96,
  
    trend.ci.low= stats::predict(loess.model, data.frame(x=stats::time(tsdata)))-
      stats::predict(loess.model, data.frame(x=stats::time(tsdata)), se=TRUE)$se.fit*1.96
  )
  
  ##
  data=list(		#time series data
                    timeseries=tsdata)

  season=list(seasonal)
  
  loess.trend=list(			#loess trend
							trend= ci[,"trend"],
							conf.interval.up = ci[,"trend.ci.up"],
							conf.interval.low = ci[,"trend.ci.low"])
							
  loess.comparison=list(	#general characteristics
							number.observation= loess.model$n,
							loess.residuals = loess.model$residuals,
							loess.enp = loess.model$enp,
							loess.s = loess.model$s,
							loess.onedelta = loess.model$one.delta,
							loess.twodelta = loess.model$two.delta,
							loess.tracehat = loess.model$trace.hat,
							loess.divisor = loess.model$divisor,
							loess.robust = loess.model$robust,
							#loess.parameters = loess.model$pars,
							#loess.kd = loess.model$kd,
							loess.weights = loess.model$weights)

	parameters<-list(data=data,season=season,loess.trend=loess.trend,loess.comparison=loess.comparison)
  
  return(parameters)
}


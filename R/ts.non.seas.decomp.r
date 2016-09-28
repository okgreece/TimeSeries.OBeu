#' @title 
#' ... 
#' @description
#' ...
#' @usage ts.non.seas.decomp(tsdata)
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
#' @rdname ts.non.seas.decomp
#' 
#'
#' @export
############################################################################

ts.non.seas.decomp<-function(tsdata){
    
    options(warn=-1)

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


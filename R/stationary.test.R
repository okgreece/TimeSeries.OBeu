#' @title 
#' Stationarity testing
#'  
#' @description
#' This functions tests the stationarity of the input time series data.
#' 
#' @usage stationary.test(tsdata)
#' 
#' @param tsdata The input univariate time series data
#' 
#' @details 
#' This function tests the deterministic and stohastic trend of the input time series data. This function uses ACF and PACF functions 
#' from forecast package, Phillips-Perron test, Augmented Dickey–Fuller (ADF) test, Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test,
#' from tseries package and Mann-Kendall test for Monotonic Trend Cox and Stuart trend test from trend package.
#' 
#' Phillips-Perron test tests the null hypothesis of whether a unit root is present in a time series sample, 
#' against a stationary alternative. The truncation lag parameter is set to trunc(4*(n/100)^0.25), 
#' where n the length of the in input time series data
#'
#' Augmented Dickey–Fuller (ADF) test, tests the null hypothesis of whether a unit root is present in a time series sample.
#' The truncation lag parameter is set to trunc((n-1)^(1/3))), where n the lengthof the input time series data
#'
#' Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test, tests a null hypothesis that an observable time series is stationary
#' around a deterministic trend (i.e. trend-stationary) against the alternative of a unit root. 
#' The truncation lag parameter is set to trunc(3*sqrt(n)/13), where n the length of the input time series data
#'
#' The non-parametric Mann-Kendall test is used to detect monotonic trends. The null hypothesis, H0, is that the data 
#' come from a population with independent realizations and are identically distributed. 
#' The alternative hypothesis, HA, is that the data follow a monotonic trend.
#'
#' The Cox and Stuart test is a modified sign test. The null hypothesis, H0, is that the input time series assumed to be independent
#' against the fact that there is a time dependent trend (monotonic trend).
#'
#' @return 
#' A string indicating if the time series is stationary or non stationary for internal use in tsa.obeu.
#'
#' @author Kleanthis Koupidis
#' 
#' @references tseries, trend
#' 
#' @seealso \code{\link{tsa.obeu}}, Acf and Pacf(forecast package),pp.test, adf.test and kpss.test (tseries)
#' mk.test and cs.test (trend package)
#' 
#' @examples
#' 
#' @rdname stationary.test
#' 
#' @import forecast
#' @import tseries
#' @import trend
#'
#' @export
############################################################################

stationary.testa<-function(tsdata){
  options(warn=-1)

    #ACF
    acF<-forecast::Acf(tsdata,plot=F)
    acftest<-ifelse(acF$acf[2:length(acF$lag)]<1.96/sqrt(length(tsdata)) &&
                      acF$acf[2:length(acF$lag)]>-1.96/sqrt(length(tsdata)),
                    "Stationary","Non-Stationary")
    #PACF
    pacF<-forecast::Pacf(tsdata,plot=F)
    pacftest<-ifelse(pacF$acf[2:length(pacF$lag)]<1.96/sqrt(length(tsdata)) &&
                       pacF$acf[2:length(pacF$lag)]>-1.96/sqrt(length(tsdata)),
                     "Stationary","Non-Stationary")
    
    acf_pacf<-c(acftest,pacftest)
	
    # Phillips-Perron test
    
    pptest<-tseries::pp.test(tsdata,alternative = "stationary")
    
    # Augmented Dickey–Fuller (ADF) test
    if (length(tsdata)<7){
    adftest<-tseries::adf.test(tsdata,alternative = "stationary",k=0)
    }
    else {
      adftest<-tseries::adf.test(tsdata,alternative = "stationary")} 
    
    # Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test
    
    kpsstest<-tseries::kpss.test(tsdata)
    
    # Mann-Kendall Test For Monotonic Trend
    
    mktest<-trend::mk.test(tsdata)

    # Cox and Stuart trend test
    
    cstest<-trend::cs.test(tsdata)
    
    ## Summary of Tests Results

test_hypo<-data.frame("p_value"=c(pptest$p.value,adftest$p.value,kpsstest$p.value,
                                  mktest$pvalue,cstest$p.value))

rownames(test_hypo)<-c("Phillips-Perron test","Augmented Dickey–Fuller test",
                       "Kwiatkowski-Phillips-Schmidt-Shin test","Mann-Kendall Test","Cox and Stuart test")

test_hypo$result<-ifelse(test_hypo$p_value>0.05,"Non-Stationary","Stationary")

#Fix the Kpss Result
test_hypo$result[3]<-ifelse(kpsstest$p.value<0.05,"Non-Stationary","Stationary")
tests<-test_hypo$result

#Add acf,pacf results
tests[6]<-acf_pacf[1]
tests[7]<-acf_pacf[2]

# Most test show that the tsdata is (see check_stat result):

occurences<-max(table(tests))

check_stat<-names(which(table(tests) == occurences))

return(check_stat)
} 

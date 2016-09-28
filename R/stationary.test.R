#' @title 
#' ...
#'  
#' @description
#' ...
#' 
#' @usage stationary.test(tsdata)
#' 
#' @param tsdata The input univariate time series data
#' 
#' @details 
#' 
#' @return 
#'
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso add
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
stationary.test<-function(tsdata){
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
	
    ##############################
	
    # Phillips-Perron test for the null hypothesis that 'tsdata'
    # has a unit root against a stationary alternative.
    # the truncation lag parameter is set to trunc(4*(n/100)^0.25), where n=length(tsdata)
    
    pptest<-tseries::pp.test(tsdata,alternative = "stationary")
    
    # Augmented Dickey–Fuller (ADF) test
    # for the null that 'tsdata' has a unit root
    # the truncation lag parameter is set to trunc((n-1)^(1/3))), where n=length(tsdata)
    
    adftest<-tseries::adf.test(tsdata,alternative = "stationary")
    
    # Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test
    # the null hypothesis that 'tsdata' is level or trend stationary.
    # the truncation lag parameter is set to trunc(3*sqrt(n)/13), where n=length(tsdata)
    
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

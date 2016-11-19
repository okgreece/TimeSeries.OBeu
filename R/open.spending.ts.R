#' @title 
#' Read and analyze univariate time series data from Open Spending API
#'  
#' @description
#' Extract and analyze univariate time series data from Open Spending API, using the ts.analysis function.
#' 
#' @usage open_spending.ts(json_data,time,amount,order=NULL,prediction_steps=1)
#' 
#' @param json_data The json string, URL or file from Open Spending API
#' @param time Specify the time label of the json time series data
#' @param amount Specify the amount label of the json time series data
#' @param order An integer vector of length 3 specifying the order of the Arima model
#' @param prediction_steps The number of prediction steps
#' 
#' @details 
#' This function extracts the time series data provided by the Open Spending API, in order to
#' return the results from the \code{\link{ts.analysis}} function.
#' 
#' @return A json string with the resulted parameters of the ts.analysis function.
#'
#' @author Kleanthis Koupidis
#' 
#' @seealso \code{\link{ts.analysis}}
#' 
#' 
#' @rdname open_spending.ts
#' 
#' @import jsonlite
#' 
#' @export
#####################################################################################################

open_spending.ts <- function(json_data,time,amount,order=c(0,0,0),prediction_steps=1){
  
  data <- jsonlite::fromJSON(json_data)
  
  data<-data$cells 
  
  tim<-lapply(data[paste(time)], as.integer)
  
  tim<-c(do.call("cbind",tim))
  
  amounts<- c(do.call("cbind",data[paste(amount)]))
   
  df<-cbind(tim,amounts)
  
  df<-df[order(df[,"tim"],decreasing=F),]
  
  tsdata <- stats::ts(df[,"amounts"],start=min(df[,"tim"]),end=max(df[,"tim"]))
  tsdata <- stats::na.omit(tsdata)

  ts.result <- ts.analysis(tsdata, x.order=order ,prediction.steps=prediction_steps)
  
  return(ts.result)  
}

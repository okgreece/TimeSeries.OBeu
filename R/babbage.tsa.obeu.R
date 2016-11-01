#' @title 
#' Read and analyze time series data from Babbage API
#'  
#' @description
#' Extract and analyze time series data from babbage api, using the tsa.obeu function.
#' 
#' @usage babbage.tsa.obeu(json_data,time,amount,prediction_steps)
#' 
#' @param json_data The json string, URL or file from babbage api.
#' @param time Specify the time label of the json time series data.
#' @param amount Specify the amount label of the json time series data.
#' @param prediction_steps The number of prediction steps.
#' 
#' @details 
#' This function extracts the time series data provided by the Babbage API, in order to
#' return the results from the \code{\link{tsa.obeu}} function.
#' 
#' @return A json string with the resulted parameters of the tsa.obeu function.
#'
#' @author Kleanthis Koupidis
#' 
#' @seealso \code{\link{tsa.obeu}}
#' 
#' @examples
#' 
#' @rdname babbage.tsa.obeu
#' 
#' @import jsonlite
#' 
#' @export
############################################################################

babbage.tsa.obeu<-function(json_data,time,amount,prediction_steps=1){
  
  data <- jsonlite::fromJSON(json_data)
  
  data<-data$cells 
  
  tim<-lapply(data[paste(time)], as.integer)
  
  tim<-c(do.call("cbind",tim))
  
  amounts<- c(do.call("cbind",data[paste(amount)]))
   
  df<-cbind(tim,amounts)
  
  df<-df[order(df[,"tim"],decreasing=F),]
  
  tsdata <- stats::ts(df[,"amounts"],start=min(df[,"tim"]),end=max(df[,"tim"]))
  tsdata <- na.omit(tsdata)

  ts.result<-tsa.obeu(tsdata, prediction_steps)
  

  return(ts.result)  
}

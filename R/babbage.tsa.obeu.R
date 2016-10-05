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
#' This function extracts the time series data provided by the Babbage API.
#' A json file  analyze it using the tsa.obeu function.
#' 
#' @return A json string with the resulted parameters of the tsa.obeu function.
#'
#' @author Kleanthis Koupidis
#' 
#' @references add
#' 
#' @seealso \code{\link{tsa.obeu}}
#' 
#' @examples
#' 
#' 
#' 
#' @rdname babbage.tsa.obeu
#' 
#' @import jsonlite
#' 
#' @export
############################################################################
babbage.tsa.obeu<-function(json_data,time,amount,prediction_steps=1){
  
  data <- jsonlite::fromJSON(json_data)
  data<-data$cells[-3]
  names(data)=c("time","amount")
  data$time<-as.integer(data$time)
  
  # Check prediction_steps
  #if( is.nan(prediction_steps)==T | is.na(prediction_steps)==T |
   #   is.character(prediction_steps)==T | is.numeric(as.numeric(as.character(prediction_steps)))==F){
    #stop("Please give an integer input as 'prediction_steps', e.g. prediction_steps= 3.")}
  #import lubridate

  # Check time.
  #if( any(is.nan(data$time)==T) | any(is.na(data$time)==T) |
   #   is.numeric(as.numeric(as.character(data$time)))==F | 
    #  any(data$time>lubridate::year(now()))==T | any(data$time<1990)==T) {
  #  stop("Please give a valid year input as 'time', time should be greater than 1990 and
#         could not be greater than the current year")}
  
  # Check amount
  #if( any(is.nan(data$amount)==T) | any(is.na(data$amount)==T) |
  #    is.character(data$amount)==T | is.numeric(as.numeric(as.character(data$amount)))==F){
  #  stop("Please give a numeric input as 'amount'.")}
 
  tsdata<-stats::ts(data$amount,start=min(data$time),end=max(data$time))

  ts.result1<-tsa.obeu(tsdata,prediction_steps)
   
  ts.result<-list(ts.result1)

  return(ts.result1)  
}

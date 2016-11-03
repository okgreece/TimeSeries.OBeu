#' @title 
#' Read and analyze univariate time series data from csv files
#'  
#' @description
#' Extract and analyze univariate time series data from csv files, using the ts.analysis function.
#' 
#' @usage csv.ts.analysis(file, headers = TRUE, separator = ";", quote = "\"", dec = ","
#' time, amount, prediction_steps=1)
#' 
#' @param file The name of the file which the data are to be read from. This can be a compressed file. 
#' @param headers A logical value indicating whether the file contains the names of the variables as 
#' its first line. If missing, the value is determined from the file format: header is set to TRUE 
#' if and only if the first row contains one fewer field than the number of columns.
#' @param separator The separator character. Define the character that separates the values on 
#' each line of the file. If sep = "" (which is the default for read.table) the separator is 
#' one or more spaces, tabs, newlines or carriage returns.
#' @param quotes The set of quoting characters. To disable quoting altogether, use quote = "". 
#' See scan {https://stat.ethz.ch/R-manual/R-devel/library/base/html/scan.html} 
#' for the behaviour on quotes embedded in quotes. Quoting is only considered for 
#' columns read as character.
#' @param decimal The character used in the file for decimal points.
#' @param time Specify the time label of the json time series data
#' @param amount Specify the amount label of the json time series data
#' @param prediction_steps The number of prediction steps
#' 
#' @details 
#' This function extracts the time series data provided with a csv file, in order to
#' return the results from the \code{\link{ts.analysis}} function.
#' 
#' @return A json string with the resulted parameters of the ts.analysis function.
#'
#' @author Kleanthis Koupidis
#' 
#' @seealso \code{\link{ts.analysis}}, \code{\link{open_spending.ts}}
#' 
#' @rdname csv.ts.analysis
#' 
#' @import utils
#' @import jsonlite
#' 
#' @export
#####################################################################################################
csv.ts.analysis <- function(file, headers = TRUE, separator = ";",  quotes = "\"", decimal = ",", 
                            time, amount, prediction_steps=1 ){
  
  tsdata<-utils::read.csv2(file, header = headers , sep=separator , quote = quotes, dec = decimal)
  
  tsdata<-as.data.frame(tsdata)
  
  tim<-sapply(tsdata[paste(time)], as.integer)
  
  amounts<-sapply(tsdata[paste(amount)], as.integer)
  
  df<-as.data.frame(cbind(tim,amounts))
  
  df<-df[order(df[,paste(time)],decreasing=F),]
  
  tsdata <- stats::ts(df[,paste(amount)],start=min(df[,paste(time)]),end=max(df[,paste(time)]))
  
  tsdata <- stats::na.omit(tsdata)
  
  ts.result <- ts.analysis(tsdata, prediction_steps)
  
  return(ts.result)
}
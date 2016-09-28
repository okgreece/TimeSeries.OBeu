# TimeSeries.OBeu
R package-Time Series Analysis-OBEU

Install:

Load devtools library 
or install it if not already:install.packages("devtools")

library(devtools)

and then install TimeSeries.OBeu from github

install_github(TimeSeries.OBeu)

Use:
The basic function is: tsa.obeu(tsdata,h)
where tsdata: the time series data
and h: the prediction steps

e.g. tsa.obeu(Athens_approved_ts,4)

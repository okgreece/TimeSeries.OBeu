# TimeSeries.OBeu
R package-Time Series Analysis-OBEU

Install:

Load devtools library 
or install it if not already:install.packages("devtools")

library(devtools)

and then install TimeSeries.OBeu from github

install_github("okgreece/TimeSeries.OBeu")

Use:

The basic function is: tsa.obeu(tsdata,h)

where tsdata: the time series data

and h: the prediction steps.

The package includes the following time series data:
Athens_draft_ts, Athens_revised_ts, Athens_reserved_ts, Athens_approved_ts and Athens_executed_ts.

e.g. tsa.obeu(Athens_approved_ts,4)

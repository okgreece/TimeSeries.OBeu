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



#OpenCPU Short Guide- TimeSeries.OBeu

Go to: http://okfnrg.math.auth.gr/ocpu/test/

##How to use functions:

type to the endpoint:
../library/{name of the library}/R/{function}

see the function parameters:
select method: get

to run a function:
select method: post


#Time Series Example #1:

Go to http://okfnrg.math.auth.gr/ocpu/test/

##Copy and paste to the endpoint the following
../library/TimeSeries.OBeu/R/tsa.obeu

##Select Method: Post

##Add parameters and set:
Param Name: tsdata
Param Value one of the following:
Athens_draft_ts
Athens_revised_ts
Athens_reserved_ts
Athens_approved_ts
Athens_executed_ts



##Add another one parameters and set:
Param Name: h
Param Value: 4 (or another number)

Ready! Click on Ajax request!

To see the results: copy the /ocpu/tmp/{something}/R/.val (the first choice on the right panel)

and paste http://okfnrg.math.auth.gr/ocpu/tmp/{something}/R/.val on a new tab.

#Babbage Time Series - Example #2:

Go to http://okfnrg.math.auth.gr/ocpu/test/

##Copy and paste to the endpoint the following
../library/TimeSeries.OBeu/R/babbage.tsa.obeu

##Select Method: Post

##Add parameters and set:
Param Name: json_data
Param Value the following output from babbage or you can provide the URL:
 '{"page":0,"page_size":30,"total_cell_count":15,"cell":[],"status":"ok","cells":[{"global__fiscalPeriod__28951.notation":"2002","global__amount__0397f.sum":290501420.64,"global__amount__0397f__CZK.sum":9210928544.2325,"_count":4805},{"global__fiscalPeriod__28951.notation":"2003","global__amount__0397f.sum":311242291.07,"global__amount__0397f__CZK.sum":9832143974.9013,"_count":4988},{"global__fiscalPeriod__28951.notation":"2004","global__amount__0397f.sum":5268500701.1,"global__amount__0397f__CZK.sum":170688885714.24,"_count":10055},{"global__fiscalPeriod__28951.notation":"2005","global__amount__0397f.sum":2542887761.01,"global__amount__0397f__CZK.sum":77204615312.025,"_count":2032},{"global__fiscalPeriod__28951.notation":"2006","global__amount__0397f.sum":14803951786.68,"global__amount__0397f__CZK.sum":429758720367.32,"_count":13632},{"global__fiscalPeriod__28951.notation":"2007","global__amount__0397f.sum":16188514346.44,"global__amount__0397f__CZK.sum":445588857385.76,"_count":22798},{"global__fiscalPeriod__28951.notation":"2008","global__amount__0397f.sum":18231035815.89,"global__amount__0397f__CZK.sum":480643028250.12,"_count":24176},{"global__fiscalPeriod__28951.notation":"2009","global__amount__0397f.sum":19079541164.68,"global__amount__0397f__CZK.sum":511808691742.54,"_count":26250},{"global__fiscalPeriod__28951.notation":"2010","global__amount__0397f.sum":22738650575.01,"global__amount__0397f__CZK.sum":597685430364.14,"_count":87667},{"global__fiscalPeriod__28951.notation":"2011","global__amount__0397f.sum":24961375670.57,"global__amount__0397f__CZK.sum":626230992823.26,"_count":134352},{"global__fiscalPeriod__28951.notation":"2012","global__amount__0397f.sum":261513607691.41,"global__amount__0397f__CZK.sum":7030666436872.5,"_count":147556},{"global__fiscalPeriod__28951.notation":"2013","global__amount__0397f.sum":268946402299.09,"global__amount__0397f__CZK.sum":7226220232913.8,"_count":150079},{"global__fiscalPeriod__28951.notation":"2014","global__amount__0397f.sum":255222816704.9,"global__amount__0397f__CZK.sum":6907598086283.4,"_count":176019},{"global__fiscalPeriod__28951.notation":"2015","global__amount__0397f.sum":22976062973.62,"global__amount__0397f__CZK.sum":636276111928.46,"_count":213777},{"global__fiscalPeriod__28951.notation":"2016","global__amount__0397f.sum":12051686541.16,"global__amount__0397f__CZK.sum":325672725401.77,"_count":161797}],"order":[["global__fiscalPeriod__28951.fiscalPeriod","asc"]],"aggregates":["","_count"],"summary":{"global__amount__0397f.sum":945126777743.27,"global__amount__0397f__CZK.sum":25485085887878},"attributes":[""]}'

Param Name: time (optional)
Param Value:  the time label of the json file: global__fiscalPeriod__28951.global__fiscalPeriod__28951
Param Name: amount (optional)
Param Value: the amount label of the json file: amount__0397f.sum
Param Name: prediction_steps (optional but necessary, default=1)
Param Value: Select a number e.g. 4.

Ready! Click on Ajax request!

To see the results: copy the /ocpu/tmp/{something}/R/.val (the first choice on the right panel)

and paste http://okfnrg.math.auth.gr/ocpu/tmp/{something}/R/.val on a new tab.


#Further Details:

https://www.opencpu.org/help.html

https://cran.r-project.org/web/packages/opencpu/vignettes/opencpu-server.pdf

https://www.opencpu.org/jslib.html


#About the package:
Two choices to install it in R or RStudio:

##Github directly:
https://github.com/okgreece/TimeSeries.OBeu 

##Source package:
https://github.com/okgreece/TimeSeries.OBeu-source-package 


##This package is almost ready.

##Some details in documentation are missing, but everything will be included in the near future.




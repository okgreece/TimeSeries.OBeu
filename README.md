TimeSeries.OBeu <img src="obeu_logo.png" align="right" />
================
Kleanthis Koupidis
November 7, 2016

[![Build Status](https://travis-ci.org/okgreece/TimeSeries.OBeu.svg?branch=master)](https://travis-ci.org/okgreece/TimeSeries.OBeu) [![Pending Pull-Requests](http://githubbadges.herokuapp.com/okgreece/TimeSeries.OBeu/pulls.svg)](https://github.com/okgreece/TimeSeries.OBeu/pulls) [![Github Issues](http://githubbadges.herokuapp.com/okgreece/TimeSeries.OBeu/issues.svg)](https://github.com/okgreece/TimeSeries.OBeu/issues)

This document describes the use of the functions implemented in TimeSeries.OBeu package both in R and OpenCPU environments.

Install:
========

Load *devtools* library or install it if not already:

``` r
install.packages("devtools")
```

Then install *TimeSeries.OBeu* from [Github](https://github.com/okgreece/TimeSeries.OBeu)

``` r
devtools::install_github("okgreece/TimeSeries.OBeu")
```

And load the library

``` r
library(TimeSeries.OBeu)
```

Use:
====

The basic function is:

``` r
ts.analysis(tsdata,x.order=NULL,h=1)
```

where *tsdata*: The input univariate time series data

*x.order*: An integer vector of length 3 specifying the order of the Arima model

and *h*: The number of prediction steps

### R Example

The package includes the following time series data: Athens\_draft\_ts, Athens\_revised\_ts, Athens\_reserved\_ts, Athens\_approved\_ts and Athens\_executed\_ts.

``` r
Athens_draft_ts
```

    ## Time Series:
    ## Start = 2004 
    ## End = 2015 
    ## Frequency = 1 
    ##  [1] 720895000 628937000 618550000 724830000 858942000 919508000 977488000
    ##  [8] 931607000 866517393 667108000 773422555 759559284

We select for example the approved budget phase of Athens and we want to predict 4 years ahead.

``` r
ts.analysis(tsdata = Athens_approved_ts, h=4)
```

    ## {"acf.param":{"acf.parameters":{"acf":[1,0.427,0.2297,0.0089,-0.3902,-0.4655,-0.4154,-0.2643,0.0666,-0.0114,0.1292],"acf.lag":[0,1,2,3,4,5,6,7,8,9,10],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]},"pacf.parameters":{"pacf":[0.427,0.0579,-0.1328,-0.4531,-0.2344,-0.0823,0.0364,0.1811,-0.3903,-0.1957],"pacf.lag":[1,2,3,4,5,6,7,8,9,10],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]},"acf.residuals.parameters":{"acf.residuals":[1,0.8971,0.7744,0.6318,0.4935,0.3315,0.1667,0.0055,-0.1488,-0.2798,-0.4134,-0.5285,-0.6243,-0.6042,-0.5435,-0.4789],"acf.residuals.lag":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]},"pacf.residuals.parameters":{"pacf.residuals":[0.8971,-0.1556,-0.1647,-0.0498,-0.2177,-0.1298,-0.104,-0.1368,-0.0431,-0.2127,-0.1321,-0.1286,0.4207,0.1141,-0.1564],"pacf.residuals.lag":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]}},"decomposition":{"stl.plot":{"trend":[360012371.9634,391868560.3084,417978199.8346,439847142.5411,463812675.9175,480132135.4567,474280623.7425,447176163.9944,415849991.8416,391854304.8383,368735090.9983,346126790.4334],"conf.interval.up":[403551040.584,418548312.6872,444512497.1456,468779231.3226,493998369.6188,511126974.9337,505275463.2195,477361857.6957,444782080.6231,418388602.1494,395414843.3771,389665459.0539],"conf.interval.low":[316473703.3429,365188807.9296,391443902.5235,410915053.7596,433626982.2162,449137295.9798,443285784.2656,416990470.2932,386917903.0601,365320007.5273,342055338.6195,302588121.8129],"seasonal":{},"remainder":[-13555336.3634,26529076.0616,3784067.6154,-26995430.5011,1577023.4325,15517526.6133,-23743663.9025,15346833.9756,-28643554.6416,18164834.7217,-5109418.2683,9732.8766],"time":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015]},"stl.general":{"degfr":[5.4179],"degfr.fitted":[5.1011],"stl.degree":[2]},"residuals_fitted":{"residuals":[-13555336.3634,26529076.0616,3784067.6154,-26995430.5011,1577023.4325,15517526.6133,-23743663.9025,15346833.9756,-28643554.6416,18164834.7217,-5109418.2683,9732.8766],"fitted":[360012371.9634,391868560.3084,417978199.8346,439847142.5411,463812675.9175,480132135.4567,474280623.7425,447176163.9944,415849991.8416,391854304.8383,368735090.9983,346126790.4334],"time":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015],"line":[0]},"compare":{"resid.variance":[349972697518044],"used.obs":[2004,2015,2009.5,2006.75,2012.25],"loglik":[-1.92484983634924e+015],"aic":[3.8496996726985e+015],"bic":[3.8496996726985e+015],"gcv":[1.06628791415824e+015]}},"model.param":{"model":{"arima.order":[7,1,0,0,1,1,0],"arima.coef":[-0.9637,-0.581,-0.1171,-0.133,-0.5996,-0.938,-0.9714,0.9599],"arima.coef.se":[0.1148,0.1635,0.1049,0.1018,0.1621,0.1189,0.0282,0.3363]},"residuals_fitted":{"residuals":[346450.485,11699374.0863,4230536.3792,-2325345.2192,6863520.8046,11325598.3683,-1351533.687,746001.8157,-8689324.3457,-9669016.4674,-5516104.5795,804750.6828],"fitted":[346110585.115,406698262.2837,417531731.0708,415177057.2592,458526178.5454,484324063.7017,451888493.527,461776996.1543,395895761.5457,419688156.0274,369141777.3095,345331772.6272],"time":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015],"line":[0]},"compare":{"resid.variance":[179376526357111],"variance.coef":[[0.0132,0.0166,0.001,0.0009,0.0165,0.0133,0.0001,-0.0005],[0.0166,0.0267,0.0071,0.0062,0.0259,0.0174,0.0008,-0.0005],[0.001,0.0071,0.011,0.0103,0.0062,0.0016,0.0007,-0.0002],[0.0009,0.0062,0.0103,0.0104,0.0063,0.001,0.0001,-0.0001],[0.0165,0.0259,0.0062,0.0063,0.0263,0.0168,0,-0.0004],[0.0133,0.0174,0.0016,0.001,0.0168,0.0141,0.0008,-0.0004],[0.0001,0.0008,0.0007,0.0001,0,0.0008,0.0008,-0.0001],[-0.0005,-0.0005,-0.0002,-0.0001,-0.0004,-0.0004,-0.0001,0.1131]],"not.used.obs":[0],"used.obs":[11],"loglik":[-201.6265],"aic":[421.2529],"bic":[424.834],"aicc":[601.2529]}},"forecasts":{"ts.model":["ARIMA(7,1,1)"],"data_year":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015],"data":[346457035.6,418397636.37,421762267.45,412851712.04,465389699.35,495649662.07,450536959.84,462522997.97,387206437.2,410019139.56,363625672.73,346136523.31],"predict_time":[2016,2017,2018,2019],"predict_values":[403723793.9441,438530491.052,425067542.5783,492987303.4195],"up80":[422158684.2712,462758827.6426,450470626.9097,522443016.2977],"low80":[385288903.6169,414302154.4614,399664458.2469,463531590.5412],"up95":[431917525.7233,475584534.2912,463918207.4477,538035928.7986],"low95":[375530062.1648,401476447.8128,386216877.7089,447938678.0403]}}

We can set a specific order to fit the model for the same prediction steps. We select for example a three-length vector of p=2 (*AR order*) d=1 (*first differences*) and q=1 (*MA order*).

``` r
ts.analysis(tsdata = Athens_approved_ts, x.order=c(2,1,1), h=4)
```

    ## {"acf.param":{"acf.parameters":{"acf":[1,0.427,0.2297,0.0089,-0.3902,-0.4655,-0.4154,-0.2643,0.0666,-0.0114,0.1292],"acf.lag":[0,1,2,3,4,5,6,7,8,9,10],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]},"pacf.parameters":{"pacf":[0.427,0.0579,-0.1328,-0.4531,-0.2344,-0.0823,0.0364,0.1811,-0.3903,-0.1957],"pacf.lag":[1,2,3,4,5,6,7,8,9,10],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]},"acf.residuals.parameters":{"acf.residuals":[1,0.8783,0.7675,0.6439,0.4713,0.3196,0.1389,-0.025,-0.1582,-0.3168,-0.4324,-0.5216,-0.6233,-0.5885,-0.5264,-0.4685],"acf.residuals.lag":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]},"pacf.residuals.parameters":{"pacf.residuals":[0.8783,-0.0174,-0.1165,-0.2978,-0.0463,-0.231,-0.0611,-0.0323,-0.2269,-0.0651,-0.0724,-0.2332,0.4003,0.1587,-0.1082],"pacf.residuals.lag":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],"confidence.interval.up":[0.5658],"confidence.interval.low":[-0.5658]}},"decomposition":{"stl.plot":{"trend":[360012371.9634,391868560.3084,417978199.8346,439847142.5411,463812675.9175,480132135.4567,474280623.7425,447176163.9944,415849991.8416,391854304.8383,368735090.9983,346126790.4334],"conf.interval.up":[403551040.584,418548312.6872,444512497.1456,468779231.3226,493998369.6188,511126974.9337,505275463.2195,477361857.6957,444782080.6231,418388602.1494,395414843.3771,389665459.0539],"conf.interval.low":[316473703.3429,365188807.9296,391443902.5235,410915053.7596,433626982.2162,449137295.9798,443285784.2656,416990470.2932,386917903.0601,365320007.5273,342055338.6195,302588121.8129],"seasonal":{},"remainder":[-13555336.3634,26529076.0616,3784067.6154,-26995430.5011,1577023.4325,15517526.6133,-23743663.9025,15346833.9756,-28643554.6416,18164834.7217,-5109418.2683,9732.8766],"time":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015]},"stl.general":{"degfr":[5.4179],"degfr.fitted":[5.1011],"stl.degree":[2]},"residuals_fitted":{"residuals":[-13555336.3634,26529076.0616,3784067.6154,-26995430.5011,1577023.4325,15517526.6133,-23743663.9025,15346833.9756,-28643554.6416,18164834.7217,-5109418.2683,9732.8766],"fitted":[360012371.9634,391868560.3084,417978199.8346,439847142.5411,463812675.9175,480132135.4567,474280623.7425,447176163.9944,415849991.8416,391854304.8383,368735090.9983,346126790.4334],"time":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015],"line":[0]},"compare":{"resid.variance":[349972697518044],"used.obs":[2004,2015,2009.5,2006.75,2012.25],"loglik":[-1.92484983634924e+015],"aic":[3.8496996726985e+015],"bic":[3.8496996726985e+015],"gcv":[1.06628791415824e+015]}},"model.param":{"model":{"arima.order":[2,1,0,0,1,1,0],"arima.coef":[0.2276,0.3376,-0.3907],"arima.coef.se":[0.5415,0.3187,0.4981]},"residuals_fitted":{"residuals":[346456.8396,67632468.6255,15425665.6095,-28018783.1693,42513583.2893,37897797.6867,-54930506.5594,-9421526.2646,-66495756.8129,9929033.954,-22280768.57,-23336591.7572],"fitted":[346110578.7604,350765167.7445,406336601.8405,440870495.2093,422876116.0607,457751864.3833,505467466.3994,471944524.2346,453702194.0129,400090105.606,385906441.3,369473115.0672],"time":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015],"line":[0]},"compare":{"resid.variance":[2.18854353855532e+015],"variance.coef":[[0.2932,-0.0023,-0.2237],[-0.0023,0.1016,-0.0235],[-0.2237,-0.0235,0.2481]],"not.used.obs":[0],"used.obs":[11],"loglik":[-208.2431],"aic":[424.4863],"bic":[426.0778],"aicc":[431.1529]}},"forecasts":{"ts.model":["ARIMA(2,1,1)"],"data_year":[2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015],"data":[346457035.6,418397636.37,421762267.45,412851712.04,465389699.35,495649662.07,450536959.84,462522997.97,387206437.2,410019139.56,363625672.73,346136523.31],"predict_time":[2016,2017,2018,2019],"predict_values":[335611724.2568,327312551.1334,321870901.5624,317830880.8227],"up80":[395565105.4483,405491792.1078,425609955.6796,442414805.7617],"low80":[275658343.0654,249133310.159,218131847.4451,193246955.8837],"up95":[427302508.3391,446877382.3647,480526093.6955,508365551.8402],"low95":[243920940.1746,207747719.9021,163215709.4292,127296209.8051]}}

OpenCPU Short Guide - TimeSeries.OBeu
=====================================

Go to: <http://okfnrg.math.auth.gr/ocpu/test/>

How to use functions:
---------------------

Type to the endpoint:

``` r
 ../library/ {name of the library} /R/ {function}
```

If you want to see the function parameters you should:

-   Select Method:

``` r
Get
```

and in order to run a function you should:

-   Select Method:

``` r
Post
```

Example \#1:
------------

1 Go to <http://okfnrg.math.auth.gr/ocpu/test/>

2 Copy and paste the following function to the endpoint

``` r
../library/TimeSeries.OBeu/R/ts.analysis
```

3 *Select Method*:

``` r
 Post
```

4 **Add parameters** and set:

Define the input time series data:

-   *Param Name*:

``` r
tsdata
```

-   *Param Value* one of the following:

``` r
Athens_draft_ts

Athens_revised_ts

Athens_reserved_ts

Athens_approved_ts

Athens_executed_ts
```

Define the order of the model fits and forecasts (*optional*):

-   *Param Name*:

``` r
x.order
```

-   *Param Value* -for example:

``` r
c(2,1,1)
```

Define the prediction steps (*default is 1 prediction step*):

-   *Param Name*:

``` r
h
```

-   *Param Value* -for example:

``` r
4 # (or another number, default h=1)
```

5 Ready! Click on **Ajax request**!

6 To see the results:

copy the */ocpu/tmp/{this}/R/.val* (the first choice on the right panel)

7 and paste <http://okfnrg.math.auth.gr/ocpu/tmp/> {this} /R/.val on a new tab.

Example \#2 - Rudolf/Open Spending Time Series
----------------------------------------------

1 Go to <http://okfnrg.math.auth.gr/ocpu/test/>

2 Copy and paste the following function to the endpoint

``` r
../library/TimeSeries.OBeu/R/open_spending.ts
```

3 *Select Method*:

``` r
Post
```

4 **Add parameters** and set:

Define the input time series data:

-   *Param Name*:

``` r
json_data
```

-   *Param Value* -the following output from open spending api or you can provide the also **json URL**:

``` r
'{"page":0,
"page_size":30,
"total_cell_count":15,
"cell":[],
"status":"ok",
"cells":
[{"global__fiscalPeriod__28951.notation":"2002",
"global__amount__0397f.sum":290501420.64,
"global__amount__0397f__CZK.sum":9210928544.2325,"_count":4805},
{"global__fiscalPeriod__28951.notation":"2003",
"global__amount__0397f.sum":311242291.07,
"global__amount__0397f__CZK.sum":9832143974.9013,"_count":4988},
{"global__fiscalPeriod__28951.notation":"2004",
"global__amount__0397f.sum":5268500701.1,
"global__amount__0397f__CZK.sum":170688885714.24,"_count":10055},
{"global__fiscalPeriod__28951.notation":"2005",
"global__amount__0397f.sum":2542887761.01,
"global__amount__0397f__CZK.sum":77204615312.025,"_count":2032},
{"global__fiscalPeriod__28951.notation":"2006",
"global__amount__0397f.sum":14803951786.68,
"global__amount__0397f__CZK.sum":429758720367.32,"_count":13632},
{"global__fiscalPeriod__28951.notation":"2007",
"global__amount__0397f.sum":16188514346.44,
"global__amount__0397f__CZK.sum":445588857385.76,"_count":22798},
{"global__fiscalPeriod__28951.notation":"2008",
"global__amount__0397f.sum":18231035815.89,
"global__amount__0397f__CZK.sum":480643028250.12,"_count":24176},
{"global__fiscalPeriod__28951.notation":"2009",
"global__amount__0397f.sum":19079541164.68,
"global__amount__0397f__CZK.sum":511808691742.54,"_count":26250},
{"global__fiscalPeriod__28951.notation":"2010",
"global__amount__0397f.sum":22738650575.01,
"global__amount__0397f__CZK.sum":597685430364.14,"_count":87667},
{"global__fiscalPeriod__28951.notation":"2011",
"global__amount__0397f.sum":24961375670.57,
"global__amount__0397f__CZK.sum":626230992823.26,"_count":134352},
{"global__fiscalPeriod__28951.notation":"2012",
"global__amount__0397f.sum":261513607691.41,
"global__amount__0397f__CZK.sum":7030666436872.5,"_count":147556},
{"global__fiscalPeriod__28951.notation":"2013",
"global__amount__0397f.sum":268946402299.09,
"global__amount__0397f__CZK.sum":7226220232913.8,"_count":150079},
{"global__fiscalPeriod__28951.notation":"2014",
"global__amount__0397f.sum":255222816704.9,
"global__amount__0397f__CZK.sum":6907598086283.4,"_count":176019},
{"global__fiscalPeriod__28951.notation":"2015",
"global__amount__0397f.sum":22976062973.62,
"global__amount__0397f__CZK.sum":636276111928.46,"_count":213777},
{"global__fiscalPeriod__28951.notation":"2016",
"global__amount__0397f.sum":12051686541.16,
"global__amount__0397f__CZK.sum":325672725401.77,"_count":161797}],
"order":[["global__fiscalPeriod__28951.fiscalPeriod","asc"]],
"aggregates":["","_count"],
"summary":{"global__amount__0397f.sum":945126777743.27,
"global__amount__0397f__CZK.sum":25485085887878},
"attributes":[""]}'
```

Define the time label of the json input:

-   *Param Name*:

``` r
time
```

-   *Param Value* -for example:

``` r
"global__fiscalPeriod__28951.notation" # or

'global__fiscalPeriod__28951.notation'
```

Define the amount label of the json input:

-   *Param Name*:

``` r
amount
```

-   *Param Value* -for example:

``` r
'global__amount__0397f.sum' # or

"global__amount__0397f.sum"
```

Define the order of the model fits and forecasts (*optional*):

-   *Param Name*:

``` r
order
```

-   *Param Value* -for example:

``` r
c(3,1,1)
```

Define the prediction steps (*default is 1 prediction step*):

-   *Param Name*:

``` r
prediction_steps
```

-   *Param Value* -for example:

``` r
4 # (or another number, default h=1)
```

5 Ready! Click on **Ajax request**!

6 To see the results:

copy the */ocpu/tmp/{this}/R/.val* (the first choice on the right panel)

7 and paste <http://okfnrg.math.auth.gr/ocpu/tmp/> {this} /R/.val on a new tab.

Further Details:
================

-   <https://www.opencpu.org/help.html>

-   <https://cran.r-project.org/web/packages/opencpu/vignettes/opencpu-server.pdf>

-   <https://www.opencpu.org/jslib.html>

Github:
=======

-   <https://github.com/okgreece/TimeSeries.OBeu>

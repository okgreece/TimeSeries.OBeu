TimeSeries.OBeu <img src="okfgr2.png" align="right" />
================
Kleanthis Koupidis, Charalampos Bratsas

[![Build Status](https://travis-ci.org/okgreece/TimeSeries.OBeu.svg?branch=master)](https://travis-ci.org/okgreece/TimeSeries.OBeu) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/TimeSeries.OBeu)](https://cran.r-project.org/package=TimeSeries.OBeu) [![Pending Pull-Requests](http://githubbadges.herokuapp.com/okgreece/TimeSeries.OBeu/pulls.svg)](https://github.com/okgreece/TimeSeries.OBeu/pulls) [![Github Issues](http://githubbadges.herokuapp.com/okgreece/TimeSeries.OBeu/issues.svg)](https://github.com/okgreece/TimeSeries.OBeu/issues) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1-6666ff.svg)](https://cran.r-project.org/) [![Licence](https://img.shields.io/badge/licence-GPL--2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)

[TimeSeries.OBeu](https://okgreece.github.io/TimeSeries.OBeu/)
==============================================================

Εstimate and return the necessary parameters for time series visualizations, used in [OpenBudgets.eu](http://openbudgets.eu/). It includes functions to test stationarity (with ACF, PACF, Phillips Perron test, Augmented Dickey Fuller (ADF) test, Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test, Mann Kendall Test For Monotonic Trend and Cox and Stuart trend test), decompose, model and forecast Budget time series data of municipalities across Europe, according to the [OpenBudgets.eu data model](https://github.com/openbudgets/data-model).

This package can generally be used to extract visualization parameters convert them to JSON format and use them as input in a different graphical interface. Most functions can have general use out of the [OpenBudgets.eu data model](https://github.com/openbudgets/data-model). You can see detailed information [here](https://okgreece.github.io/TimeSeries.OBeu/).

``` r
# install TimeSeries.OBeu- cran stable version
install.packages(TimeSeries.OBeu) 
# or
# alternatively install the development version from github
devtools::install_github("okgreece/TimeSeries.OBeu")
```

Load library `TimeSeries.OBeu` <img src="obeu_logo.png" align="right" />

``` r
library(TimeSeries.OBeu)
```

Time Series analysis in a call
==============================

`ts.analysis` is used to estimate *autocorrelation and partial autocorrelation* of input time series data, *autocorrelation and partial autocorrelation* of the model residuals, *trend*, *seasonal* (if exists) and *remainder* components, model parameters such as arima order, arima coefficients etc. and the desired *forecasts* with their corresponding confidence intervals.

`ts.analysis` returns by default a json object, if `tojson` parameter is `FALSE` returns a list object and the default forecast step is set to 1.

``` r
results = ts.analysis(Athens_executed_ts, prediction.steps = 2, tojson=TRUE) # json string format
jsonlite::prettify(results) # use prettify of jsonlite library to add indentation to the returned JSON string
```

    ## {
    ##     "acf.param": {
    ##         "acf.parameters": {
    ##             "acf": [
    ##                 1,
    ##                 0.5302,
    ##                 0.2018,
    ##                 -0.1397,
    ##                 -0.4059,
    ##                 -0.3556,
    ##                 -0.3939,
    ##                 -0.073,
    ##                 0.071,
    ##                 0.0676,
    ##                 0.0285
    ##             ],
    ##             "acf.lag": [
    ##                 0,
    ##                 1,
    ##                 2,
    ##                 3,
    ##                 4,
    ##                 5,
    ##                 6,
    ##                 7,
    ##                 8,
    ##                 9,
    ##                 10
    ##             ],
    ##             "confidence.interval.up": [
    ##                 0.5658
    ##             ],
    ##             "confidence.interval.low": [
    ##                 -0.5658
    ##             ]
    ##         },
    ##         "pacf.parameters": {
    ##             "pacf": [
    ##                 0.5302,
    ##                 -0.1102,
    ##                 -0.2817,
    ##                 -0.2903,
    ##                 0.0427,
    ##                 -0.2781,
    ##                 0.2318,
    ##                 -0.1163,
    ##                 -0.1829,
    ##                 -0.209
    ##             ],
    ##             "pacf.lag": [
    ##                 1,
    ##                 2,
    ##                 3,
    ##                 4,
    ##                 5,
    ##                 6,
    ##                 7,
    ##                 8,
    ##                 9,
    ##                 10
    ##             ],
    ##             "confidence.interval.up": [
    ##                 0.5658
    ##             ],
    ##             "confidence.interval.low": [
    ##                 -0.5658
    ##             ]
    ##         },
    ##         "acf.residuals.parameters": {
    ##             "acf.residuals": [
    ##                 1,
    ##                 0.8646,
    ##                 0.7284,
    ##                 0.6039,
    ##                 0.4589,
    ##                 0.3295,
    ##                 0.154,
    ##                 -0.0016,
    ##                 -0.1241,
    ##                 -0.2595,
    ##                 -0.3802,
    ##                 -0.5098,
    ##                 -0.6276,
    ##                 -0.5885,
    ##                 -0.5207,
    ##                 -0.4629
    ##             ],
    ##             "acf.residuals.lag": [
    ##                 0,
    ##                 1,
    ##                 2,
    ##                 3,
    ##                 4,
    ##                 5,
    ##                 6,
    ##                 7,
    ##                 8,
    ##                 9,
    ##                 10,
    ##                 11,
    ##                 12,
    ##                 13,
    ##                 14,
    ##                 15
    ##             ],
    ##             "confidence.interval.up": [
    ##                 0.5658
    ##             ],
    ##             "confidence.interval.low": [
    ##                 -0.5658
    ##             ]
    ##         },
    ##         "pacf.residuals.parameters": {
    ##             "pacf.residuals": [
    ##                 0.8646,
    ##                 -0.0756,
    ##                 -0.0325,
    ##                 -0.1597,
    ##                 -0.0335,
    ##                 -0.2937,
    ##                 -0.0528,
    ##                 -0.046,
    ##                 -0.162,
    ##                 -0.1372,
    ##                 -0.2201,
    ##                 -0.2078,
    ##                 0.4336,
    ##                 0.1187,
    ##                 -0.0519
    ##             ],
    ##             "pacf.residuals.lag": [
    ##                 1,
    ##                 2,
    ##                 3,
    ##                 4,
    ##                 5,
    ##                 6,
    ##                 7,
    ##                 8,
    ##                 9,
    ##                 10,
    ##                 11,
    ##                 12,
    ##                 13,
    ##                 14,
    ##                 15
    ##             ],
    ##             "confidence.interval.up": [
    ##                 0.5658
    ##             ],
    ##             "confidence.interval.low": [
    ##                 -0.5658
    ##             ]
    ##         }
    ##     },
    ##     "decomposition": {
    ##         "stl.plot": {
    ##             "trend": [
    ##                 488397393.1418,
    ##                 472512470.2132,
    ##                 473063423.4632,
    ##                 487284165.8361,
    ##                 519914575.4529,
    ##                 549044538.1588,
    ##                 546747322.373,
    ##                 517885722.1941,
    ##                 482561749.3098,
    ##                 453474237.5907,
    ##                 423909078.1086,
    ##                 393617768.8078
    ##             ],
    ##             "conf.interval.up": [
    ##                 525849686.6413,
    ##                 495462595.8887,
    ##                 495888427.5844,
    ##                 512171768.3956,
    ##                 545880538.4877,
    ##                 575706534.5367,
    ##                 573409318.7509,
    ##                 543851685.2289,
    ##                 507449351.8693,
    ##                 476299241.7119,
    ##                 446859203.7842,
    ##                 431070062.3073
    ##             ],
    ##             "conf.interval.low": [
    ##                 450945099.6423,
    ##                 449562344.5377,
    ##                 450238419.3421,
    ##                 462396563.2766,
    ##                 493948612.4181,
    ##                 522382541.7809,
    ##                 520085325.9951,
    ##                 491919759.1593,
    ##                 457674146.7503,
    ##                 430649233.4695,
    ##                 400958952.4331,
    ##                 356165475.3083
    ##             ],
    ##             "seasonal": {
    ## 
    ##             },
    ##             "remainder": [
    ##                 3494473.6582,
    ##                 -6782427.4232,
    ##                 -360030.3632,
    ##                 -20859217.1961,
    ##                 8715868.0371,
    ##                 20321961.4412,
    ##                 -24805255.823,
    ##                 12476896.9759,
    ##                 -25628827.4798,
    ##                 18714394.8393,
    ##                 -9197723.9686,
    ##                 1891498.0822
    ##             ],
    ##             "time": [
    ##                 2004,
    ##                 2005,
    ##                 2006,
    ##                 2007,
    ##                 2008,
    ##                 2009,
    ##                 2010,
    ##                 2011,
    ##                 2012,
    ##                 2013,
    ##                 2014,
    ##                 2015
    ##             ]
    ##         },
    ##         "stl.general": {
    ##             "degfr": [
    ##                 5.4179
    ##             ],
    ##             "degfr.fitted": [
    ##                 5.1011
    ##             ],
    ##             "stl.degree": [
    ##                 2
    ##             ]
    ##         },
    ##         "residuals_fitted": {
    ##             "residuals": [
    ##                 3494473.6582,
    ##                 -6782427.4232,
    ##                 -360030.3632,
    ##                 -20859217.1961,
    ##                 8715868.0371,
    ##                 20321961.4412,
    ##                 -24805255.823,
    ##                 12476896.9759,
    ##                 -25628827.4798,
    ##                 18714394.8393,
    ##                 -9197723.9686,
    ##                 1891498.0822
    ##             ],
    ##             "fitted": [
    ##                 488397393.1418,
    ##                 472512470.2132,
    ##                 473063423.4632,
    ##                 487284165.8361,
    ##                 519914575.4529,
    ##                 549044538.1588,
    ##                 546747322.373,
    ##                 517885722.1941,
    ##                 482561749.3098,
    ##                 453474237.5907,
    ##                 423909078.1086,
    ##                 393617768.8078
    ##             ],
    ##             "time": [
    ##                 2004,
    ##                 2005,
    ##                 2006,
    ##                 2007,
    ##                 2008,
    ##                 2009,
    ##                 2010,
    ##                 2011,
    ##                 2012,
    ##                 2013,
    ##                 2014,
    ##                 2015
    ##             ],
    ##             "line": [
    ##                 0
    ##             ]
    ##         },
    ##         "compare": {
    ##             "resid.variance": [
    ##                 258964785657684
    ##             ],
    ##             "used.obs": [
    ##                 2004,
    ##                 2015,
    ##                 2009.5,
    ##                 2006.75,
    ##                 2012.25
    ##             ],
    ##             "loglik": [
    ##                 -1.42430632111726e+015
    ##             ],
    ##             "aic": [
    ##                 2.84861264223453e+015
    ##             ],
    ##             "bic": [
    ##                 2.84861264223453e+015
    ##             ],
    ##             "gcv": [
    ##                 789007322850175
    ##             ]
    ##         }
    ##     },
    ##     "model.param": {
    ##         "model": {
    ##             "arima.order": [
    ##                 2,
    ##                 1,
    ##                 0,
    ##                 0,
    ##                 1,
    ##                 1,
    ##                 0
    ##             ],
    ##             "arima.coef": [
    ##                 -0.2,
    ##                 0.304,
    ##                 0.1684
    ##             ],
    ##             "arima.coef.se": [
    ##                 0.5484,
    ##                 0.3034,
    ##                 0.5345
    ##             ]
    ##         },
    ##         "residuals_fitted": {
    ##             "residuals": [
    ##                 491891.5916,
    ##                 -24734053.7839,
    ##                 4848198.2411,
    ##                 2291242.5086,
    ##                 58442566.7297,
    ##                 45241384.5452,
    ##                 -65806529.4317,
    ##                 -2362503.8375,
    ##                 -56932278.2406,
    ##                 7600701.1455,
    ##                 -33386168.56,
    ##                 -29710365.5401
    ##             ],
    ##             "fitted": [
    ##                 491399975.2084,
    ##                 490464096.5739,
    ##                 467855194.8589,
    ##                 464133706.1314,
    ##                 470187876.7603,
    ##                 524125115.0548,
    ##                 587748595.9817,
    ##                 532725123.0075,
    ##                 513865200.0706,
    ##                 464587931.2845,
    ##                 448097522.7,
    ##                 425219632.4301
    ##             ],
    ##             "time": [
    ##                 2004,
    ##                 2005,
    ##                 2006,
    ##                 2007,
    ##                 2008,
    ##                 2009,
    ##                 2010,
    ##                 2011,
    ##                 2012,
    ##                 2013,
    ##                 2014,
    ##                 2015
    ##             ],
    ##             "line": [
    ##                 0
    ##             ]
    ##         },
    ##         "compare": {
    ##             "resid.variance": [
    ##                 1.96694555616403e+015
    ##             ],
    ##             "variance.coef": [
    ##                 [
    ##                     0.3007,
    ##                     0.0586,
    ##                     -0.2532
    ##                 ],
    ##                 [
    ##                     0.0586,
    ##                     0.0921,
    ##                     -0.029
    ##                 ],
    ##                 [
    ##                     -0.2532,
    ##                     -0.029,
    ##                     0.2857
    ##                 ]
    ##             ],
    ##             "not.used.obs": [
    ##                 0
    ##             ],
    ##             "used.obs": [
    ##                 11
    ##             ],
    ##             "loglik": [
    ##                 -207.6519
    ##             ],
    ##             "aic": [
    ##                 423.3037
    ##             ],
    ##             "bic": [
    ##                 424.8953
    ##             ],
    ##             "aicc": [
    ##                 429.9704
    ##             ]
    ##         }
    ##     },
    ##     "forecasts": {
    ##         "ts.model": [
    ##             "ARIMA(2,1,1)"
    ##         ],
    ##         "data_year": [
    ##             2004,
    ##             2005,
    ##             2006,
    ##             2007,
    ##             2008,
    ##             2009,
    ##             2010,
    ##             2011,
    ##             2012,
    ##             2013,
    ##             2014,
    ##             2015
    ##         ],
    ##         "data": [
    ##             491891866.8,
    ##             465730042.79,
    ##             472703393.1,
    ##             466424948.64,
    ##             528630443.49,
    ##             569366499.6,
    ##             521942066.55,
    ##             530362619.17,
    ##             456932921.83,
    ##             472188632.43,
    ##             414711354.14,
    ##             395509266.89
    ##         ],
    ##         "predict_time": [
    ##             2016,
    ##             2017
    ##         ],
    ##         "predict_values": [
    ##             376873927.5331,
    ##             374763602.0598
    ##         ],
    ##         "up80": [
    ##             433711072.5831,
    ##             453885516.7986
    ##         ],
    ##         "low80": [
    ##             320036782.483,
    ##             295641687.3209
    ##         ],
    ##         "up95": [
    ##             463798839.7076,
    ##             495770128.4028
    ##         ],
    ##         "low95": [
    ##             289949015.3585,
    ##             253757075.7167
    ##         ]
    ##     }
    ## }
    ## 

`ts.analysis` uses internally the functions `ts.stationary.test`,`ts.acf`,`ts.non.seas.decomp`,`ts.seasonal.decomp`, `ts.seasonal.model`, `ts.non.seas.model` and `ts.forecast`. However, these functions can be used independently and depends on the user requirements (see package manual or vignettes).

Time series analysis on OpenBudgets.eu platform
===============================================

`open_spending.ts` is designed to estimate and return the autocorrelation parameters, time series model parameters and the forecast parameters of [OpenBudgets.eu](http://openbudgets.eu/) time series datasets.

The input data must be a JSON link according to the [OpenBudgets.eu data model](https://github.com/openbudgets/data-model). The user should specify the amount and time variables, future steps to be predicted (default is 1 step forward) and the arima order (if not specified the most appropriate model will be selected according to AIC value).

`open_spending.ts` estimates and returns the json data (that are described with the [OpenBudgets.eu data model](https://github.com/openbudgets/data-model)), using `ts.analysis` function.

``` r
#example openbudgets.eu time series data
sample.ts.data = 
'{"page":0,
"page_size": 30,
"total_cell_count": 15,
"cell": [],
"status": "ok",
"cells": [{
        "global__fiscalPeriod__28951.notation": "2002",
        "global__amount__0397f.sum": 290501420.64,
        "global__amount__0397f__CZK.sum": 9210928544.2325,
        "_count": 4805
    },
    {
        "global__fiscalPeriod__28951.notation": "2003",
        "global__amount__0397f.sum": 311242291.07,
        "global__amount__0397f__CZK.sum": 9832143974.9013,
        "_count": 4988
    },
    {
        "global__fiscalPeriod__28951.notation": "2004",
        "global__amount__0397f.sum": 5268500701.1,
        "global__amount__0397f__CZK.sum": 170688885714.24,
        "_count": 10055
    },
    {
        "global__fiscalPeriod__28951.notation": "2005",
        "global__amount__0397f.sum": 2542887761.01,
        "global__amount__0397f__CZK.sum": 77204615312.025,
        "_count": 2032
    },
    {
        "global__fiscalPeriod__28951.notation": "2006",
        "global__amount__0397f.sum": 14803951786.68,
        "global__amount__0397f__CZK.sum": 429758720367.32,
        "_count": 13632
    },
    {
        "global__fiscalPeriod__28951.notation": "2007",
        "global__amount__0397f.sum": 16188514346.44,
        "global__amount__0397f__CZK.sum": 445588857385.76,
        "_count": 22798
    },
    {
        "global__fiscalPeriod__28951.notation": "2008",
        "global__amount__0397f.sum": 18231035815.89,
        "global__amount__0397f__CZK.sum": 480643028250.12,
        "_count": 24176
    },
    {
        "global__fiscalPeriod__28951.notation": "2009",
        "global__amount__0397f.sum": 19079541164.68,
        "global__amount__0397f__CZK.sum": 511808691742.54,
        "_count": 26250
    },
    {
        "global__fiscalPeriod__28951.notation": "2010",
        "global__amount__0397f.sum": 22738650575.01,
        "global__amount__0397f__CZK.sum": 597685430364.14,
        "_count": 87667
    },
    {
        "global__fiscalPeriod__28951.notation": "2011",
        "global__amount__0397f.sum": 24961375670.57,
        "global__amount__0397f__CZK.sum": 626230992823.26,
        "_count": 134352
    },
    {
        "global__fiscalPeriod__28951.notation": "2012",
        "global__amount__0397f.sum": 261513607691.41,
        "global__amount__0397f__CZK.sum": 7030666436872.5,
        "_count": 147556
    },
    {
        "global__fiscalPeriod__28951.notation": "2013",
        "global__amount__0397f.sum": 268946402299.09,
        "global__amount__0397f__CZK.sum": 7226220232913.8,
        "_count": 150079
    },
    {
        "global__fiscalPeriod__28951.notation": "2014",
        "global__amount__0397f.sum": 255222816704.9,
        "global__amount__0397f__CZK.sum": 6907598086283.4,
        "_count": 176019
    },
    {
        "global__fiscalPeriod__28951.notation": "2015",
        "global__amount__0397f.sum": 22976062973.62,
        "global__amount__0397f__CZK.sum": 636276111928.46,
        "_count": 213777
    },
    {
        "global__fiscalPeriod__28951.notation": "2016",
        "global__amount__0397f.sum": 12051686541.16,
        "global__amount__0397f__CZK.sum": 325672725401.77,
        "_count": 161797
    }
],
"order": [
    ["global__fiscalPeriod__28951.fiscalPeriod", "asc"]
],
"aggregates": ["", "_count"],
"summary": {
    "global__amount__0397f.sum": 945126777743.27,
    "global__amount__0397f__CZK.sum": 25485085887878
},
"attributes": [""]
}'

result = open_spending.ts(
  json_data =  sample.ts.data, 
  time ="global__fiscalPeriod__28951.notation",
  amount = "global__amount__0397f.sum"
  )
# Pretty output using prettify of jsonlite library
jsonlite::prettify(result,indent = 2)
```

    ## {
    ##   "acf.param": {
    ##     "acf.parameters": {
    ##       "acf": [
    ##         1,
    ##         0.6083,
    ##         0.1674,
    ##         -0.1663,
    ##         -0.1295,
    ##         -0.0727,
    ##         -0.0925,
    ##         -0.1301,
    ##         -0.1615,
    ##         -0.1959,
    ##         -0.2115,
    ##         -0.1311
    ##       ],
    ##       "acf.lag": [
    ##         0,
    ##         1,
    ##         2,
    ##         3,
    ##         4,
    ##         5,
    ##         6,
    ##         7,
    ##         8,
    ##         9,
    ##         10,
    ##         11
    ##       ],
    ##       "confidence.interval.up": [
    ##         0.5061
    ##       ],
    ##       "confidence.interval.low": [
    ##         -0.5061
    ##       ]
    ##     },
    ##     "pacf.parameters": {
    ##       "pacf": [
    ##         0.6083,
    ##         -0.3215,
    ##         -0.1865,
    ##         0.25,
    ##         -0.1593,
    ##         -0.1764,
    ##         0.0869,
    ##         -0.1346,
    ##         -0.2117,
    ##         -0.0036,
    ##         0.0508
    ##       ],
    ##       "pacf.lag": [
    ##         1,
    ##         2,
    ##         3,
    ##         4,
    ##         5,
    ##         6,
    ##         7,
    ##         8,
    ##         9,
    ##         10,
    ##         11
    ##       ],
    ##       "confidence.interval.up": [
    ##         0.5061
    ##       ],
    ##       "confidence.interval.low": [
    ##         -0.5061
    ##       ]
    ##     },
    ##     "acf.residuals.parameters": {
    ##       "acf.residuals": [
    ##         1,
    ##         0.3097,
    ##         0.2296,
    ##         -0.2346,
    ##         -0.0115,
    ##         -0.069,
    ##         -0.0524,
    ##         -0.0981,
    ##         -0.0842,
    ##         -0.1215,
    ##         -0.0934,
    ##         -0.0868,
    ##         -0.0484,
    ##         -0.2128,
    ##         -0.115,
    ##         -0.1051,
    ##         0.2946
    ##       ],
    ##       "acf.residuals.lag": [
    ##         0,
    ##         1,
    ##         2,
    ##         3,
    ##         4,
    ##         5,
    ##         6,
    ##         7,
    ##         8,
    ##         9,
    ##         10,
    ##         11,
    ##         12,
    ##         13,
    ##         14,
    ##         15,
    ##         16
    ##       ],
    ##       "confidence.interval.up": [
    ##         0.5061
    ##       ],
    ##       "confidence.interval.low": [
    ##         -0.5061
    ##       ]
    ##     },
    ##     "pacf.residuals.parameters": {
    ##       "pacf.residuals": [
    ##         0.3097,
    ##         0.1479,
    ##         -0.3857,
    ##         0.1673,
    ##         0.0455,
    ##         -0.2432,
    ##         0.0379,
    ##         0.0137,
    ##         -0.2159,
    ##         0.0048,
    ##         0.0175,
    ##         -0.1445,
    ##         -0.2757,
    ##         0.0882,
    ##         -0.0175,
    ##         0.2238
    ##       ],
    ##       "pacf.residuals.lag": [
    ##         1,
    ##         2,
    ##         3,
    ##         4,
    ##         5,
    ##         6,
    ##         7,
    ##         8,
    ##         9,
    ##         10,
    ##         11,
    ##         12,
    ##         13,
    ##         14,
    ##         15,
    ##         16
    ##       ],
    ##       "confidence.interval.up": [
    ##         0.5061
    ##       ],
    ##       "confidence.interval.low": [
    ##         -0.5061
    ##       ]
    ##     }
    ##   },
    ##   "decomposition": {
    ##     "stl.plot": {
    ##       "trend": [
    ##         -823419544.0324,
    ##         1661560665.8427,
    ##         4624784832.814,
    ##         7878983908.9168,
    ##         9164365783.7901,
    ##         1249040775.5615,
    ##         -4351015667.1447,
    ##         6551641382.3009,
    ##         57664029716.7199,
    ##         135646130025.509,
    ##         199114831580.159,
    ##         212547970271.575,
    ##         183231679544.124,
    ##         110152904455.055,
    ##         -12061960507.0845
    ##       ],
    ##       "conf.interval.up": [
    ##         100039247757.031,
    ##         66576136730.7478,
    ##         60840745924.5652,
    ##         68328241466.4622,
    ##         72409579664.1255,
    ##         65432105294.9799,
    ##         59676059485.8763,
    ##         70171989437.0366,
    ##         121691104869.741,
    ##         199829194544.927,
    ##         262360045460.495,
    ##         272997227829.121,
    ##         239447640635.875,
    ##         175067480519.96,
    ##         88800706793.9786
    ##       ],
    ##       "conf.interval.low": [
    ##         -101686086845.095,
    ##         -63253015399.0623,
    ##         -51591176258.9372,
    ##         -52570273648.6285,
    ##         -54080848096.5454,
    ##         -62934023743.857,
    ##         -68378090820.1657,
    ##         -57068706672.4349,
    ##         -6363045436.3011,
    ##         71463065506.0904,
    ##         135869617699.824,
    ##         152098712714.03,
    ##         127015718452.373,
    ##         45238328390.1502,
    ##         -112924627808.148
    ##       ],
    ##       "seasonal": {
    ## 
    ##       },
    ##       "remainder": [
    ##         1113920964.6724,
    ##         -1350318374.7727,
    ##         643715868.286,
    ##         -5336096147.9068,
    ##         5639586002.8899,
    ##         14939473570.8785,
    ##         22582051483.0347,
    ##         12527899782.3791,
    ##         -34925379141.7099,
    ##         -110684754354.939,
    ##         62398776111.2508,
    ##         56398432027.5148,
    ##         71991137160.7759,
    ##         -87176841481.4353,
    ##         24113647048.2445
    ##       ],
    ##       "time": [
    ##         2002,
    ##         2003,
    ##         2004,
    ##         2005,
    ##         2006,
    ##         2007,
    ##         2008,
    ##         2009,
    ##         2010,
    ##         2011,
    ##         2012,
    ##         2013,
    ##         2014,
    ##         2015,
    ##         2016
    ##       ]
    ##     },
    ##     "stl.general": {
    ##       "degfr": [
    ##         5.288
    ##       ],
    ##       "degfr.fitted": [
    ##         4.9747
    ##       ],
    ##       "stl.degree": [
    ##         2
    ##       ]
    ##     },
    ##     "residuals_fitted": {
    ##       "residuals": [
    ##         1113920964.6724,
    ##         -1350318374.7727,
    ##         643715868.286,
    ##         -5336096147.9068,
    ##         5639586002.8899,
    ##         14939473570.8785,
    ##         22582051483.0347,
    ##         12527899782.3791,
    ##         -34925379141.7099,
    ##         -110684754354.939,
    ##         62398776111.2508,
    ##         56398432027.5148,
    ##         71991137160.7759,
    ##         -87176841481.4353,
    ##         24113647048.2445
    ##       ],
    ##       "fitted": [
    ##         -823419544.0324,
    ##         1661560665.8427,
    ##         4624784832.814,
    ##         7878983908.9168,
    ##         9164365783.7901,
    ##         1249040775.5615,
    ##         -4351015667.1447,
    ##         6551641382.3009,
    ##         57664029716.7199,
    ##         135646130025.509,
    ##         199114831580.159,
    ##         212547970271.575,
    ##         183231679544.124,
    ##         110152904455.055,
    ##         -12061960507.0845
    ##       ],
    ##       "time": [
    ##         2002,
    ##         2003,
    ##         2004,
    ##         2005,
    ##         2006,
    ##         2007,
    ##         2008,
    ##         2009,
    ##         2010,
    ##         2011,
    ##         2012,
    ##         2013,
    ##         2014,
    ##         2015,
    ##         2016
    ##       ],
    ##       "line": [
    ##         0
    ##       ]
    ##     },
    ##     "compare": {
    ##       "resid.variance": [
    ##         2.4902231028103e+021
    ##       ],
    ##       "used.obs": [
    ##         2002,
    ##         2016,
    ##         2009,
    ##         2005.5,
    ##         2012.5
    ##       ],
    ##       "loglik": [
    ##         -1.74315617196721e+022
    ##       ],
    ##       "aic": [
    ##         3.48631234393441e+022
    ##       ],
    ##       "bic": [
    ##         3.48631234393441e+022
    ##       ],
    ##       "gcv": [
    ##         5.54416871365202e+021
    ##       ]
    ##     }
    ##   },
    ##   "model.param": {
    ##     "model": {
    ##       "arima.order": [
    ##         2,
    ##         1,
    ##         0,
    ##         0,
    ##         1,
    ##         1,
    ##         0
    ##       ],
    ##       "arima.coef": [
    ##         0.8348,
    ##         -0.249,
    ##         -0.9999
    ##       ],
    ##       "arima.coef.se": [
    ##         0.2524,
    ##         0.2482,
    ##         0.5954
    ##       ]
    ##     },
    ##     "residuals_fitted": {
    ##       "residuals": [
    ##         290501.235,
    ##         18348492.233,
    ##         4388547106.9232,
    ##         -2696772619.0425,
    ##         12279728464.2613,
    ##         1663580423.4101,
    ##         5162045969.9383,
    ##         4109968753.4051,
    ##         6995758560.2579,
    ##         5772141482.9292,
    ##         231395399804.073,
    ##         31316280480.3554,
    ##         66705685366.0788,
    ##         -149540618863.384,
    ##         33819215962.2688
    ##       ],
    ##       "fitted": [
    ##         290210919.405,
    ##         292893798.837,
    ##         879953594.1768,
    ##         5239660380.0525,
    ##         2524223322.4187,
    ##         14524933923.0299,
    ##         13068989845.9517,
    ##         14969572411.2749,
    ##         15742892014.7521,
    ##         19189234187.6408,
    ##         30118207887.337,
    ##         237630121818.735,
    ##         188517131338.821,
    ##         172516681837.004,
    ##         -21767529421.1088
    ##       ],
    ##       "time": [
    ##         2002,
    ##         2003,
    ##         2004,
    ##         2005,
    ##         2006,
    ##         2007,
    ##         2008,
    ##         2009,
    ##         2010,
    ##         2011,
    ##         2012,
    ##         2013,
    ##         2014,
    ##         2015,
    ##         2016
    ##       ],
    ##       "line": [
    ##         0
    ##       ]
    ##     },
    ##     "compare": {
    ##       "resid.variance": [
    ##         7.52601939136356e+021
    ##       ],
    ##       "variance.coef": [
    ##         [
    ##           0.0637,
    ##           -0.034,
    ##           -0.0003
    ##         ],
    ##         [
    ##           -0.034,
    ##           0.0616,
    ##           -0.0002
    ##         ],
    ##         [
    ##           -0.0003,
    ##           -0.0002,
    ##           0.3545
    ##         ]
    ##       ],
    ##       "not.used.obs": [
    ##         0
    ##       ],
    ##       "used.obs": [
    ##         14
    ##       ],
    ##       "loglik": [
    ##         -371.6686
    ##       ],
    ##       "aic": [
    ##         751.3372
    ##       ],
    ##       "bic": [
    ##         753.8934
    ##       ],
    ##       "aicc": [
    ##         755.7816
    ##       ]
    ##     }
    ##   },
    ##   "forecasts": {
    ##     "ts.model": [
    ##       "ARIMA(2,1,1)"
    ##     ],
    ##     "data_year": [
    ##       2002,
    ##       2003,
    ##       2004,
    ##       2005,
    ##       2006,
    ##       2007,
    ##       2008,
    ##       2009,
    ##       2010,
    ##       2011,
    ##       2012,
    ##       2013,
    ##       2014,
    ##       2015,
    ##       2016
    ##     ],
    ##     "data": [
    ##       290501420.64,
    ##       311242291.07,
    ##       5268500701.1,
    ##       2542887761.01,
    ##       14803951786.68,
    ##       16188514346.44,
    ##       18231035815.89,
    ##       19079541164.68,
    ##       22738650575.01,
    ##       24961375670.57,
    ##       261513607691.41,
    ##       268946402299.09,
    ##       255222816704.9,
    ##       22976062973.62,
    ##       12051686541.16
    ##     ],
    ##     "predict_time": [
    ##       2017
    ##     ],
    ##     "predict_values": [
    ##       27966099866.1595
    ##     ],
    ##     "up80": [
    ##       142431304484.384
    ##     ],
    ##     "low80": [
    ##       -86499104752.0649
    ##     ],
    ##     "up95": [
    ##       203025523588.521
    ##     ],
    ##     "low95": [
    ##       -147093323856.202
    ##     ]
    ##   }
    ## }
    ##

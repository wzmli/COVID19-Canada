This is a public open-resource page for the COVID19 testing data for Canada. 

_last updated: March 19th 22:06 Toronto time_

## COVID19 Testing Data

Our [_raw_ dataset](https://github.com/wzmli/COVID19-Canada/raw/master/COVID-19_test.csv) is compiled from available, open sources on the web – primarily provincial-level public health websites, see file for URLs 

We update once per day around 22:00 Toronto time.

This dataset contains daily reported number of positive/negative confirmed cases, presumptive cases, under investigation, and sources. 

Data before March 14, 2020 were recovered using the [Way Back Machine](https://archive.org/web/); later data are gathered daily directly from the sites. 

## Curating Data

Our [*curated* data set](https://github.com/wzmli/COVID19-Canada/raw/master/clean.Rout.csv):

* puts all of the information into a consistent format
* calculates daily incidence from cumulative cases
* corrects minor errors (using [this script](clean.R))

When possible we use summary reports from [the federal outbreak website](https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html) to check our error correction

## Testing status

_These plots are generated using the curated data_

<img src="plot.png" width="1000" height="500">

## Contacts 

- Maintainer: Michael Li 
- Email: wzmichael.li@gmail.com
- Twitter: @MLiwz1
- [Github repo](https://github.com/wzmli/COVID19-Canada)

If there are questions about the data, please contact via email or add a [github issue](https://github.com/wzmli/COVID19-Canada/issues). 

### Terms of Use

<font size="1"> This GitHub page and its contents herein, including all data, copyright 2020 McMaster University TheoBio Lab, all rights reserved, is provided to the public strictly for educational and academic research purposes.  The Website relies upon publicly available data from multiple sources, that do not always agree. The McMaster University TheoBio Lab hereby disclaims any and all representations and warranties with respect to the Website, including accuracy, fitness for use, and merchantability.  Reliance on the Website for medical guidance or use of the Website in commerce is strictly prohibited.</font>




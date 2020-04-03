library(dplyr)
library(tidyr)
library(readr)
library(zoo)
library(ggplot2);theme_set(theme_bw())

cleanname <- function(x){
	nospace <- gsub(pattern=" ", replacement="_", x)
	nobackquote <- gsub(pattern="`", replacement="", nospace)
	return(nobackquote)
}

dd <- read_csv("https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv")

colnames(dd) <- cleanname(colnames(dd))

## Create a new dataframe with ALL days


ddall <- data.frame(Reported_Date = as.Date(min(dd[["Reported_Date"]]):max(dd[["Reported_Date"]])))

ddnew <- (left_join(ddall, dd)
	%>% select(Hospitalize = "Number_of_patients_hospitalized_with_COVID-19"
		, ICU = "Number_of_patients_in_ICU_with_COVID-19"
		, Ventilator = "Number_of_patients_in_ICU_on_a_ventilator_with_COVID-19"
		, everything()
		)
	%>% mutate(New_Positive = diff(c(NA,Confirmed_Positive))
		, New_Hospitalize = diff(c(NA,Hospitalize))
		, New_ICU = diff(c(NA,ICU))
		, New_Ventilator = diff(c(NA,Ventilator))
		)
)

ddmelt <- (ddnew
	%>% gather(key="Type", value="Counts",-Reported_Date)
)

gg <- (ggplot(ddmelt, aes(x=Reported_Date, y=Counts))
	+ geom_point()
	+ geom_line()
	+ facet_wrap(~Type,scale="free")
	+ scale_x_date(date_breaks="1 month", date_labels="%b %d")
)

print(gg)

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

ddON <- read_csv("https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv")

colnames(ddON) <- cleanname(colnames(ddON))

## Create a new dataframe with ALL days


ddall <- data.frame(Reported_Date = as.Date(min(ddON[["Reported_Date"]]):max(ddON[["Reported_Date"]])))

ddONclean <- (left_join(ddall, ddON)
	%>% select(Hospitalize = "Number_of_patients_hospitalized_with_COVID-19"
		, ICU = "Number_of_patients_in_ICU_with_COVID-19"
		, Ventilator = "Number_of_patients_in_ICU_on_a_ventilator_with_COVID-19"
		, Testing = "Total_patients_approved_for_testing_as_of_Reporting_Date"
		, everything()
		)
	%>% mutate(New_Testing = diff(c(NA,Testing))
	  , New_Cases = diff(c(NA,Total_Cases))
	  , New_Confirmed = diff(c(NA,Confirmed_Positive))
	  , New_Presumptive = diff(c(NA,Presumptive_Positive))
		, New_Hospitalize = diff(c(NA,Hospitalize))
		, New_ICU = diff(c(NA,ICU))
		, New_Ventilator = diff(c(NA,Ventilator))
		)
	%>% select(Date = Reported_Date, everything())
)

ddtesting <- (ddONclean
  %>% select(Date, New_Testing, New_Cases, New_Confirmed,New_Presumptive, Under_Investigation)
  # %>% mutate(New_Case_ratio = New_Cases/New_Testing
  #     , New_Confirmed_ratio = New_Confirmed/New_Testing)
  %>% gather(key = "Type", value = "Counts", -Date)
  %>% filter(Counts>0)
)

ggtesting <- (ggplot(ddtesting, aes(x=Date,y=Counts))
  + geom_point()
  + geom_line()
  + facet_wrap(~Type,ncol=1,scale="free_y")
)

# print(ggtesting)

ddLI <- (read_csv("https://wzmli.github.io/COVID19-Canada/git_push/clean.Rout.csv")
	%>% filter(Province == "ON")
	%>% transmute(Date = Date
		, cum_positives = confirmed_positive
		, Hosp_li = Hospitalization
		, ICU_li = ICU
		, Vent_li = Ventilator
	)
)

ONreleasedate <- "2020-04-02"

ddicu <- (ddLI
	%>% select(Date, ICU=ICU_li)
	%>% filter(!is.na(ICU))
)

current <- 600
current_date <- "2020-03-30"

expansion <- 1300
expansion_date <- "2020-03-30"

ggicu <- (ggplot(ddicu, aes(x=Date, y=ICU))
	+ geom_point()
	+ geom_smooth(method="lm",formula=y~poly(x,2),color="black")
	+ scale_y_log10(breaks = c(100, 200, 300, 400, 500, 600, 1000,  + 1300))
	+ geom_hline(yintercept = current,color="red")
	+ annotate("text", label = "Current Capacity"
		, x = as.Date(current_date), y = 700, size = 8, color = "red")
	+ geom_hline(yintercept = expansion, color="blue")
	+ annotate("text", label = "Expansion Capacity"
		, x = as.Date(expansion_date), y = 1500, size = 8, color = "blue")
)

print(ggicu)

quit()

ddcombo <-(left_join(ddONclean, ddLI)
	%>% mutate(positive_diff = Confirmed_Positive + Resolved + Deaths - cum_positives
		, hosp_diff = Hospitalize - Hosp_li
		, icu_diff = ICU - ICU_li
		, vent_diff = Ventilator - Vent_li
		, Source = ifelse(Date < as.Date(ONreleasedate),"LI","ON")
  )
)

ddhosp <- (ddcombo
  %>% select(Date, Hospitalize=Hosp_li, ICU=ICU_li, Ventilator=Vent_li)
  %>% gather(key="Type", value="Cumulative_Count", -Date)
  %>% mutate(Source = ifelse(Date < as.Date(ONreleasedate),"LI","ON"))
)

ddPHO <- read_csv("https://raw.githubusercontent.com/wzmli/COVID19-Canada/master/PHO.csv")
ddPHOclean <- (ddPHO
  %>% transmute(Date=Date
      , Hospitalize = Cumulative_Hospitalized
      , ICU = Cumulative_Intensive_care
  )
  %>% gather(key="Type",value="Cumulative_Count", -Date)
)

gghosp <- (ggplot(ddhosp, aes(x=Date, y=Cumulative_Count))
  + geom_point(aes(color=Source))
  + geom_line()
  + geom_vline(xintercept = as.Date(ONreleasedate))
  + facet_wrap(~Type, nrow=3, scale="free_y")
  + scale_color_manual(values=c("red","black"))
  + xlim(c(as.Date("2020-03-15"),as.Date("2020-04-06")))
  + ggtitle("LI + ON")
)

print(gghosp)

print(gghosp
  + geom_point(data=ddPHOclean,color="blue")
  + geom_line(data=ddPHOclean,color="blue")
  + ggtitle("LI + ON + PHO")
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

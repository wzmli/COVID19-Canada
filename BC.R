library(tidyverse)

ddconfirmation <- read_csv("http://www.bccdc.ca/Health-Info-Site/Documents/BCCDC_COVID19_Dashboard_Case_Details.csv")

ddtest <- read_csv("http://www.bccdc.ca/Health-Info-Site/Documents/BCCDC_COVID19_Dashboard_Lab_Information.csv")

print(ddtest)

ddconfirm <- (ddconfirmation
	%>% mutate(Date = Reported_Date + 1) ## hack to make update time match up
	%>% group_by(Date)
	%>% summarise(SourceNewConfirmations = n())
	%>% ungroup()
	%>% mutate(Province = "BC"
		, SourceNewConfirmations = ifelse(is.na(SourceNewConfirmations), 0, SourceNewConfirmations)
		, SourceCumConfirmations = cumsum(SourceNewConfirmations)
		)
)

ddtest <- (ddtest
	%>% filter(Region == "BC")
	%>% mutate(Date = Date + 1)
	%>% select(Date, Province = Region, SourceNewTests = New_Tests, SourceTotalTests = Total_Tests) 
)

print(tail(ddtest))

BCdat <- left_join(ddtest,ddconfirm)

print(tail(BCdat))


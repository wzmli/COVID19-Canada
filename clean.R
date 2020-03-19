library(tidyverse)

dd <- read_csv("COVID-19_test.csv")

ddtotal <- (dd
	%>% rowwise()
	%>% mutate(calcTotal = sum(c(negative,presumptive_negative,under_investigation,presumptive_positive,confirmed_positive,resolved,deceased), na.rm=TRUE)
	, calcCumCases = sum(c(confirmed_positive, resolved),na.rm=TRUE)
	)
)

print(ddtotal %>% select(Province,Date,calcCumCases))



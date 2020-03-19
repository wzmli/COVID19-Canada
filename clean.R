library(tidyverse)

## Try using pmax instead of max, and see if that allows you to lose rowwise
dd <- read_csv("COVID-19_test.csv")

ddtotal <- (dd
	%>% rowwise()
	%>% mutate(calcTotal = sum(c(negative,presumptive_negative,under_investigation,presumptive_positive,confirmed_positive,resolved,deceased), na.rm=TRUE)
		, bestTotal = max(c(calcTotal,total_testing),na.rm=TRUE)
	, calcCumCases = sum(c(confirmed_positive, resolved,deceased),na.rm=TRUE)
	)
	%>% ungroup()
	%>% group_by(Province)
	%>% mutate(incidence = diff(c(calcCumCases,NA)))
)

write.csv(ddtotal,csvname)


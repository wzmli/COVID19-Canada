library(tidyverse)
library(zoo)

dd <- read_csv("COVID19_Canada.csv")

## FIXME; patch the NAs, get rid of sum and then use pmax to get rid of rowwise
## This could be part of more principled approach to patching dates
## NOTATE: We are treating presumptive_positive as confirmations
## presumptive_negative as negative; this could stand some fiddling
## based on place and time!


## Creating a full date frame, this will automatically fill in missing gaps with NA
## FIXME: Do we really need this extra step? This will help flag people that there are missing days
datevec = as.Date(min(dd[["Date"]]):max(dd[["Date"]]))
provinces <- unique(dd[["Province"]])
datedf <- data.frame(Date = rep(datevec,length(provinces))
  , Province = rep(provinces,each=length(datevec))
)

ddclean <- (left_join(datedf,dd)
	%>% left_join(.,BCdat)
	%>% rowwise()
	%>% mutate(calcTotal = sum(c(negative,presumptive_negative,presumptive_positive,confirmed_positive), na.rm=TRUE)
		, bestTotal = max(c(calcTotal,total_testing,SourceTotalTests),na.rm=TRUE)
	, cumConfirmations = sum(c(presumptive_positive,confirmed_positive),na.rm=TRUE)  ## Federal definition of a "Case" in include presumptive positive; however, if sum doesn't change but numbers changed, that is not good. Removing the sum."
	, cumConfirmations = max(c(cumConfirmations,SourceCumConfirmations),na.rm=TRUE)
	)
	%>% ungroup()
	%>% group_by(Province)
	%>% mutate(
		newConfirmations = diff(c(NA,cumConfirmations))
		, newConfirmations = ifelse(newConfirmations <0, NA, newConfirmations) ## Help fix missing reporting days
		, newTests = diff(c(NA, bestTotal))
		, newTests = ifelse(newTests <= 0, NA, newTests)
		, prop = newConfirmations/newTests
	)
	%>% ungroup()
)

## ON hospitalization feels like a misread number (replacing with guess number, see note)

summary(ddclean)

print(ddclean %>% select(Date,Province,newConfirmations,newTests),n=Inf)
write.csv(ddclean,csvname)

# ## from https://en.wikipedia.org/wiki/List_of_Canadian_provinces_and_territories_by_population
# ## could scrape
# pop_data <- (read_csv("pop.csv",comment="#")
#     %>% select(Province,pop)
# )
# 
# ddclean_p <- (left_join(ddclean,pop_data,by="Province")
#     %>% mutate(calcTotal_i=calcTotal/pop*1e5
#                , bestTotal_i=bestTotal/pop*1e5
#                , calcCumCases_i=cumConfirmations/pop*1e5
#                , deceased_i=deceased/pop*1e5
#              , frac_pos = cumConfirmations/bestTotal)
# )

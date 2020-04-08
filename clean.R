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
	%>% rowwise()
	%>% mutate(calcTotal = sum(c(negative,presumptive_negative,presumptive_positive,confirmed_positive), na.rm=TRUE)
		, bestTotal = max(c(calcTotal,total_testing),na.rm=TRUE)
	, cumConfirmations = sum(c(presumptive_positive,confirmed_positive),na.rm=TRUE)  ## This is to be consistent with Federal definition of a "Case"
	)
	%>% ungroup()
	%>% group_by(Province)
	%>% mutate(
		newConfirmations = diff(c(NA,cumConfirmations))
		, newTests = diff(c(NA, bestTotal))
	)
	%>% ungroup()
)

## ON hospitalization feels like a misread number (replacing with guess number, see note)
ddclean <- (ddclean
  %>% mutate(Hospitalization = ifelse(
      (Province == "ON")&(Date == as.Date("2020-03-26"))
      , 50
      , Hospitalization
    )
  )
)

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

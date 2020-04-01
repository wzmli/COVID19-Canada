library(tidyverse)

## Try using pmax instead of max, and see if that allows you to lose rowwise
## It will work for bestTotal I think, but I need the rowwise for calcTotal anyway and there is not a psum function

dd <- read_csv("COVID-19_test.csv")

ddtotal <- (dd
	%>% rowwise()
	%>% mutate(calcTotal = sum(c(negative,presumptive_negative,under_investigation,presumptive_positive,confirmed_positive,resolved,deceased), na.rm=TRUE)
		, bestTotal = max(c(calcTotal,total_testing),na.rm=TRUE)
	, calcCumCases = sum(c(presumptive_positive,confirmed_positive, resolved,deceased),na.rm=TRUE)
	)
	%>% ungroup()
	%>% group_by(Province)
	%>% mutate(incidence = diff(c(NA,calcCumCases)))
)

## MB only reported +ve cases, but separated on March 20th
ddtotal <- (ddtotal
  %>% mutate(calcCumCases = ifelse(
    (Province == "MB")&(Date %in% c(as.Date("2020-03-17"):as.Date("2020-03-20")))
      , 8
      , calcCumCases)
  )
)

print(tail(ddtotal %>% filter(Province == "ON") %>% select(Date, calcCumCases, incidence)))

write.csv(ddtotal,csvname)

# ## from https://en.wikipedia.org/wiki/List_of_Canadian_provinces_and_territories_by_population
# ## could scrape
# pop_data <- (read_csv("pop.csv",comment="#")
#     %>% select(Province,pop)
# )
# 
# ddtotal_p <- (left_join(ddtotal,pop_data,by="Province")
#     %>% mutate(calcTotal_i=calcTotal/pop*1e5
#                , bestTotal_i=bestTotal/pop*1e5
#                , calcCumCases_i=calcCumCases/pop*1e5
#                , deceased_i=deceased/pop*1e5
#              , frac_pos = calcCumCases/bestTotal)
# )

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

write.csv(ddtotal,csvname)

## here's a way to do it without rowwise() if you prefer
## (clunky in a different way)
cumcase_names <- c("confirmed_positive","resolved","deceased")
nasum <- function(x) sum(x, na.rm=TRUE)
## alternative
ddtotal2 <- (dd
    %>% pivot_longer(-c(Province,Date,source))
    %>% group_by(Province,Date,source)  ## don't need source but it preserves it
    %>% summarise(calcTotal=nasum(value[name!="total_testing"])
                , bestTotal=max(calcTotal,
                                value[name=="total_testing"], na.rm=TRUE)
                , calcCumCases = nasum(value[name %in% cumcase_names])
                  )
    %>% ungroup()
    %>% group_by(Province)
    %>% mutate(incidence = diff(c(calcCumCases,NA)))
)

ddtotal2 <- full_join(dd,ddtotal2, by=c("Province", "Date", "source"))
all.equal(ddtotal,ddtotal2)

## from https://en.wikipedia.org/wiki/List_of_Canadian_provinces_and_territories_by_population
## could scrape
pop_data <- (read_csv("pop.csv",comment="#")
    %>% select(Province,pop)
)

ddtotal_p <- (left_join(ddtotal,pop_data,by="Province")
    %>% mutate(calcTotal_i=calcTotal/pop*1e5
               , bestTotal_i=bestTotal/pop*1e5
               , calcCumCases_i=calcCumCases/pop*1e5
               , deceased_i=deceased/pop*1e5
             , frac_pos = calcCumCases/bestTotal)
)

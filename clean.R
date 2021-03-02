library(tidyverse)
library(zoo)
library(shellpipes)

## startGraphics()

dd <- csvRead()
commandEnvironments()

## FIXME: csvname

csvname <- "clean.Rout.csv"

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
	, cumConfirmations = ifelse((Province=="BC") & is.na(SourceCumConfirmations),NA,cumConfirmations) 
	)
	%>% ungroup()
	%>% group_by(Province)
	%>% mutate(
		newConfirmations = diff(c(NA,cumConfirmations))
		, newConfirmations = ifelse(newConfirmations <0, NA, newConfirmations) ## Help fix missing reporting days
		, newTests = diff(c(NA, bestTotal))
		, prop = newConfirmations/newTests
	)
	%>% ungroup()
)

## ON hospitalization feels like a misread number (replacing with guess number, see note)

summary(ddclean)

print(ddclean %>% select(Date,Province,newConfirmations,newTests),n=Inf)
write.csv(ddclean,csvname)

saveVars(ddclean)

library(shellpipes)
library(dplyr)
library(tidyr)
library(readr)

commandEnvironments()

print(names(dat))

screen <- csvRead()

summary(screen)

surv <- (dat
	%>% select(Date, newTests, newConfirmations)
)

print(surv)

mergedat <- (full_join(screen, surv)
	%>% mutate(
		N501Y_est = newConfirmations*N501Y/N501Y_screen
		, other_est = newConfirmations-N501Y_est
	)
)

print(mergedat)

longdat <- (mergedat
	%>% select(date=Date, other_est, N501Y_est, newConfirmations)
	%>% pivot_longer(cols=!date, names_to="type", values_to="count")
)

saveVars(longdat, screen)


library(dplyr)
names(ddclean)

print(ddclean
	%>% filter(Province=="ON")
	%>% select(Date, newConfirmations, newTests)
	%>% filter(max(Date)-Date < 14)
)

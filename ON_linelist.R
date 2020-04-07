## Ontario Public line list from https://github.com/ishaberry/Covid19Canada
## We want to recover hospitlization data

library(tidyverse)

rawll <- read_csv("https://raw.githubusercontent.com/ishaberry/Covid19Canada/master/cases.csv")

ONll <- (rawll
	%>% filter(province == "Ontario")
)

ONllclean <- (ONll
  %>% select(date_report, additional_info)
  %>% filter(additional_info %in% c("Admitted to hospital","Hospitalized"))   
  %>% transmute(Date = )
)

library(shellpipes)
library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw(base_size=12))

commandEnvironments()

print(screen)

dd <- (screen 
	%>% select(-source)
	%>% gather(key="var",value="value",-Date)
)

print(dd)

gg <- (ggplot(dd, aes(x=Date,y=value))
	+ geom_point()
	+ facet_wrap(~var,scale="free",nrow=3)
)

print(gg)

longdat <- (longdat
#	%>% filter(date >= as.Date("2021-02-17"))
	%>% filter(type != "newConfirmations")
	%>% filter(!is.na(count))
	%>% mutate(type = relevel(factor(type),"other_est"))
)

p0 <- (ggplot(filter(longdat,between(date,as.Date("2021-02-17"),as.Date("2021-02-24"))))
	+ aes(date, count, fill=type)
#	+ geom_line()
#	+ geom_point()
	+ geom_area()
#	+ scale_y_log10()
	+ expand_limits(y=0)
)

print(p0 %+% filter(longdat, date > max(date) - 60))
print(p0 %+% filter(longdat, date > max(date) - 15))

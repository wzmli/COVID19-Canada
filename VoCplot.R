library(shellpipes)
library(tidyverse)
library(directlabels)
library(ggplot2); theme_set(theme_bw(base_size=12))

startGraphics()
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

# print(gg)

longdat <- (longdat
#	%>% filter(!is.na(count))
	%>% mutate(type = factor(type,levels=c("newConfirmations","other_est","N501Y_est"))
	)
)

print(longdat)

p0 <- (ggplot(longdat)
	+ aes(date, count, color=type)
	+ geom_line()
	+ geom_point()
#	+ geom_area()
#	+ scale_y_log10()
	+ scale_color_manual(values=c("black","blue","red"))
	+ expand_limits(y=0)
	+ geom_dl(aes(label = type), method = list(dl.combine("last.points")), cex = 0.8)
	+ theme(legend.position = "none")
)


print(ggvoc <- p0 %+% filter(longdat, between(date,as.Date("2021-02-12"),max(longdat$date)))
	+ xlim(c(as.Date("2021-02-12"),max(longdat$date) + 4))
)


longdat2 <- (longdat
	%>% mutate(count = ifelse(((date >= as.Date("2021-02-12")) & (type == "newConfirmations")), NA, count)
	)
)

ggstack <- (ggplot(longdat2,aes(x=date,y=count,fill=type))
	+ geom_bar(position = "stack",stat="identity")
	+ scale_fill_manual(values=c("black","blue","red"))
#	+ xlim(c(as.Date("2020-11-01"),max(longdat$date)))
	+ theme(legend.position = "bottom")
)

print(ggstack)
ggsave(plot=ggvoc,filename = "ggvoc.png",width = 8, height = 6)

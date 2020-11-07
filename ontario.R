library(tidyverse)
library(cowplot)
library(ggplot2)
theme_set(theme_bw())

dd <- ddclean

filterdate <- as.Date("2020-08-31")

dat <- (dd
	%>% filter(Province == "ON")
	%>% select(Date
		, Backlog = under_investigation
		, cumConfirmations, newConfirmations
		, cumTests = bestTotal, newTests
		, Hospitalization, ICU, Ventilator
		, Deaths = deceased, Resolved = resolved
		)
	%>% mutate(Backlog_ratio = Backlog/newTests
		, positivity = newConfirmations/newTests
		, diffBacklog = diff(c(0,Backlog))
		, diffBacklog_ratio = diffBacklog/newTests
		, collect = newTests + diffBacklog
		)
	%>% filter(Date > filterdate)
)

print(head(dat %>% select(Date,Backlog,diffBacklog)))


meltdat <- (dat
	%>% gather(key = "type", value="value",-Date)
	%>% filter(is.finite(value))
)

hotdat <- (meltdat
	%>% filter(type %in% (c("newConfirmations", "positivity")))
)

print(tail(meltdat))

gg_ontario <- (ggplot(meltdat, aes(Date,value))
	+ geom_point()
	+ geom_smooth()
	+ facet_wrap(~type,scale="free",ncol=1)
#	+ ylim(c(-1,NA))
	+ scale_x_date(date_breaks="2 week", date_labels = "%m/%d")
	+ xlim(c(as.Date(min((meltdat$Date))),as.Date(max(meltdat$Date)+3)))
)

gg_backlog <- gg_ontario %+% filter(meltdat,type == "Backlog")
gg_positivity <- (gg_ontario %+% filter(meltdat,type == "positivity")
	+ ylim(0,0.05)
)

gg_newTests <- gg_ontario %+% filter(meltdat,type=="newTests")
gg_ratio <- gg_ontario %+% filter(meltdat, type == "Backlog_ratio") + geom_hline(yintercept=1)

print(gg_pos <- gg_ontario %+% hotdat)


ggsave(gg_pos, filename="ggpos.png", width = 6, height=6) 

gg_ontario_backlog1 <- plot_grid(gg_backlog,gg_newTests,ncol=2)
gg_ontario_backlog <- plot_grid(gg_ontario_backlog1, gg_ratio, nrow=2)

print(gg_ontario_backlog)

ggsave(gg_ontario_backlog, filename="ggbacklog.png", width = 6, height=6) 
gg_all <- plot_grid(gg_positivity, gg_backlog, gg_newTests, gg_ratio, ncol=2)

# print(gg_all)


## Backlog ratios 

gg_ratio2 <- (ggplot(dat, aes(x=Date))
	+ geom_line(aes(y=newTests),color="red")
	+ geom_line(aes(y=Backlog), color = "black")
)

# print(gg_ratio2)

## Diff Backlog

gg_diffbacklog <- gg_ontario %+% filter(meltdat, type == "diffBacklog") + geom_hline(aes(yintercept=0)) + ggtitle("Daily new backlogs")
gg_diffbacklog_ratio <- gg_ontario %+% filter(meltdat, type == "diffBacklog_ratio")
gg_diff <- (ggplot(dat
	, aes(x=Date)
	)
	+ geom_line(aes(y=collect), color="black")
	+ geom_point(aes(y=collect), color="black")
	+ geom_point(aes(y=newTests), color="red")
	+ scale_x_date(date_breaks="2 week", date_labels = "%m/%d")
	+ ylab("Daily Counts")
	+ ggtitle("Collect (black) and Test (red)")
)

gg_diffs <- plot_grid(gg_diffbacklog, gg_diff, nrow=2)

#print(gg_diffbacklog)
#print(gg_diffbacklog_ratio)

print(gg_diffs)


ggsave(gg_diffs, filename="ggdiffs.png", width = 6, height=6) 



library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(ggforce)
library(gridExtra)
library(colorspace)

label_dat <- (ddtotal
    %>% filter(Date == max(Date))
    %>% mutate(lab_positives = paste0(Province,":",cumConfirmations)
               , lab_total = paste0(Province,":",bestTotal)
               , lab_incidence = paste0(Province, ":",newConfirmations)
               , Date = Date+5)
)

## All done for Mark Loeb; probably should be a separate file
ddcountry <- (ddtotal
   %>% group_by(Date)
   %>% summarise(newConfirmations = sum(newConfirmations,na.rm=TRUE))
)

print(ddcountry,n=50)

ggincidence <- (ggplot(ddcountry, aes(x=Date,y=newConfirmations))
  + geom_point()
  + geom_line()
  + ggtitle("New reported COVID-19 cases")
)
print(ggincidence)
## ggsave(plot=ggincidence,filename="CAincidence.png")

## FIXME:: DRY: how different are these two plots??
##  could this be done with faceting?

## for boldfacing parts of titles below,
##  could use expression('... bold(...) ...'); parse(text=...) is
##  more flexible, could be used to incorporate variables etc.

## plot(0:1,0:1,type="n")
## text(0.5,0.5,expression('zzz'~bold('abc')~'aaa'))
## text(0.1,0.1,parse(text="'zzz'~bold('abc')~'aaa'"))

## Cumulative reports FIXME: Change variable names?
gg <- (ggplot(ddtotal, aes(x=Date, y=cumConfirmations,color=Province))
        + scale_colour_discrete_qualitative()
	+ scale_y_continuous(trans="log2")
	+ scale_x_date()
	+ geom_text_repel(data=label_dat,aes(label = lab_positives)
	  , hjust = -10
	  , direction = "y"
	  , size = 3
	  # , nudge_y = 5
	  , segment.color = NA
	  , show.legend = FALSE
	  )
        + geom_line()
        + ggtitle(parse(text="'Cumulative Reported'~bold('Positive')~'Tests'"))
	+ theme(legend.position = "none", axis.title.y=element_blank()
	        , plot.title = element_text(vjust=-10,hjust=0.1,size=10))
)

print(gg)

### Cumulative tests
gg2 <- (ggplot(ddtotal, aes(x=Date, y=bestTotal,color=Province))
       + scale_colour_discrete_qualitative()
       + scale_y_continuous(trans="log2")
       + scale_x_date()
       + geom_text_repel(data=label_dat,aes(label = lab_total)
                         , hjust = -10
                         , direction = "y"
                         , size = 3
                         # , nudge_y = 5
                         , segment.color = NA
                         , show.legend = FALSE
       )
       + geom_line()
       + ggtitle(parse(text="'Cumulative Reported'~bold('Total')~'Tests'"))
       + theme(legend.position = "none", axis.title.y=element_blank()
               , plot.title = element_text(vjust=-10,hjust=0.1,size=10))
)

print(gg2)
ggcombo <- grid.arrange(gg,gg2,nrow=1)
print(ggcombo)
ggsave(plot=ggcombo,filename = "plot.png",width = 10, height = 6)

## Daily confirmations
gg3 <- (ggplot(ddtotal, aes(x=Date, y=newConfirmations,color=Province))
        + scale_colour_discrete_qualitative()
        + scale_y_continuous(trans="log2")
        + scale_x_date()
        + geom_text_repel(data=label_dat,aes(label = lab_incidence)
                          , hjust = -10
                          , direction = "y"
                          , size = 3
                          # , nudge_y = 5
                          , segment.color = NA
                          , show.legend = FALSE
        )
        + geom_line()
        + ggtitle(parse(text="'New Reported'~bold('Positive')~'Tests'"))
        + theme(legend.position = "none", axis.title.y=element_blank()
                , plot.title = element_text(vjust=-10,hjust=0.1,size=10))
)

print(gg3)

## Daily combo

print(gg3
	+ geom_line(aes(y=newTests), color="black")
	+ facet_wrap_paginate(~Province, nrow=1, ncol=1, page=9)
)

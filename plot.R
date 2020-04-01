library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(gridExtra)
library(colorspace)

label_dat <- (ddtotal
    %>% filter(Date == max(Date))
    %>% mutate(lab_positives = paste0(Province,":",calcCumCases)
               , lab_total = paste0(Province,":",bestTotal)
               , lab_incidence = paste0(Province, ":",incidence)
               , Date = Date+5)
)

ddcountry <- (ddtotal
   %>% group_by(Date)
   %>% summarise(incidence = sum(incidence,na.rm=TRUE))
)

print(ddcountry,n=50)

ggincidence <- (ggplot(ddcountry, aes(x=Date,y=incidence))
  + geom_point()
  + geom_line()
  + ggtitle("New reported COVID-19 cases")
)

print(ggincidence)

## FIXME:: DRY: how different are these two plots??
##  could this be done with faceting?

## for boldfacing parts of titles below,
##  could use expression('... bold(...) ...'); parse(text=...) is
##  more flexible, could be used to incorporate variables etc.

## plot(0:1,0:1,type="n")
## text(0.5,0.5,expression('zzz'~bold('abc')~'aaa'))
## text(0.1,0.1,parse(text="'zzz'~bold('abc')~'aaa'"))


gg <- (ggplot(ddtotal, aes(x=Date, y=calcCumCases,color=Province))
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
ggcombo

gg3 <- (ggplot(ddtotal, aes(x=Date, y=incidence,color=Province))
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

print(ggcombo)

ggsave(plot=ggincidence,filename="CAincidence.png")

ggsave(plot=ggcombo,filename = "plot.png",width = 10, height = 6)

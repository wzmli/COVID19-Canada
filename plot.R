library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(ggforce)
library(gridExtra)
library(colorspace)

label_dat <- (ddclean
    %>% filter(Date == max(Date))
    %>% mutate(lab_positives = paste0(Province,":",cumConfirmations)
               , lab_total = paste0(Province,":",bestTotal)
               , lab_newConfirmations = paste0(Province, ":",newConfirmations)
               , Date = Date+5)
)

## FIXME:: DRY: how different are these two plots??
##  could this be done with faceting?

## for boldfacing parts of titles below,
##  could use expression('... bold(...) ...'); parse(text=...) is
##  more flexible, could be used to incorporate variables etc.

## plot(0:1,0:1,type="n")
## text(0.5,0.5,expression('zzz'~bold('abc')~'aaa'))
## text(0.1,0.1,parse(text="'zzz'~bold('abc')~'aaa'"))

## Cumulative reports 
ddcumreport <- ddclean %>% filter(cumConfirmations>0)

gg <- (ggplot(ddcumreport, aes(x=Date, y=cumConfirmations,color=Province))
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

ddcumtest <- ddclean %>% filter(bestTotal>0)

gg2 <- (ggplot(ddcumtest, aes(x=Date, y=bestTotal,color=Province))
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

## Daily new report
gg3 <- (ggplot(ddclean, aes(x=Date, y=newConfirmations,color=Province))
        + scale_colour_discrete_qualitative()
        + scale_y_continuous(trans="log2")
        + scale_x_date()
        + geom_text_repel(data=label_dat,aes(label = lab_newConfirmations)
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

print(gg3
	+ geom_line(aes(y=newTests), color="black")
	+ facet_wrap_paginate(~Province, nrow=1, ncol=1, page=9)
)


## Hospitalization
ddhosp <- (ddclean
  %>% select(Date, Province, Hospitalization, ICU, Ventilator)
  %>% gather(key="HospType",value="Count",-Date,-Province)
  %>% filter(!is.na(Count)&(Count>0))
  %>% mutate(Province = factor(Province,levels = c("BC","AB","ON","QC","SK","MB","NB","NS","PEI","NL","YU","NWT","NU")))
)

gghosp <- (ggplot(ddhosp, aes(x=Date, y=Count,color=HospType))
       + scale_x_date()
       # + geom_text_repel(data=label_dat,aes(label = lab_positives)
       #                   , hjust = -10
       #                   , direction = "y"
       #                   , size = 3
       #                   # , nudge_y = 5
       #                   , segment.color = NA
       #                   , show.legend = FALSE
       # )
       + geom_line()
       + geom_point()
       # + ggtitle(parse(text="'Cumulative Reported'~bold('Positive')~'Tests'"))
       + theme(legend.position = "bottom", axis.title.y=element_blank()
               , plot.title = element_text(vjust=-10,hjust=0.1,size=10))
       + facet_wrap(~Province,nrow=2, scale="free")
       + scale_colour_manual(values=c("black","red","blue"))

)

print(gghosp)
ggsave(plot=gghosp,filename = "plothosp.png",width = 10, height = 6)

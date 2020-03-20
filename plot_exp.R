library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(gridExtra)
library(colorspace)

load(".clean.RData")

label_dat <- (ddtotal
    %>% filter(Date == max(Date))
    %>% mutate(lab_positives = paste0(Province,":",calcCumCases)
               , lab_total = paste0(Province,":",bestTotal)
               , Date = Date+3)
)

dd_long <- (ddtotal
    %>% select(Date, calcCumCases, bestTotal, Province)
    %>% tidyr::pivot_longer(-c(Date,Province))
    %>% group_by(Province,name)
    %>% mutate(lab=paste0(Province,":",tail(value,1)))
    %>% ungroup()
)

lab_data <- (dd_long
    %>% group_by(Province,name)
    %>% summarise(Date=max(Date),
                  lab=tail(lab,1))
)

## why is last.points putting things in the wrong place?
(ggplot(dd_long, aes(x=Date, y=value, color=Province))
    + scale_colour_discrete_qualitative()
    + scale_y_continuous(trans="log2")
    + scale_x_date()
    ## + geom_dl(aes(label=lab,x=max(Date)+1),method="last.bumpup")
    + expand_limits(x=max(dd_long$Date)+8)
    + geom_line()
    + theme(legend.position = "none", axis.title.y=element_blank()
            ## , plot.title = element_text(vjust=-10,hjust=0.1,size=10)
            )
    + facet_wrap(~name,scale="free_y")
)

gg <- (ggplot(ddtotal, aes(x=Date, y=calcCumCases,color=Province))
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

gg3 <- grid.arrange(gg,gg2,nrow=1)
gg3

ggsave(plot=gg3,filename = "plot.png",width = 10, height = 5)


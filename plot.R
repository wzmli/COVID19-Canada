library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(gridExtra)

label_dat <- (ddtotal
    %>% filter(Date == as.Date("2020-03-18"))
    %>% mutate(lab_positives = paste0(Province,":",calcCumCases)
               , lab_total = paste0(Province,":",bestTotal)
               , Date = Date+3)
)

gg <- (ggplot(ddtotal, aes(x=Date, y=calcCumCases,color=Province))
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
	+ ggtitle("Cumulative Reported POSITIVE Tests")
	+ theme(legend.position = "none", axis.title.y=element_blank()
	        , plot.title = element_text(vjust=-10,hjust=0.1,size=10))
)


print(gg)

gg2 <- (ggplot(ddtotal, aes(x=Date, y=bestTotal,color=Province))
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
       + ggtitle("Cumulative Reported TOTAL Tests")
       + theme(legend.position = "none", axis.title.y=element_blank()
               , plot.title = element_text(vjust=-10,hjust=0.1,size=10))
)

print(gg2)

gg3 <- grid.arrange(gg,gg2,nrow=1)
gg3

ggsave(plot=gg3,filename = "plot.png",width = 10, height = 5)


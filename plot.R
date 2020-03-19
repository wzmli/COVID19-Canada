library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)

label_dat <- (ddtotal
    %>% filter(Date == as.Date("2020-03-18"))
    %>% mutate(lab = paste0(Province,":",calcCumCases)
               , Date = Date+2)
)

gg <- (ggplot(ddtotal, aes(x=Date, y=calcCumCases,color=Province))
	+ scale_y_continuous(trans="log2")
	+ scale_x_date()
	+ geom_text_repel(data=label_dat,aes(label = lab)
	  , hjust = -10
	  , direction = "y"
	  # , nudge_y = 5
	  , segment.color = NA
	  , show.legend = FALSE
	  )
	+ geom_line()
	+ ylab("Cumulative Cases")
	+ theme(legend.position = "none")
)


print(gg)





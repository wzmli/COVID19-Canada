library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(gridExtra)
library(colorspace)


ddcountry <- (ddclean
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

print(ggincidence + scale_y_log10())

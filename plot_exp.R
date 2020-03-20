library(ggplot2);theme_set(theme_bw())
library(directlabels)
library(tidyverse)
library(ggrepel)
library(gridExtra)
library(colorspace)

load(".clean.RData")


dd_long <- (ddtotal_p
    ## FIXME: fragile, depends on order
    %>% select(Province, Date, bestTotal:incidence,
               bestTotal_i:frac_pos)
    %>% tidyr::pivot_longer(-c(Date,Province,frac_pos))
    %>% group_by(Province,name)
    ## FIXME: do we still want all the numbers?
    %>% mutate(lab=paste0(Province,": ",round(tail(value,1))))
    %>% ungroup()
)

lab_data <- (dd_long
    %>% group_by(Province,name)
    %>% summarise(Date=max(Date),
                  lab=tail(lab,1))
)

dm <- list(dl.trans(x=x+0.2),cex=0.5,last.bumpup)
## http://directlabels.r-forge.r-project.org/examples.html
## n.b. can't mess with x aesthetic in geom_dl
(ggplot(dd_long, aes(x=Date, y=value, color=Province))
    + scale_colour_discrete_qualitative()
    + scale_y_continuous(trans="log2",expand=expansion(mult=0.1,add=1))
    + scale_x_date()
    + geom_dl(aes(label=lab),method=dm)
    + expand_limits(x=max(dd_long$Date)+12)
    + geom_line()
    + theme(legend.position = "none", axis.title.y=element_blank()
            ## , plot.title = element_text(vjust=-10,hjust=0.1,size=10)
            )
    + facet_wrap(~name,scale="free_y")
)

ggsave("plot_exp.png",width=8,height=4)

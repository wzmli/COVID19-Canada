library(ggplot2);theme_set(theme_bw())
library(tidyverse)

gg <- (ggplot(ddtotal, aes(x=Date, color=Province))
	+ scale_y_continuous(trans="log2")
)

print(gg + geom_line(aes(y=confirmed_positive)))

print(gg + geom_line(aes(y=calcCumCases)))

print(gg + geom_line(aes(y=calcCumCases/calcTotal)))




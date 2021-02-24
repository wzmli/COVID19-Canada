current: target
-include target.mk

-include makestuff/perl.def

Drop = ~/Dropbox

######################################################################

## pages are on master branch
# https://wzmli.github.io/COVID19-Canada
# https://wzmli.github.io/COVID19-Canada/README.md
# https://github.com/wzmli/COVID19-Canada/blob/master/README.md
Sources += README.md index.md


## pages are on master branch

######################################################################

vim_session: 
	bash -cl "vmt index.md README.md"
Sources += $(wildcard *.R)

######################################################################

Sources += raw_notes.txt
Sources += COVID19_Canada.csv
Sources += capacity.csv

BC.Rout: BC.R
	$(run-R)

## clean.Rout.csv: clean.R ;
clean.Rout: COVID19_Canada.csv BC.Rout clean.R
	$(run-R)

ON_confirmations.Rout: clean.Rout ON_confirmations.R
	$(run-R)

## plot.png: plot.R
Ignore += plot.png plothosp.png ggtoday.png
plot.png: plot.Rout ;
plothosp.png: plot.Rout ; 
plot.Rout: clean.Rout plot.R
	$(run-R)

plot_exp.Rout: clean.Rout plot_exp.R
	$(run-R)

canada.Rout: clean.Rout canada.R
	$(run-R)

reset_bc: 
	touch BC.R
Ignore += ggpos.png ggbacklog.png ggdiffs.png

ggpos.png: ontario.Rout
ggbacklog.png: ontario.Rout
ggdiffs.png: ontario.Rout

ontario.Rout: ontario.R clean.Rout
	$(run-R)

# update: reset_bc clean.Rout.csv.gp plot.png.gp plothosp.png.gp ggtoday.png.gp ggpos.png.gp ggbacklog.png.gp ggdiffs.png.gp


update: reset_bc clean.Rout.csv.gp ggpos.png.gp ggbacklog.png.gp ggdiffs.png.gp

## git mv CAincidence.png plot.png clean.Rout.csv ON.Rout.pdf git_push ##
## git add plot.png CAincidence.png ON.Rout.pdf  ##


README.gh.html: README.md

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

-include makestuff/wrapR.mk
## -include makestuff/pandoc.mk

-include makestuff/git.mk
-include makestuff/texdeps.mk
-include makestuff/visual.mk
-include makestuff/hotcold.mk
-include makestuff/cihrpaste.mk
-include makestuff/pandoc.mk
-include makestuff/projdir.mk

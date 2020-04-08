current: target
-include target.mk

-include makestuff/perl.def

Drop = ~/Dropbox

######################################################################

## https://wzmli.github.io/COVID19-Canada/ 
## pages are on master branch
Sources += README.md
Sources += index.md

######################################################################

vim_session: 
	bash -cl "vmt index.md README.md"
Sources += $(wildcard *.R)

######################################################################

Sources += raw_notes.txt
Sources += COVID19_Canada.csv

## clean.Rout.csv: clean.R ;
clean.Rout: COVID19_Canada.csv clean.R
	$(run-R)

plot.png: plot.Rout
plot.Rout: clean.Rout plot.R
	$(run-R)

plot_exp.Rout: clean.Rout plot_exp.R
	$(run-R)

update: clean.Rout.csv.gp plot.png.gp

## git mv CAincidence.png plot.png clean.Rout.csv ON.Rout.pdf git_push ##
## git add plot.png CAincidence.png ON.Rout.pdf  ##


README.gh.html: README.md

######################################################################

ON.Rout: ON.R
	$(run-R)

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
